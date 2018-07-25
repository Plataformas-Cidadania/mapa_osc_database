DROP FUNCTION IF EXISTS portal.atualizar_projetos_osc(TEXT, NUMERIC, TEXT, TIMESTAMP, JSONB, BOOLEAN, BOOLEAN, BOOLEAN, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_projetos_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER, tipo_busca INTEGER) RETURNS TABLE(
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
	nao_possui BOOLEAN;
	json_externo JSONB;
	objeto_externo RECORD;
	record_externo RECORD;

BEGIN
	nome_tabela := 'osc.tb_projeto';
	tipo_identificador := lower(tipo_identificador);
	dado_nao_delete := '{}'::INTEGER[];

	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);
	
	IF tipo_identificador = 'cnpj' THEN
		SELECT * INTO osc 
		FROM osc.tb_osc 
		WHERE tb_osc.cd_identificador_osc = identificador;
	ELSIF tipo_identificador = 'id_osc' THEN
		SELECT * INTO osc 
		FROM osc.tb_osc 
		WHERE tb_osc.id_osc = identificador;
	END IF;
	
	IF tipo_identificador != 'cnpj' AND tipo_identificador != 'id_osc' THEN
		RAISE EXCEPTION 'tipo_identificador_invalido';
	ELSIF fonte_dados IS null THEN
		RAISE EXCEPTION 'fonte_invalida';
	ELSIF osc IS null THEN
		RAISE EXCEPTION 'osc_nao_encontrada';
	ELSIF osc.bo_osc_ativa IS false THEN
		RAISE EXCEPTION 'osc_inativa';
	ELSIF osc.id_osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	END IF;
	
	nao_possui = json->>'bo_nao_possui_projeto';
	IF nao_possui IS NOT null THEN
		SELECT INTO record_externo * FROM portal.atualizar_osc(fonte, osc.id_osc, 'id_osc', data_atualizacao, ('{"bo_nao_possui_projeto": ' || nao_possui::TEXT || '}')::JSONB, null_valido, delete_valido, erro_log, id_carga);
		IF record_externo.flag = false THEN 
			mensagem := record_externo.mensagem;
			RAISE EXCEPTION 'funcao_externa';
		END IF;
	END IF;
	
	IF nao_possui IS NOT true THEN
		IF jsonb_typeof((json->>'projetos')::JSONB) = 'object' THEN
			json := jsonb_build_array((json->>'projetos')::JSONB);
			--json := ('{' || (json->>'projetos')::TEXT || '}')::JSONB;
		ELSE
			json := (json->>'projetos')::JSONB;
		END IF;
		
		FOR objeto IN (SELECT * FROM jsonb_to_recordset(json) AS x(id_projeto INTEGER, tx_identificador_projeto_externo TEXT, cd_municipio INTEGER, cd_uf INTEGER, tx_nome_projeto TEXT, cd_status_projeto INTEGER, dt_data_inicio_projeto TIMESTAMP, dt_data_fim_projeto TIMESTAMP, nr_valor_total_projeto DOUBLE PRECISION, nr_valor_captado_projeto DOUBLE PRECISION, nr_total_beneficiarios DOUBLE PRECISION, cd_abrangencia_projeto INTEGER, cd_zona_atuacao_projeto INTEGER, tx_descricao_projeto TEXT, tx_metodologia_monitoramento TEXT, tx_link_projeto TEXT, localizacao JSONB, tipo_parceria JSONB, fonte_recursos JSONB, financiador JSONB, objetivo JSONB))
		LOOP
			dado_anterior := null;
			
			IF tipo_busca = 1 THEN
				SELECT INTO dado_anterior *
				FROM osc.tb_projeto
				WHERE id_projeto = objeto.id_projeto
				AND id_osc = osc.id_osc;
				
			ELSIF tipo_busca = 2 THEN
				SELECT INTO dado_anterior * FROM osc.tb_projeto
				WHERE (tx_identificador_projeto_externo = objeto.tx_identificador_projeto_externo AND cd_uf = objeto.cd_uf AND cd_municipio is null)
				OR (tx_identificador_projeto_externo = objeto.tx_identificador_projeto_externo AND cd_uf is null AND cd_municipio = objeto.cd_municipio)
				AND id_osc = osc.id_osc;
				
			ELSIF tipo_busca = 3 THEN
				SELECT INTO dado_anterior * FROM osc.tb_projeto
				WHERE tx_identificador_projeto_externo = objeto.tx_identificador_projeto_externo
				AND SUBSTRING(ft_identificador_projeto_externo FROM 0 FOR char_length(ft_identificador_projeto_externo) - position(' ' in reverse(ft_identificador_projeto_externo)) + 1) = SUBSTRING(fonte_dados.nome_fonte FROM 0 FOR char_length(fonte_dados.nome_fonte) - position(' ' in reverse(fonte_dados.nome_fonte)) + 1)
				AND id_osc = osc.id_osc;
			
			ELSE
				RAISE EXCEPTION 'tipo_busca_invalido';

			END IF;
			
			IF dado_anterior.id_projeto IS null THEN
				INSERT INTO osc.tb_projeto (
					id_osc,
					tx_identificador_projeto_externo,
					ft_identificador_projeto_externo,
					cd_municipio,
					ft_municipio,
					cd_uf,
					ft_uf,
					tx_nome_projeto,
					ft_nome_projeto,
					cd_status_projeto,
					ft_status_projeto,
					dt_data_inicio_projeto,
					ft_data_inicio_projeto,
					dt_data_fim_projeto,
					ft_data_fim_projeto,
					nr_valor_total_projeto,
					ft_valor_total_projeto,
					nr_valor_captado_projeto,
					ft_valor_captado_projeto,
					nr_total_beneficiarios,
					ft_total_beneficiarios,
					cd_abrangencia_projeto,
					ft_abrangencia_projeto,
					cd_zona_atuacao_projeto,
					ft_zona_atuacao_projeto,
					tx_descricao_projeto,
					ft_descricao_projeto,
					tx_metodologia_monitoramento,
					ft_metodologia_monitoramento,
					tx_link_projeto,
					ft_link_projeto
				) VALUES (
					osc.id_osc,
					objeto.tx_identificador_projeto_externo,
					fonte_dados.nome_fonte,
					objeto.cd_municipio,
					fonte_dados.nome_fonte,
					objeto.cd_uf,
					fonte_dados.nome_fonte,
					objeto.tx_nome_projeto,
					fonte_dados.nome_fonte,
					objeto.cd_status_projeto,
					fonte_dados.nome_fonte,
					objeto.dt_data_inicio_projeto,
					fonte_dados.nome_fonte,
					objeto.dt_data_fim_projeto,
					fonte_dados.nome_fonte,
					objeto.nr_valor_total_projeto,
					fonte_dados.nome_fonte,
					objeto.nr_valor_captado_projeto,
					fonte_dados.nome_fonte,
					objeto.nr_total_beneficiarios,
					fonte_dados.nome_fonte,
					objeto.cd_abrangencia_projeto,
					fonte_dados.nome_fonte,
					objeto.cd_zona_atuacao_projeto,
					fonte_dados.nome_fonte,
					objeto.tx_descricao_projeto,
					fonte_dados.nome_fonte,
					objeto.tx_metodologia_monitoramento,
					fonte_dados.nome_fonte,
					objeto.tx_link_projeto,
					fonte_dados.nome_fonte
				) RETURNING * INTO dado_posterior;
				
				dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_projeto);
				
				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, null::JSON, row_to_json(dado_posterior), id_carga);
				
			ELSE
				dado_posterior := dado_anterior;
				dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_projeto);
				flag_update := false;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_identificador_projeto_externo::TEXT, dado_anterior.ft_identificador_projeto_externo, objeto.tx_identificador_projeto_externo::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.tx_identificador_projeto_externo := objeto.tx_identificador_projeto_externo;
					dado_posterior.ft_identificador_projeto_externo := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_municipio::TEXT, dado_anterior.ft_municipio, objeto.cd_municipio::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.cd_municipio := objeto.cd_municipio;
					dado_posterior.ft_municipio := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_uf::TEXT, dado_anterior.ft_uf, objeto.cd_uf::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.cd_uf := objeto.cd_uf;
					dado_posterior.ft_uf := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_nome_projeto::TEXT, dado_anterior.ft_nome_projeto, objeto.tx_nome_projeto::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.tx_nome_projeto := objeto.tx_nome_projeto;
					dado_posterior.ft_nome_projeto := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_status_projeto::TEXT, dado_anterior.ft_status_projeto, objeto.cd_status_projeto::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.cd_status_projeto := objeto.cd_status_projeto;
					dado_posterior.ft_status_projeto := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_data_inicio_projeto::TEXT, dado_anterior.ft_data_inicio_projeto, objeto.dt_data_inicio_projeto::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.dt_data_inicio_projeto := objeto.dt_data_inicio_projeto;
					dado_posterior.ft_data_inicio_projeto := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_data_fim_projeto::TEXT, dado_anterior.ft_data_fim_projeto, objeto.dt_data_fim_projeto::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.dt_data_fim_projeto := objeto.dt_data_fim_projeto;
					dado_posterior.ft_data_fim_projeto := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_valor_total_projeto::TEXT, dado_anterior.ft_valor_total_projeto, objeto.nr_valor_total_projeto::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.nr_valor_total_projeto := objeto.nr_valor_total_projeto;
					dado_posterior.ft_valor_total_projeto := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_valor_captado_projeto::TEXT, dado_anterior.ft_valor_captado_projeto, objeto.nr_valor_captado_projeto::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.nr_valor_captado_projeto := objeto.nr_valor_captado_projeto;
					dado_posterior.ft_valor_captado_projeto := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_total_beneficiarios::TEXT, dado_anterior.ft_total_beneficiarios, objeto.nr_total_beneficiarios::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.nr_total_beneficiarios := objeto.nr_total_beneficiarios;
					dado_posterior.ft_total_beneficiarios := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_abrangencia_projeto::TEXT, dado_anterior.ft_abrangencia_projeto, objeto.cd_abrangencia_projeto::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.cd_abrangencia_projeto := objeto.cd_abrangencia_projeto;
					dado_posterior.ft_abrangencia_projeto := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_zona_atuacao_projeto::TEXT, dado_anterior.ft_zona_atuacao_projeto, objeto.cd_zona_atuacao_projeto::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.cd_zona_atuacao_projeto := objeto.cd_zona_atuacao_projeto;
					dado_posterior.ft_zona_atuacao_projeto := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_descricao_projeto::TEXT, dado_anterior.ft_descricao_projeto, objeto.tx_descricao_projeto::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.tx_descricao_projeto := objeto.tx_descricao_projeto;
					dado_posterior.ft_descricao_projeto := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_metodologia_monitoramento::TEXT, dado_anterior.ft_metodologia_monitoramento, objeto.tx_metodologia_monitoramento::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.tx_metodologia_monitoramento := objeto.tx_metodologia_monitoramento;
					dado_posterior.ft_metodologia_monitoramento := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_link_projeto::TEXT, dado_anterior.ft_link_projeto, objeto.tx_link_projeto::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.tx_link_projeto := objeto.tx_link_projeto;
					dado_posterior.ft_link_projeto := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF flag_update THEN
					UPDATE osc.tb_projeto
					SET	tx_identificador_projeto_externo = dado_posterior.tx_identificador_projeto_externo,
						ft_identificador_projeto_externo = dado_posterior.ft_identificador_projeto_externo,
						cd_uf = dado_posterior.cd_uf,
						ft_uf = dado_posterior.ft_uf,
						cd_municipio = dado_posterior.cd_municipio,
						ft_municipio = dado_posterior.ft_municipio,
						tx_nome_projeto = dado_posterior.tx_nome_projeto,
						ft_nome_projeto = dado_posterior.ft_nome_projeto,
						cd_status_projeto = dado_posterior.cd_status_projeto,
						ft_status_projeto = dado_posterior.ft_status_projeto,
						dt_data_inicio_projeto = dado_posterior.dt_data_inicio_projeto,
						ft_data_inicio_projeto = dado_posterior.ft_data_inicio_projeto,
						dt_data_fim_projeto = dado_posterior.dt_data_fim_projeto,
						ft_data_fim_projeto = dado_posterior.ft_data_fim_projeto,
						nr_valor_total_projeto = dado_posterior.nr_valor_total_projeto,
						ft_valor_total_projeto = dado_posterior.ft_valor_total_projeto,
						nr_valor_captado_projeto = dado_posterior.nr_valor_captado_projeto,
						ft_valor_captado_projeto = dado_posterior.ft_valor_captado_projeto,
						nr_total_beneficiarios = dado_posterior.nr_total_beneficiarios,
						ft_total_beneficiarios = dado_posterior.ft_total_beneficiarios,
						cd_abrangencia_projeto = dado_posterior.cd_abrangencia_projeto,
						ft_abrangencia_projeto = dado_posterior.ft_abrangencia_projeto,
						cd_zona_atuacao_projeto = dado_posterior.cd_zona_atuacao_projeto,
						ft_zona_atuacao_projeto = dado_posterior.ft_zona_atuacao_projeto,
						tx_descricao_projeto = dado_posterior.tx_descricao_projeto,
						ft_descricao_projeto = dado_posterior.ft_descricao_projeto,
						tx_metodologia_monitoramento = dado_posterior.tx_metodologia_monitoramento,
						ft_metodologia_monitoramento = dado_posterior.ft_metodologia_monitoramento,
						tx_link_projeto = dado_posterior.tx_link_projeto,
						ft_link_projeto = dado_posterior.ft_link_projeto
					WHERE id_projeto = objeto.id_projeto;
					
					PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior), id_carga);
				END IF;
			END IF;

			json_externo = COALESCE(objeto.localizacao, '{}'::JSONB);
			SELECT INTO record_externo * FROM portal.atualizar_localizacao_projeto(fonte, dado_posterior.id_projeto, data_atualizacao, json_externo, null_valido, delete_valido, erro_log, id_carga, tipo_busca);
			IF record_externo.flag = false THEN 
				mensagem := record_externo.mensagem;
				RAISE EXCEPTION 'funcao_externa';
			END IF;

			json_externo = COALESCE(objeto.tipo_parceria, '{}'::JSONB);
			SELECT INTO record_externo * FROM portal.atualizar_tipo_parceria_projeto(fonte, dado_posterior.id_projeto, data_atualizacao, json_externo, null_valido, delete_valido, erro_log, id_carga, tipo_busca);
			IF record_externo.flag = false THEN 
				mensagem := record_externo.mensagem;
				RAISE EXCEPTION 'funcao_externa';
			END IF;

			json_externo = COALESCE(objeto.fonte_recursos, '{}'::JSONB);
			SELECT INTO record_externo * FROM portal.atualizar_fonte_recursos_projeto(fonte, dado_posterior.id_projeto, data_atualizacao, json_externo, null_valido, delete_valido, erro_log, id_carga, tipo_busca);
			IF record_externo.flag = false THEN 
				mensagem := record_externo.mensagem;
				RAISE EXCEPTION 'funcao_externa';
			END IF;

			json_externo = COALESCE(objeto.financiador, '{}'::JSONB);
			SELECT INTO record_externo * FROM portal.atualizar_financiador_projeto(fonte, dado_posterior.id_projeto, data_atualizacao, json_externo, null_valido, delete_valido, erro_log, id_carga, tipo_busca);
			IF record_externo.flag = false THEN 
				mensagem := record_externo.mensagem;
				RAISE EXCEPTION 'funcao_externa';
			END IF;

			json_externo = COALESCE(objeto.objetivo, '{}'::JSONB);
			SELECT INTO record_externo * FROM portal.atualizar_objetivo_projeto(fonte, dado_posterior.id_projeto, data_atualizacao, json_externo, null_valido, delete_valido, erro_log, id_carga, tipo_busca);
			IF record_externo.flag = false THEN 
				mensagem := record_externo.mensagem;
				RAISE EXCEPTION 'funcao_externa';
			END IF;
		END LOOP;
	END IF;
	
	IF delete_valido THEN
		FOR objeto IN (SELECT * FROM osc.tb_projeto WHERE id_osc = osc.id_osc AND id_projeto != ALL(dado_nao_delete))
		LOOP
			FOR objeto_externo IN (SELECT * FROM osc.tb_localizacao_projeto WHERE id_projeto = objeto.id_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto_externo.ft_regiao_localizacao_projeto, objeto_externo.ft_nome_regiao_localizacao_projeto, objeto_externo.ft_localizacao_prioritaria]) AS a) THEN
					DELETE FROM osc.tb_localizacao_projeto WHERE id_projeto = objeto_externo.id_projeto AND id_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_localizacao_projeto'::TEXT, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto_externo), null::JSON, id_carga);
				END IF;
			END LOOP;

			FOR objeto_externo IN (SELECT * FROM osc.tb_tipo_parceria_projeto WHERE id_projeto = objeto.id_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto_externo.ft_tipo_parceria_projeto]) AS a) THEN
					DELETE FROM osc.tb_tipo_parceria_projeto WHERE id_projeto = objeto_externo.id_projeto AND id_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_tipo_parceria_projeto'::TEXT, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto_externo), null::JSON, id_carga);
				END IF;
			END LOOP;
			
			FOR objeto_externo IN (SELECT * FROM osc.tb_fonte_recursos_projeto WHERE id_projeto = objeto.id_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto_externo.ft_fonte_recursos_projeto, objeto_externo.ft_orgao_concedente]) AS a) THEN
					DELETE FROM osc.tb_fonte_recursos_projeto WHERE id_projeto = objeto_externo.id_projeto AND id_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_fonte_recursos_projeto'::TEXT, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto_externo), null::JSON, id_carga);
				END IF;
			END LOOP;
			
			FOR objeto_externo IN (SELECT * FROM osc.tb_financiador_projeto WHERE id_projeto = objeto.id_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto_externo.ft_nome_financiador]) AS a) THEN
					DELETE FROM osc.tb_financiador_projeto WHERE id_projeto = objeto_externo.id_projeto AND id_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_financiador_projeto'::TEXT, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto_externo), null::JSON, id_carga);
				END IF;
			END LOOP;
			
			FOR objeto_externo IN (SELECT * FROM osc.tb_objetivo_projeto WHERE id_projeto = objeto.id_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto_externo.ft_objetivo_projeto]) AS a) THEN
					DELETE FROM osc.tb_objetivo_projeto WHERE id_projeto = objeto_externo.id_projeto AND id_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_objetivo_projeto'::TEXT, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto_externo), null::JSON, id_carga);
				END IF;
			END LOOP;
			
			FOR objeto_externo IN (SELECT * FROM osc.tb_publico_beneficiado_projeto WHERE id_projeto = objeto.id_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto_externo.ft_publico_beneficiado_projeto]) AS a) THEN
					DELETE FROM osc.tb_publico_beneficiado_projeto WHERE id_projeto = objeto_externo.id_projeto AND id_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_publico_beneficiado_projeto'::TEXT, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto_externo), null::JSON, id_carga);
				END IF;
			END LOOP;
			
			FOR objeto_externo IN (SELECT * FROM osc.tb_area_atuacao_outra_projeto WHERE id_projeto = objeto.id_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto_externo.ft_area_atuacao_outra_projeto]) AS a) THEN
					DELETE FROM osc.tb_area_atuacao_outra_projeto WHERE id_projeto = objeto_externo.id_projeto AND id_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_area_atuacao_outra_projeto'::TEXT, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto_externo), null::JSON, id_carga);
				END IF;
			END LOOP;
			
			FOR objeto_externo IN (SELECT * FROM osc.tb_area_atuacao_projeto WHERE id_projeto = objeto.id_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto_externo.ft_area_atuacao_projeto]) AS a) THEN
					DELETE FROM osc.tb_area_atuacao_projeto WHERE id_projeto = objeto_externo.id_projeto AND id_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_area_atuacao_projeto'::TEXT, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto_externo), null::JSON, id_carga);
				END IF;
			END LOOP;
			
			FOR objeto_externo IN (SELECT * FROM osc.tb_osc_parceira_projeto WHERE id_projeto = objeto.id_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto_externo.ft_osc_parceira_projeto]) AS a) THEN
					DELETE FROM osc.tb_osc_parceira_projeto WHERE id_projeto = objeto_externo.id_projeto AND id_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_osc_parceira_projeto'::TEXT, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto_externo), null::JSON, id_carga);
				ELSE
					dado_nao_delete := array_append(dado_nao_delete, objeto_externo.id_projeto);
				END IF;
			END LOOP;
			
			IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_identificador_projeto_externo, objeto.ft_uf, objeto.ft_municipio, objeto.ft_nome_projeto, objeto.ft_status_projeto, objeto.ft_data_inicio_projeto, objeto.ft_data_fim_projeto, objeto.ft_valor_total_projeto, objeto.ft_valor_captado_projeto, objeto.ft_total_beneficiarios, objeto.ft_abrangencia_projeto, objeto.ft_zona_atuacao_projeto, objeto.ft_descricao_projeto, objeto.ft_metodologia_monitoramento, objeto.ft_link_projeto]) AS a) THEN
				DELETE FROM osc.tb_projeto WHERE id_projeto = objeto.id_projeto AND id_projeto != ALL(dado_nao_delete);
				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto), null::JSON, id_carga);
			END IF;
		END LOOP;
	END IF;
	
	IF nao_possui AND (SELECT EXISTS(SELECT * FROM osc.tb_projeto WHERE id_osc = osc.id_osc)) THEN 
		RAISE EXCEPTION 'nao_possui_invalido';
	END IF;
	
	flag := true;
	mensagem := 'Projetos de OSC atualizado.';
	
	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '%', SQLERRM;
		flag := false;

		IF osc IS NOT null THEN
			IF SQLERRM <> 'funcao_externa' THEN 
				SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, osc.id_osc, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
			END IF;
		ELSE
			mensagem := 'Ocorreu um erro.';
		END IF;
		
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';



