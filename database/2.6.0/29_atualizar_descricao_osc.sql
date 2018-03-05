DROP FUNCTION IF EXISTS portal.atualizar_descricao_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_descricao_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER) RETURNS TABLE(
	mensagem TEXT,
	flag BOOLEAN
)AS $$

DECLARE
	nome_tabela TEXT;
	fonte_dados RECORD;
	objeto RECORD;
	dado_anterior RECORD;
	dado_posterior RECORD;
	flag_update BOOLEAN;
	osc INTEGER;

BEGIN
	RAISE NOTICE '%', nome_tabela;
	nome_tabela := 'osc.atualizar_dados_gerais';
	tipo_identificador := lower(tipo_identificador);

	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);

	IF fonte_dados IS null THEN
		RAISE EXCEPTION 'fonte_invalida';
	END IF;

	IF tipo_identificador = 'cnpj' THEN
		SELECT id_osc INTO osc FROM osc.tb_osc WHERE cd_identificador_osc = identificador;
	ELSIF tipo_identificador = 'id_osc' THEN
		SELECT id_osc INTO osc FROM osc.tb_osc WHERE id_osc = identificador;
	ELSE
		RAISE EXCEPTION 'tipo_identificador_invalido';
	END IF;
	
	IF osc IS null THEN
		RAISE EXCEPTION 'osc_nao_encontrada';
	ELSIF osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	END IF;

	SELECT INTO objeto * FROM jsonb_populate_record(null::osc.tb_dados_gerais, json);

	SELECT INTO dado_anterior * FROM osc.tb_dados_gerais WHERE id_osc = osc;
	
	IF dado_anterior.id_osc IS null THEN
		INSERT INTO osc.tb_dados_gerais (
			id_osc,
			tx_missao_osc,
			ft_missao_osc,
			tx_visao_osc,
			ft_visao_osc,
			tx_link_estatuto_osc,
			bo_nao_possui_link_estatuto_osc,
			ft_link_estatuto_osc,
			tx_historico,
			ft_historico,
			tx_finalidades_estatutarias,
			ft_finalidades_estatutarias
		) VALUES (
			osc,
			objeto.tx_missao_osc,
			fonte_dados.nome_fonte,
			objeto.tx_visao_osc,
			fonte_dados.nome_fonte,
			objeto.tx_link_estatuto_osc,
			objeto.bo_nao_possui_link_estatuto_osc,
			fonte_dados.nome_fonte,
			objeto.tx_historico,
			fonte_dados.nome_fonte,
			objeto.tx_finalidades_estatutarias,
			fonte_dados.nome_fonte
		) RETURNING * INTO dado_posterior;

		PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, null, row_to_json(dado_posterior),id_carga);

	ELSE
		dado_posterior := dado_anterior;
		flag_update := false;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_missao_osc::TEXT, dado_anterior.ft_missao_osc, objeto.tx_missao_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_missao_osc := objeto.tx_missao_osc;
			dado_posterior.ft_missao_osc := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_visao_osc::TEXT, dado_anterior.ft_visao_osc, objeto.tx_visao_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_visao_osc := objeto.tx_visao_osc;
			dado_posterior.ft_visao_osc := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;
		
		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_link_estatuto_osc::TEXT, dado_anterior.ft_link_estatuto_osc, objeto.tx_link_estatuto_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_link_estatuto_osc := objeto.tx_link_estatuto_osc;
			dado_posterior.ft_link_estatuto_osc := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;
		
		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.bo_nao_possui_link_estatuto_osc::TEXT, dado_anterior.ft_link_estatuto_osc, objeto.bo_nao_possui_link_estatuto_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.bo_nao_possui_link_estatuto_osc := objeto.bo_nao_possui_link_estatuto_osc;
			dado_posterior.ft_link_estatuto_osc := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;
		
		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_historico::TEXT, dado_anterior.ft_historico, objeto.tx_historico::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_historico := objeto.tx_historico;
			dado_posterior.ft_historico := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_finalidades_estatutarias::TEXT, dado_anterior.ft_finalidades_estatutarias, objeto.tx_finalidades_estatutarias::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_finalidades_estatutarias := objeto.tx_finalidades_estatutarias;
			dado_posterior.ft_finalidades_estatutarias := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF flag_update THEN
			UPDATE osc.tb_dados_gerais
			SET tx_missao_osc = dado_posterior.tx_missao_osc,
				ft_missao_osc = dado_posterior.ft_missao_osc,
				tx_visao_osc = dado_posterior.tx_visao_osc,
				ft_visao_osc = dado_posterior.ft_visao_osc,
				tx_link_estatuto_osc = dado_posterior.tx_link_estatuto_osc,
				bo_nao_possui_link_estatuto_osc = dado_posterior.bo_nao_possui_link_estatuto_osc,
				ft_link_estatuto_osc = dado_posterior.ft_link_estatuto_osc,
				tx_historico = dado_posterior.tx_historico,
				ft_historico = dado_posterior.ft_historico
			WHERE id_osc = osc;
			
			PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior),id_carga);
			
		END IF;
	END IF;
	
	flag := true;
	mensagem := 'Descrição de OSC atualizado.';
	
	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, identificador, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		
		RAISE NOTICE 'mensagem: %', mensagem;
		
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
