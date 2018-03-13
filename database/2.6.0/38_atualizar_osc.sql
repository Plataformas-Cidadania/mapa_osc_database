DROP FUNCTION IF EXISTS portal.atualizar_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER) RETURNS TABLE(
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
	nome_tabela := 'osc.tb_osc';
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

	IF(objeto.bo_nao_possui IS true && (SELECT EXISTS(SELECT * FROM osc.tb_projeto WHERE id_osc = osc)) IS true) THEN
		RAISE EXCEPTION 'nao_possui_invalido';
	END IF;

	SELECT INTO objeto * FROM jsonb_populate_record(null::osc.tb_osc, json);

	SELECT INTO dado_anterior * FROM osc.tb_osc WHERE id_osc = osc;

	IF dado_anterior.id_osc IS null THEN
		INSERT INTO osc.tb_osc (
			id_osc,
			tx_apelido_osc,
			ft_apelido_osc,
			cd_identificador_osc,
			ft_identificador_osc,
			bo_osc_ativa,
			ft_osc_ativa,
			bo_nao_possui_projeto,
			ft_nao_possui_projeto
		) VALUES (
			osc,
			objeto.tx_apelido_osc,
			fonte_dados.nome_fonte,
			objeto.cd_identificador_osc,
			fonte_dados.nome_fonte,
			objeto.bo_osc_ativa,
			fonte_dados.nome_fonte,
			objeto.bo_nao_possui_projeto,
			fonte_dados.nome_fonte,
		) RETURNING * INTO dado_posterior;

		PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, null, row_to_json(dado_posterior),id_carga);

	ELSE
		dado_posterior := dado_anterior;
		flag_update := false;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_apelido_osc::TEXT, dado_anterior.ft_apelido_osc, objeto.tx_apelido_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_apelido_osc := objeto.tx_apelido_osc;
			dado_posterior.ft_apelido_osc := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_identificador_osc::TEXT, dado_anterior.ft_identificador_osc, objeto.cd_identificador_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.cd_identificador_osc := objeto.cd_identificador_osc;
			dado_posterior.ft_identificador_osc := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.bo_osc_ativa::TEXT, dado_anterior.ft_osc_ativa, objeto.bo_osc_ativa::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.bo_osc_ativa := objeto.bo_osc_ativa;
			dado_posterior.ft_osc_ativa := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.bo_nao_possui_projeto::TEXT, dado_anterior.ft_nao_possui_projeto, objeto.bo_nao_possui_projeto::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.bo_nao_possui_projeto := objeto.bo_nao_possui_projeto;
			dado_posterior.ft_nao_possui_projeto := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;
		
		IF flag_update THEN
			UPDATE osc.tb_osc
			SET tx_apelido_osc = dado_posterior.tx_apelido_osc,
				ft_apelido_osc = dado_posterior.ft_apelido_osc,
				cd_identificador_osc = dado_posterior.cd_identificador_osc,
				ft_identificador_osc = dado_posterior.ft_identificador_osc,
				bo_osc_ativa = dado_posterior.bo_osc_ativa,
				ft_osc_ativa = dado_posterior.ft_osc_ativa,
				bo_nao_possui_projeto = dado_posterior.bo_nao_possui_projeto,
				ft_nao_possui_projeto = dado_posterior.ft_nao_possui_projeto
			WHERE id_osc = osc;
			
			PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior),id_carga);
			
		END IF;
	END IF;
	
	flag := true;
	mensagem := 'OSC atualizada.';
	
	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, identificador, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		
		RAISE NOTICE 'mensagem: %', mensagem;
		
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
