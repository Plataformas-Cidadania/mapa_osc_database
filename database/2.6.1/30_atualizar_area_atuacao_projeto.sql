DROP FUNCTION IF EXISTS portal.atualizar_participacao_social_conselho(TEXT, NUMERIC, TIMESTAMP, JSONB, BOOLEAN, BOOLEAN, BOOLEAN, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_participacao_social_conselho(fonte TEXT, identificador NUMERIC, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER, tipo_busca INTEGER) RETURNS TABLE(
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
	json_externo JSONB;
	objeto_externo RECORD;
	record_funcao_externa RECORD;

BEGIN
	nome_tabela := 'osc.tb_area_atuacao_projeto';
	tipo_identificador := lower(tipo_identificador);
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
	ELSIF osc.id_projeto IS null THEN
		RAISE EXCEPTION 'projeto_nao_encontrado';
	ELSIF osc.id_osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	ELSIF osc.bo_osc_ativa IS false THEN
		RAISE EXCEPTION 'osc_inativa';
	END IF;
	
	IF jsonb_typeof(json) = 'object' THEN
		json := jsonb_build_array(json);
	END IF;
	
	FOR objeto IN (SELECT * FROM jsonb_to_recordset(json) AS x(id_area_atuacao_projeto INTEGER, cd_area_atuacao INTEGER, tx_nome_area_atuacao TEXT))
	LOOP
		dado_anterior := null;
		
		IF tipo_busca = 1 THEN
			SELECT INTO dado_anterior *
			FROM osc.tb_area_atuacao_projeto
			WHERE id_area_atuacao_projeto = conselho.id_area_atuacao_projeto;
			
		ELSIF tipo_busca = 2 THEN
			SELECT INTO dado_anterior * 
			FROM osc.tb_area_atuacao_projeto
			WHERE tb_area_atuacao_projeto.cd_area_atuacao = conselho.cd_area_atuacao
			AND tb_area_atuacao_projeto.id_projeto = osc.id_projeto;
			
		ELSE
			RAISE EXCEPTION 'tipo_busca_invalido';

		END IF;

		IF dado_anterior.id_area_atuacao_projeto IS null THEN
			INSERT INTO osc.tb_area_atuacao_projeto (
				id_projeto,
				cd_area_atuacao,
				ft_area_atuacao
			) VALUES (
				osc.id_projeto,
				conselho.cd_area_atuacao,
				fonte_dados.nome_fonte
			) RETURNING * INTO dado_posterior;
			
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_area_atuacao_projeto);
			
			PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, null::JSON, row_to_json(dado_posterior), id_carga);
			
		ELSE
			dado_posterior := dado_anterior;
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_area_atuacao_projeto);
			flag_update := false;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_area_atuacao::TEXT, dado_anterior.ft_area_atuacao, conselho.cd_area_atuacao::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.cd_area_atuacao := conselho.cd_area_atuacao;
				dado_posterior.ft_area_atuacao := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF flag_update THEN
				UPDATE osc.tb_area_atuacao_projeto
				SET	cd_area_atuacao = dado_posterior.cd_area_atuacao,
					ft_area_atuacao = dado_posterior.ft_area_atuacao
				WHERE id_area_atuacao_projeto = dado_posterior.id_area_atuacao_projeto;
				
				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior), id_carga);
			END IF;
		END IF;
		
		IF objeto.tx_nome_area_atuacao IS NOT null THEN
			SELECT INTO record_funcao_externa * FROM portal.atualizar_osc_area_atuacao_projeto_outra(fonte, dado_posterior.id_area_atuacao_projeto, data_atualizacao, ('{"tx_nome_area_atuacao": ' || objeto.tx_nome_area_atuacao::TEXT || '}')::JSONB, null_valido, delete_valido, erro_log, id_carga);
			IF record_funcao_externa.flag = false THEN
				mensagem := record_funcao_externa.mensagem;
				RAISE EXCEPTION 'funcao_externa';
			END IF;
		END IF;
	END LOOP;

	IF delete_valido THEN
		FOR objeto IN (SELECT * FROM osc.tb_area_atuacao_projeto WHERE id_projeto = osc.id_projeto AND id_area_atuacao_projeto != ALL(dado_nao_delete))
		LOOP			
			FOR objeto_externo IN (SELECT * FROM osc.tb_area_atuacao_projeto_outra WHERE id_area_atuacao_projeto = objeto.id_area_atuacao_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto_externo.ft_nome_area_atuacao]) AS a) THEN
					DELETE FROM osc.tb_area_atuacao_projeto_outra WHERE id_area_atuacao_projeto_outra = objeto_externo.id_area_atuacao_projeto_outra AND id_area_atuacao_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_area_atuacao_projeto_outra'::TEXT, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto_externo), null::JSON, id_carga);
				END IF;
			END LOOP;

			IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_area_atuacao]) AS a) THEN
				DELETE FROM osc.tb_area_atuacao_projeto WHERE id_area_atuacao_projeto = objeto.id_area_atuacao_projeto AND id_area_atuacao_projeto != ALL(dado_nao_delete);
				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto), null::JSON, id_carga);
			END IF;
		END LOOP;
	END IF;
	
	flag := true;
	mensagem := 'Área de atuação de projeto atualizado.';
	
	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;

		IF SQLERRM <> 'funcao_externa' THEN 
			SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, identificador, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		END IF;
		
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
