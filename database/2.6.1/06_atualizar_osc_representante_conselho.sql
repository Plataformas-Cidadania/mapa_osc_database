DROP FUNCTION IF EXISTS portal.atualizar_osc_representante_conselho(TEXT, NUMERIC, TIMESTAMP, JSONB, BOOLEAN, BOOLEAN, BOOLEAN, INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_osc_representante_conselho(fonte TEXT, identificador NUMERIC, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER) RETURNS TABLE(
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
	conselho RECORD;

BEGIN
	nome_tabela := 'osc.tb_representante_conselho';
	dado_nao_delete := '{}'::INTEGER[];
	
	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);

	IF fonte_dados IS null THEN
		RAISE EXCEPTION 'fonte_invalida';
	END IF;

	SELECT * INTO conselho 
	FROM osc.tb_osc 
	LEFT JOIN osc.tb_participacao_social_conselho 
	ON tb_osc.id_osc = tb_participacao_social_conselho.id_osc 
	WHERE id_conselho = identificador;

	IF conselho.bo_osc_ativa IS false THEN
		RAISE EXCEPTION 'osc_inativa';
	ELSIF conselho.id_conselho IS null THEN
		RAISE EXCEPTION 'conselho_nao_encontrado';
	ELSIF conselho.id_osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	END IF;

	IF json IS null THEN
		json := ('[]')::JSONB;
	ELSIF jsonb_typeof(json) = 'object' THEN
		json := jsonb_build_array(json);
	END IF;

	FOR objeto IN (SELECT * FROM jsonb_populate_recordset(null::osc.tb_representante_conselho, json))
	LOOP
		dado_anterior := null;

		SELECT INTO dado_anterior * FROM osc.tb_representante_conselho
		WHERE id_representante_conselho = objeto.id_representante_conselho
		AND id_participacao_social_conselho = conselho.id_conselho;

		IF dado_anterior.id_representante_conselho IS null THEN
			INSERT INTO osc.tb_representante_conselho (
				id_participacao_social_conselho,
				tx_nome_representante_conselho,
				ft_nome_representante_conselho
			) VALUES (
				identificador,
				objeto.tx_nome_representante_conselho,
				fonte_dados.nome_fonte
			) RETURNING * INTO dado_posterior;

			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_representante_conselho);
			PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, conselho.id_osc, fonte, data_atualizacao, null, row_to_json(dado_posterior), id_carga);

		ELSE
			dado_posterior := dado_anterior;
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_representante_conselho);
			flag_update := false;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_nome_representante_conselho::TEXT, dado_anterior.ft_nome_representante_conselho, objeto.tx_nome_representante_conselho::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.tx_nome_representante_conselho := objeto.tx_nome_representante_conselho;
				dado_posterior.ft_nome_representante_conselho := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF flag_update THEN
				UPDATE osc.tb_representante_conselho
				SET tx_nome_representante_conselho = dado_posterior.tx_nome_representante_conselho,
					ft_nome_representante_conselho = dado_posterior.ft_nome_representante_conselho
				WHERE id_representante_conselho = dado_posterior.id_representante_conselho;

				PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, conselho.id_osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior), id_carga);
			END IF;

		END IF;

	END LOOP;

	IF delete_valido THEN
		FOR objeto IN (SELECT * FROM osc.tb_representante_conselho WHERE id_participacao_social_conselho = conselho.id_conselho AND id_representante_conselho != ALL(dado_nao_delete))
		LOOP
			IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_nome_representante_conselho]) AS a) THEN
				DELETE FROM osc.tb_representante_conselho WHERE id_representante_conselho = objeto.id_representante_conselho;
				PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, conselho.id_osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
			END IF;
		END LOOP;
	END IF;

	flag := true;
	mensagem := 'Representante(s) de conselho atualizado.';

	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, conselho.id_osc, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