-- Teste
SELECT * FROM portal.atualizar_projetos_osc(
	'Representante de OSC'::TEXT, 
	'1548640'::NUMERIC, 
	'id_osc'::TEXT, 
	now()::TIMESTAMP, 
	'{
		"bo_nao_possui_projeto": false,
		"projetos": [
			{
				"tx_identificador_projeto_externo": null,
				"cd_municipio": null,
				"cd_uf": null,
				"tx_nome_projeto": "Teste nome 1",
				"cd_status_projeto": 1,
				"dt_data_inicio_projeto": "01-01-2001",
				"dt_data_fim_projeto": "01-01-2011",
				"nr_valor_total_projeto": 100000.0,
				"nr_valor_captado_projeto": 100000.0,
				"nr_total_beneficiarios": 100000.0,
				"cd_abrangencia_projeto": 1,
				"cd_zona_atuacao_projeto": 1,
				"tx_descricao_projeto": "Teste descrição 1",
				"tx_metodologia_monitoramento": "Teste motodologia 1",
				"tx_link_projeto": "Teste link 1",
				"localizacao": null
			},
			{
				"id_projeto": 87081,
				"tx_identificador_projeto_externo": null,
				"cd_municipio": null,
				"cd_uf": null,
				"tx_nome_projeto": "Teste nome 2",
				"cd_status_projeto": 2,
				"dt_data_inicio_projeto": "02-02-2002",
				"dt_data_fim_projeto": "02-02-2022",
				"nr_valor_total_projeto": 200000.0,
				"nr_valor_captado_projeto": 200000.0,
				"nr_total_beneficiarios": 200000.0,
				"cd_abrangencia_projeto": 2,
				"cd_zona_atuacao_projeto": 2,
				"tx_descricao_projeto": "Teste descrição 2",
				"tx_metodologia_monitoramento": "Teste motodologia 2",
				"tx_link_projeto": "Teste link 2",
				"localizacao": [
					{"id_regiao_localizacao_projeto": 33, "tx_nome_regiao_localizacao_projeto": "Xerém", "bo_localizacao_prioritaria": true},
					{"id_regiao_localizacao_projeto": 34, "tx_nome_regiao_localizacao_projeto": "Xerém", "bo_localizacao_prioritaria": false},
					{"id_regiao_localizacao_projeto": 35, "tx_nome_regiao_localizacao_projeto": "Xerém", "bo_localizacao_prioritaria": false}
				],
				"tipo_parceria": [
					{"cd_origem_fonte_recursos_projeto": 1, "cd_tipo_parceria_projeto": "1"},
					{"cd_origem_fonte_recursos_projeto": 1, "cd_tipo_parceria_projeto": "2"},
					{"cd_origem_fonte_recursos_projeto": 1, "cd_tipo_parceria_projeto": "3"}
				],
				"fonte_recursos": [
					{"cd_fonte_recursos_projeto": "1", "cd_origem_fonte_recursos_projeto": "1", "tx_tipo_parceria_outro": "Teste 1", "tx_orgao_concedente": "Teste 1"},
					{"cd_fonte_recursos_projeto": "2", "cd_origem_fonte_recursos_projeto": "2", "tx_tipo_parceria_outro": "Teste 2", "tx_orgao_concedente": "Teste 2"},
					{"cd_fonte_recursos_projeto": "3", "cd_origem_fonte_recursos_projeto": "3", "tx_tipo_parceria_outro": "Teste 3", "tx_orgao_concedente": "Teste 3"}
				],
				"financiador": [
					{"tx_nome_financiador": "Teste 1"},
					{"tx_nome_financiador": "Teste 2"},
					{"tx_nome_financiador": "Teste 3"}
				],
				"objetivo": [
					{"cd_meta_projeto": 1},
					{"cd_meta_projeto": 2},
					{"cd_meta_projeto": 3}
				]
			}
		]
	}'::JSONB, 
	true::BOOLEAN, 
	true::BOOLEAN, 
	true::BOOLEAN, 
	null::INTEGER, 
	1::INTEGER
);

--SELECT * FROM osc.tb_projeto WHERE id_osc = 1548640;
--SELECT * FROM osc.tb_tipo_parceria_projeto a JOIN osc.tb_projeto b ON a.id_projeto = b.id_projeto WHERE b.id_osc = 1548640;
SELECT * FROM osc.tb_fonte_recursos_projeto a JOIN osc.tb_projeto b ON a.id_projeto = b.id_projeto WHERE b.id_osc = 1548640;