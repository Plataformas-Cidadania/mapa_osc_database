DROP FUNCTION IF EXISTS portal.atualizar_financiador_projeto(TEXT, NUMERIC, TIMESTAMP, JSONB, BOOLEAN, BOOLEAN, BOOLEAN, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_financiador_projeto(fonte TEXT, identificador NUMERIC, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER, tipo_busca INTEGER) RETURNS TABLE(
	mensagem TEXT,
	flag BOOLEAN
)AS $$

DECLARE
	nome_tabela TEXT;
	fonte_dados RECORD;
	objeto RECORD;
	dado_anterior RECORD;
	dado_posterior RECORD;
	dado_nao_delete INTEGER[];
	flag_update BOOLEAN;
	osc RECORD;

BEGIN
	nome_tabela := 'osc.tb_financiador_projeto';
	dado_nao_delete := '{}'::INTEGER[];

	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);

	SELECT * INTO osc 
	FROM osc.tb_osc 
	LEFT JOIN osc.tb_projeto 
	ON tb_osc.id_osc = tb_projeto.id_osc 
	WHERE tb_projeto.id_projeto = identificador;

	IF fonte_dados IS null THEN
		RAISE EXCEPTION 'fonte_invalida';
	ELSIF osc IS null THEN
		RAISE EXCEPTION 'osc_nao_encontrada';
	ELSIF osc.bo_osc_ativa IS false THEN
		RAISE EXCEPTION 'osc_inativa';
	ELSIF osc.id_projeto IS null THEN
		RAISE EXCEPTION 'projeto_nao_encontrado';
	ELSIF osc.id_osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	END IF;
	
	IF json IS null THEN
		json := ('[]')::JSONB;
	ELSIF jsonb_typeof(json) = 'object' THEN
		json := jsonb_build_array(json);
	END IF;

	FOR objeto IN (SELECT * FROM jsonb_populate_recordset(null::osc.tb_financiador_projeto, json))
	LOOP
		dado_anterior := null;

		IF tipo_busca = 1 THEN
			SELECT INTO dado_anterior * FROM osc.tb_financiador_projeto
			WHERE id_financiador_projeto = objeto.id_financiador_projeto
			AND id_projeto = osc.id_projeto;

		ELSIF tipo_busca = 2 THEN
			SELECT INTO dado_anterior * FROM osc.tb_financiador_projeto
			WHERE tx_nome_financiador = objeto.tx_nome_financiador
			AND id_projeto = osc.id_projeto;

		ELSE
			RAISE EXCEPTION 'tipo_busca_invalido';

		END IF;

		IF dado_anterior.id_financiador_projeto IS null THEN
			INSERT INTO osc.tb_financiador_projeto (
				id_projeto,
				tx_nome_financiador,
				ft_nome_financiador
			) VALUES (
				osc.id_projeto,
				objeto.tx_nome_financiador,
				fonte_dados.nome_fonte
			) RETURNING * INTO dado_posterior;

			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_financiador_projeto);
			PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, null, row_to_json(dado_posterior), id_carga);

		ELSE
			dado_posterior := dado_anterior;
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_financiador_projeto);
			flag_update := false;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_nome_financiador::TEXT, dado_anterior.ft_nome_financiador, objeto.tx_nome_financiador::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.tx_nome_financiador := objeto.tx_nome_financiador;
				dado_posterior.ft_nome_financiador := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF flag_update THEN
				UPDATE osc.tb_financiador_projeto
				SET tx_nome_financiador = dado_posterior.tx_nome_financiador,
					ft_nome_financiador = dado_posterior.ft_nome_financiador
				WHERE id_financiador_projeto = objeto.id_financiador_projeto;

				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior), id_carga);
			END IF;

		END IF;

	END LOOP;

	IF delete_valido THEN
		FOR objeto IN (SELECT * FROM osc.tb_financiador_projeto WHERE id_projeto = osc.id_projeto AND id_financiador_projeto != ALL(dado_nao_delete))
		LOOP
			IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_nome_financiador]) AS a) THEN
				DELETE FROM osc.tb_financiador_projeto WHERE id_financiador_projeto = objeto.id_financiador_projeto;
				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
			END IF;
		END LOOP;
	END IF;

	flag := true;
	mensagem := 'Financiador(es) de projeto atualizado.';

	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;
		
		IF osc IS NOT null THEN
			SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, osc.id_osc, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		ELSE
			mensagem := 'Ocorreu um erro.';
		END IF;

		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
