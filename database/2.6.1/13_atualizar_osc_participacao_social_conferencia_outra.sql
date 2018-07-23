DROP FUNCTION IF EXISTS portal.atualizar_osc_participacao_social_conferencia_outra(TEXT, NUMERIC, TIMESTAMP, JSONB, BOOLEAN, BOOLEAN, BOOLEAN, INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_osc_participacao_social_conferencia_outra(fonte TEXT, identificador NUMERIC, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER) RETURNS TABLE(
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
	nome_tabela := 'osc.tb_participacao_social_conferencia_outra';
	dado_nao_delete := '{}'::INTEGER[];

	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);

	IF fonte_dados IS null THEN
		RAISE EXCEPTION 'fonte_invalida';
	END IF;

	SELECT * INTO osc 
	FROM osc.tb_osc 
	LEFT JOIN osc.tb_participacao_social_conferencia 
	ON tb_osc.id_osc = tb_participacao_social_conferencia.id_osc 
	WHERE tb_participacao_social_conferencia.id_conferencia = identificador;

	IF osc IS null THEN
		RAISE EXCEPTION 'osc_nao_encontrada';
	ELSIF osc.bo_osc_ativa IS false THEN
		RAISE EXCEPTION 'osc_inativa';
	ELSIF osc.id_conferencia IS null THEN
		RAISE EXCEPTION 'conferencia_nao_encontrada';
	ELSIF osc.id_osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	END IF;
	
	IF json <> '{}'::JSONB THEN
		IF jsonb_typeof(json) = 'object' THEN
			json := jsonb_build_array(json);
		END IF;
		
		FOR objeto IN (SELECT * FROM jsonb_populate_recordset(null::osc.tb_participacao_social_conferencia_outra, json))
		LOOP
			dado_anterior := null;

			SELECT INTO dado_anterior * FROM osc.tb_participacao_social_conferencia_outra
			WHERE id_conferencia_outra = objeto.id_conferencia_outra
			AND id_conferencia = osc.id_conferencia;

			IF dado_anterior.id_conferencia_outra IS null THEN
				INSERT INTO osc.tb_participacao_social_conferencia_outra (
					id_conferencia,
					tx_nome_conferencia,
					ft_nome_conferencia,
					dt_ano_realizacao,
					ft_ano_realizacao,
					cd_forma_participacao_conferencia,
					ft_forma_participacao_conferencia
				) VALUES (
					osc.id_conferencia,
					objeto.tx_nome_conferencia,
					fonte_dados.nome_fonte,
					objeto.dt_ano_realizacao,
					fonte_dados.nome_fonte,
					objeto.cd_forma_participacao_conferencia,
					fonte_dados.nome_fonte
				) RETURNING * INTO dado_posterior;

				dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_conferencia_outra);
				PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, null, row_to_json(dado_posterior), id_carga);

			ELSE
				dado_posterior := dado_anterior;
				dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_conferencia_outra);
				flag_update := false;

				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_nome_conferencia::TEXT, dado_anterior.ft_nome_conferencia, objeto.tx_nome_conferencia::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.tx_nome_conferencia := objeto.tx_nome_conferencia;
					dado_posterior.ft_nome_conferencia := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;

				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_ano_realizacao::TEXT, dado_anterior.ft_ano_realizacao, objeto.dt_ano_realizacao::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.dt_ano_realizacao := objeto.dt_ano_realizacao;
					dado_posterior.ft_ano_realizacao := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;

				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_forma_participacao_conferencia::TEXT, dado_anterior.ft_forma_participacao_conferencia, objeto.cd_forma_participacao_conferencia::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.cd_forma_participacao_conferencia := objeto.cd_forma_participacao_conferencia;
					dado_posterior.ft_forma_participacao_conferencia := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;

				IF flag_update THEN
					UPDATE osc.tb_participacao_social_conferencia_outra
					SET tx_nome_conferencia = dado_posterior.tx_nome_conferencia,
						ft_nome_conferencia = dado_posterior.ft_nome_conferencia,
						dt_ano_realizacao = dado_posterior.dt_ano_realizacao,
						ft_ano_realizacao = dado_posterior.ft_ano_realizacao,
						cd_forma_participacao_conferencia = dado_posterior.cd_forma_participacao_conferencia,
						ft_forma_participacao_conferencia = dado_posterior.ft_forma_participacao_conferencia
					WHERE id_conferencia_outra = dado_posterior.id_conferencia_outra;

					PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior), id_carga);
				END IF;

			END IF;

		END LOOP;
	END IF;

	IF delete_valido THEN
		FOR objeto IN (SELECT * FROM osc.tb_participacao_social_conferencia_outra WHERE id_conferencia = osc.id_conferencia AND id_conferencia_outra != ALL(dado_nao_delete))
		LOOP
			IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_nome_conferencia]) AS a) THEN
				DELETE FROM osc.tb_participacao_social_conferencia_outra WHERE id_conferencia_outra = objeto.id_conferencia_outra;
				PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
			END IF;
		END LOOP;
	END IF;

	flag := true;
	mensagem := 'Outra conferência atualizada.';

	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, osc.id_osc, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
