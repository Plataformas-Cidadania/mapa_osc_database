DROP FUNCTION IF EXISTS portal.atualizar_osc_area_atuacao_projeto_outra(TEXT, NUMERIC, TIMESTAMP, JSONB, BOOLEAN, BOOLEAN, BOOLEAN, INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_osc_area_atuacao_projeto_outra(fonte TEXT, identificador NUMERIC, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER) RETURNS TABLE(
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
	nome_tabela := 'osc.tb_area_atuacao_projeto_outra';
	dado_nao_delete := '{}'::INTEGER[];

	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);

	IF fonte_dados IS null THEN
		RAISE EXCEPTION 'fonte_invalida';
	END IF;

	SELECT * INTO osc 
	FROM osc.tb_osc 
	LEFT JOIN osc.tb_projeto 
	ON tb_osc.id_osc = tb_projeto.id_osc 
	LEFT JOIN osc.tb_area_atuacao_projeto 
	ON tb_projeto.id_projeto = tb_area_atuacao_projeto.id_projeto 
	WHERE tb_area_atuacao_projeto.id_area_atuacao = identificador;

	IF osc IS null THEN
		RAISE EXCEPTION 'osc_nao_encontrada';
	ELSIF osc.bo_osc_ativa IS false THEN
		RAISE EXCEPTION 'osc_inativa';
	ELSIF osc.id_area_atuacao IS null THEN
		RAISE EXCEPTION 'area_atuacao_projeto_nao_encontrada';
	ELSIF osc.id_osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	END IF;
	
	IF json <> '{}'::JSONB THEN
		IF jsonb_typeof(json) = 'object' THEN
			json := jsonb_build_array(json);
		END IF;
		
		FOR objeto IN (SELECT * FROM jsonb_populate_recordset(null::osc.tb_area_atuacao_projeto_outra, json))
		LOOP
			dado_anterior := null;

			SELECT INTO dado_anterior * FROM osc.tb_area_atuacao_projeto_outra
			WHERE id_area_atuacao_outra = objeto.id_area_atuacao_outra
			AND id_area_atuacao = osc.id_area_atuacao;

			IF dado_anterior.id_area_atuacao_outra IS null THEN
				INSERT INTO osc.tb_area_atuacao_projeto_outra (
					id_area_atuacao,
					tx_nome_area_atuacao,
					ft_nome_area_atuacao
				) VALUES (
					osc.id_area_atuacao,
					objeto.tx_nome_area_atuacao,
					fonte_dados.nome_fonte
				) RETURNING * INTO dado_posterior;

				dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_area_atuacao_outra);
				
				PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, null, row_to_json(dado_posterior), id_carga);

			ELSE
				dado_posterior := dado_anterior;
				dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_area_atuacao_outra);
				flag_update := false;

				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_nome_area_atuacao::TEXT, dado_anterior.ft_nome_area_atuacao, objeto.tx_nome_area_atuacao::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.tx_nome_area_atuacao := objeto.tx_nome_area_atuacao;
					dado_posterior.ft_nome_area_atuacao := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;

				IF flag_update THEN
					UPDATE osc.tb_area_atuacao_projeto_outra
					SET tx_nome_area_atuacao = dado_posterior.tx_nome_area_atuacao,
						ft_nome_area_atuacao = dado_posterior.ft_nome_area_atuacao
					WHERE id_area_atuacao_outra = dado_posterior.id_area_atuacao_outra;
					
					PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior), id_carga);
				END IF;

			END IF;

		END LOOP;
	END IF;

	IF delete_valido THEN
		FOR objeto IN (SELECT * FROM osc.tb_area_atuacao_projeto_outra WHERE id_area_atuacao = osc.id_area_atuacao AND id_area_atuacao_outra != ALL(dado_nao_delete))
		LOOP
			IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_nome_area_atuacao]) AS a) THEN
				DELETE FROM osc.tb_area_atuacao_projeto_outra WHERE id_area_atuacao_outra = objeto.id_area_atuacao_outra;
				PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
			END IF;
		END LOOP;
	END IF;

	flag := true;
	mensagem := 'Outra área de atuação de projeto atualizada.';

	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;
		
		IF osc.id_osc IS NOT null THEN
			SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, osc.id_osc, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		ELSE
			mensagem := 'Ocorreu um erro.';
		END IF;
		
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
