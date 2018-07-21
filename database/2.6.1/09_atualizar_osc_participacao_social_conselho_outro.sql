DROP FUNCTION IF EXISTS portal.atualizar_osc_participacao_social_conselho_outro(TEXT, NUMERIC, TIMESTAMP, JSONB, BOOLEAN, BOOLEAN, BOOLEAN, INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_osc_participacao_social_conselho_outro(fonte TEXT, identificador NUMERIC, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER) RETURNS TABLE(
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
	nome_tabela := 'osc.tb_participacao_social_conselho_outro';

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

	IF jsonb_typeof(json) = 'object' THEN
		json := jsonb_build_array(json);
	END IF;

	FOR objeto IN (SELECT * FROM jsonb_populate_recordset(null::osc.tb_participacao_social_conselho_outro, json))
	LOOP
		dado_anterior := null;

		SELECT INTO dado_anterior * FROM osc.tb_participacao_social_conselho_outro
		WHERE id_conselho_outro = objeto.id_conselho_outro
		AND id_conselho = conselho.id_conselho;

		IF dado_anterior.id_conselho_outro IS null THEN
			INSERT INTO osc.tb_participacao_social_conselho_outro (
				id_conselho,
				tx_nome_conselho,
				ft_nome_conselho
			) VALUES (
				identificador,
				objeto.tx_nome_conselho,
				fonte_dados.nome_fonte
			) RETURNING * INTO dado_posterior;

			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_conselho_outro);
			PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, conselho.id_osc, fonte, data_atualizacao, null, row_to_json(dado_posterior), id_carga);

		ELSE
			dado_posterior := dado_anterior;
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_conselho_outro);
			flag_update := false;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_nome_conselho::TEXT, dado_anterior.ft_nome_conselho, objeto.tx_nome_conselho::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.tx_nome_conselho := objeto.tx_nome_conselho;
				dado_posterior.ft_nome_conselho := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF flag_update THEN
				UPDATE osc.tb_participacao_social_conselho_outro
				SET tx_nome_conselho = dado_posterior.tx_nome_conselho,
					ft_nome_conselho = dado_posterior.ft_nome_conselho
				WHERE id_conselho_outro = dado_posterior.id_conselho_outro;

				PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, conselho.id_osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior), id_carga);
			END IF;

		END IF;

	END LOOP;

	IF delete_valido THEN
		FOR objeto IN (SELECT * FROM osc.tb_participacao_social_conselho_outro WHERE id_conselho = identificador AND id_conselho_outro != ALL(dado_nao_delete))
		LOOP
			IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_nome_conselho]) AS a) THEN
				DELETE FROM osc.tb_participacao_social_conselho_outro WHERE id_conselho_outro = objeto.id_conselho_outro;
				PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, conselho.id_osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
			END IF;
		END LOOP;
	END IF;

	flag := true;
	mensagem := 'Representante(s) de conselho atualizado.';

	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '%', SQLERRM;
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, conselho.id_osc, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_osc_participacao_social_conselho_outro(
	'Representante de OSC'::TEXT, 
	'171'::NUMERIC, 
	NOW()::TIMESTAMP, 
	'[
		{
			"id_conselho_outro": 2488,
			"tx_nome_conselho": "Teste 2a"
		},
		{
			"id_conselho_outro": 2488,
			"tx_nome_conselho": "Teste 2c"
		}
	]'::JSONB, 
	true::BOOLEAN, 
	true::BOOLEAN, 
	false::BOOLEAN, 
	null::INTEGER
);