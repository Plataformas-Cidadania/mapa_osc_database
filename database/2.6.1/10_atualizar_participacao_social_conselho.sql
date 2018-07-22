DROP FUNCTION IF EXISTS portal.atualizar_participacao_social_conselho(TEXT, NUMERIC, TEXT, TIMESTAMP, JSONB, BOOLEAN, BOOLEAN, BOOLEAN, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_participacao_social_conselho(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER, tipo_busca INTEGER) RETURNS TABLE(
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
	conselho RECORD;
	representante RECORD;
	nao_possui BOOLEAN;
	representantes JSONB;
	record_representantes RECORD;
	conselho_outro JSONB[];
	record_conselho_outro RECORD;

BEGIN
	nome_tabela := 'osc.tb_participacao_social_conselho';
	tipo_identificador := lower(tipo_identificador);
	nao_possui := false;
	
	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);
	
	IF fonte_dados IS null THEN
		RAISE EXCEPTION 'fonte_invalida';
	ELSIF osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	END IF;
	
	IF tipo_identificador = 'cnpj' THEN
		SELECT * INTO osc FROM osc.tb_osc WHERE cd_identificador_osc = identificador::NUMERIC;
	ELSIF tipo_identificador = 'id_osc' THEN
		SELECT * INTO osc FROM osc.tb_osc WHERE id_osc = identificador::INTEGER;
	ELSE 
		RAISE EXCEPTION 'tipo_identificador_invalido';
	END IF;
	
	IF osc IS null THEN
		RAISE EXCEPTION 'osc_nao_encontrada';
	ELSIF osc.bo_osc_ativa IS false THEN
		RAISE EXCEPTION 'osc_inativa';
	ELSIF osc.id_osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	END IF;
	
	FOR objeto IN (SELECT * FROM json_to_recordset(json) AS x(conselho jsonb, representante jsonb))
	LOOP
		conselho = (SELECT * FROM jsonb_populate_record(null::osc.tb_participacao_social_conselho, objeto.conselho);
		
		dado_anterior := null;
		
		IF tipo_busca = 1 THEN
			SELECT INTO dado_anterior *
			FROM osc.tb_participacao_social_conselho
			WHERE id_conselho = conselho.id_conselho;
			
		ELSIF tipo_busca = 2 THEN
			SELECT INTO dado_anterior * 
			FROM osc.tb_participacao_social_conselho
			INNER JOIN syst.dc_conselho
			WHERE tb_participacao_social_conselho.cd_conselho = conselho.cd_conselho
			AND dc_conselho.tx_nome_conselho <> 'Outra'
			AND tb_participacao_social_conselho.id_osc = osc.id_osc;
			
		ELSE
			RAISE EXCEPTION 'tipo_busca_invalido';

		END IF;
		
		IF dado_anterior.id_conselho IS null THEN
			INSERT INTO osc.tb_participacao_social_conselho (
				id_osc,
				cd_conselho,
				ft_conselho,
				cd_tipo_participacao,
				ft_tipo_participacao,
				cd_periodicidade_reuniao_conselho,
				ft_periodicidade_reuniao,
				dt_data_inicio_conselho,
				ft_data_inicio_conselho,
				dt_data_fim_conselho,
				ft_data_fim_conselho
			) VALUES (
				osc.id_osc,
				conselho.cd_conselho,
				fonte_dados.nome_fonte,
				conselho.cd_tipo_participacao,
				fonte_dados.nome_fonte,
				conselho.cd_periodicidade_reuniao_conselho,
				fonte_dados.nome_fonte,
				conselho.dt_data_inicio_conselho,
				fonte_dados.nome_fonte,
				conselho.dt_data_fim_conselho,
				fonte_dados.nome_fonte
			) RETURNING * INTO dado_posterior;
			
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_conselho);
			
			PERFORM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, null, row_to_json(dado_posterior), id_carga);
			
		ELSE
			dado_posterior := dado_anterior;
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_projeto);
			flag_update := false;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_conselho::TEXT, dado_anterior.ft_conselho, conselho.cd_conselho::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.cd_conselho := conselho.cd_conselho;
				dado_posterior.ft_conselho := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_tipo_participacao::TEXT, dado_anterior.ft_tipo_participacao, conselho.cd_tipo_participacao::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.cd_tipo_participacao := conselho.cd_tipo_participacao;
				dado_posterior.ft_tipo_participacao := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_periodicidade_reuniao_conselho::TEXT, dado_anterior.ft_periodicidade_reuniao, objeto.cd_periodicidade_reuniao_conselho::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.cd_periodicidade_reuniao_conselho := objeto.cd_periodicidade_reuniao_conselho;
				dado_posterior.ft_periodicidade_reuniao := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_data_inicio_conselho::TEXT, dado_anterior.ft_data_inicio_conselho, conselho.dt_data_inicio_conselho::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.dt_data_inicio_conselho := conselho.dt_data_inicio_conselho;
				dado_posterior.ft_data_inicio_conselho := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_data_fim_conselho::TEXT, dado_anterior.ft_data_fim_conselho, conselho.dt_data_fim_conselho::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.dt_data_fim_conselho := conselho.dt_data_fim_conselho;
				dado_posterior.ft_data_fim_conselho := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF flag_update THEN
				UPDATE osc.tb_participacao_social_conselho
				SET	cd_conselho = dado_posterior.cd_conselho,
					ft_conselho = dado_posterior.ft_conselho,
					cd_tipo_participacao = dado_posterior.cd_tipo_participacao,
					ft_tipo_participacao = dado_posterior.ft_tipo_participacao,
					cd_periodicidade_reuniao_conselho = dado_posterior.cd_periodicidade_reuniao_conselho,
					ft_periodicidade_reuniao = dado_posterior.ft_periodicidade_reuniao,
					dt_data_inicio_conselho = dado_posterior.dt_data_inicio_conselho,
					ft_data_inicio_conselho = dado_posterior.ft_data_inicio_conselho,
					dt_data_fim_conselho = dado_posterior.dt_data_fim_conselho,
					ft_data_fim_conselho = dado_posterior.ft_data_fim_conselho
				WHERE id_conselho = dado_posterior.id_conselho;
				
				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior), id_carga);
			END IF;
		END IF;
		
		FOR representante IN (SELECT * FROM jsonb_populate_recordset(null::osc.tb_representante_conselho, objeto.representante))
		LOOP
			SELECT INTO dado_anterior *
			FROM osc.tb_representante_conselho
			WHERE id_representante_conselho = representante.id_representante_conselho;

			IF dado_anterior.id_conselho IS null THEN
				INSERT INTO osc.tb_representante_conselho (
					id_osc,
					id_participacao_social_conselho,
					tx_nome_representante_conselho,
					ft_nome_representante_conselho
				) VALUES (
					osc.id_osc,
					representante.id_participacao_social_conselho,
					representante.tx_nome_representante_conselho,
					fonte_dados.nome_fonte
				) RETURNING * INTO dado_posterior;
				
				dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_representante_conselho);
				
				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, null, row_to_json(dado_posterior), id_carga);
				
			ELSE
				dado_posterior := dado_anterior;
				dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_projeto);
				flag_update := false;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_conselho::TEXT, dado_anterior.ft_conselho, conselho.cd_conselho::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.cd_conselho := conselho.cd_conselho;
					dado_posterior.ft_conselho := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_tipo_participacao::TEXT, dado_anterior.ft_tipo_participacao, conselho.cd_tipo_participacao::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.cd_tipo_participacao := conselho.cd_tipo_participacao;
					dado_posterior.ft_tipo_participacao := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_periodicidade_reuniao_conselho::TEXT, dado_anterior.ft_periodicidade_reuniao, objeto.cd_periodicidade_reuniao_conselho::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.cd_periodicidade_reuniao_conselho := objeto.cd_periodicidade_reuniao_conselho;
					dado_posterior.ft_periodicidade_reuniao := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_data_inicio_conselho::TEXT, dado_anterior.ft_data_inicio_conselho, conselho.dt_data_inicio_conselho::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.dt_data_inicio_conselho := conselho.dt_data_inicio_conselho;
					dado_posterior.ft_data_inicio_conselho := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_data_fim_conselho::TEXT, dado_anterior.ft_data_fim_conselho, conselho.dt_data_fim_conselho::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.dt_data_fim_conselho := conselho.dt_data_fim_conselho;
					dado_posterior.ft_data_fim_conselho := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
				
				IF flag_update THEN
					UPDATE osc.tb_participacao_social_conselho
					SET	cd_conselho = dado_posterior.cd_conselho,
						ft_conselho = dado_posterior.ft_conselho,
						cd_tipo_participacao = dado_posterior.cd_tipo_participacao,
						ft_tipo_participacao = dado_posterior.ft_tipo_participacao,
						cd_periodicidade_reuniao_conselho = dado_posterior.cd_periodicidade_reuniao_conselho,
						ft_periodicidade_reuniao = dado_posterior.ft_periodicidade_reuniao,
						dt_data_inicio_conselho = dado_posterior.dt_data_inicio_conselho,
						ft_data_inicio_conselho = dado_posterior.ft_data_inicio_conselho,
						dt_data_fim_conselho = dado_posterior.dt_data_fim_conselho,
						ft_data_fim_conselho = dado_posterior.ft_data_fim_conselho
					WHERE id_conselho = dado_posterior.id_conselho;
					
					PERFORM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior), id_carga);
				END IF;
			END IF;
		END LOOP;

	END LOOP;

	localizacao = COALESCE((json->>'localizacao')::JSONB, '{}'::JSONB);
	SELECT INTO record_localizacao * FROM portal.atualizar_localizacao_projeto(fonte, identificador, data_atualizacao, objetivos, null_valido, delete_valido, erro_log, id_carga, tipo_busca);
	IF record_localizacao.flag = false THEN 
		mensagem := record_localizacao.mensagem;
		RAISE EXCEPTION 'funcao_externa';
	END IF;

	IF delete_valido AND nao_possui IS false THEN
		FOR objeto IN (SELECT * FROM osc.tb_participacao_social_conselho WHERE id_osc = osc AND id_projeto != ALL(dado_nao_delete))
		LOOP
			FOR projeto IN (SELECT * FROM osc.tb_tipo_parceria_projeto WHERE id_projeto = objeto.id_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[projeto.ft_tipo_parceria_projeto]) AS a) THEN
					DELETE FROM osc.tb_tipo_parceria_projeto WHERE id_projeto = projeto.id_projeto AND id_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_tipo_parceria_projeto', osc, fonte, data_atualizacao, row_to_json(projeto), null, id_carga);
				ELSE
					dado_nao_delete := array_append(dado_nao_delete, projeto.id_projeto);
				END IF;
			END LOOP;
			
			FOR projeto IN (SELECT * FROM osc.tb_fonte_recursos_projeto WHERE id_projeto = objeto.id_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[projeto.ft_fonte_recursos_projeto, projeto.ft_orgao_concedente]) AS a) THEN
					DELETE FROM osc.tb_fonte_recursos_projeto WHERE id_projeto = projeto.id_projeto AND id_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_fonte_recursos_projeto', osc, fonte, data_atualizacao, row_to_json(projeto), null, id_carga);
				ELSE
					dado_nao_delete := array_append(dado_nao_delete, projeto.id_projeto);
				END IF;
			END LOOP;
			
			FOR projeto IN (SELECT * FROM osc.tb_area_atuacao_outra_projeto WHERE id_projeto = objeto.id_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[projeto.ft_area_atuacao_outra_projeto]) AS a) THEN
					DELETE FROM osc.tb_area_atuacao_outra_projeto WHERE id_projeto = projeto.id_projeto AND id_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_area_atuacao_outra_projeto', osc, fonte, data_atualizacao, row_to_json(projeto), null, id_carga);
				ELSE
					dado_nao_delete := array_append(dado_nao_delete, projeto.id_projeto);
				END IF;
			END LOOP;
			
			FOR projeto IN (SELECT * FROM osc.tb_area_atuacao_projeto WHERE id_projeto = objeto.id_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[projeto.ft_area_atuacao_projeto]) AS a) THEN
					DELETE FROM osc.tb_area_atuacao_projeto WHERE id_projeto = projeto.id_projeto AND id_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_area_atuacao_projeto', osc, fonte, data_atualizacao, row_to_json(projeto), null, id_carga);
				ELSE
					dado_nao_delete := array_append(dado_nao_delete, projeto.id_projeto);
				END IF;
			END LOOP;
			
			FOR projeto IN (SELECT * FROM osc.tb_financiador_projeto WHERE id_projeto = objeto.id_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[projeto.ft_nome_financiador]) AS a) THEN
					DELETE FROM osc.tb_financiador_projeto WHERE id_projeto = projeto.id_projeto AND id_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_financiador_projeto', osc, fonte, data_atualizacao, row_to_json(projeto), null, id_carga);
				ELSE
					dado_nao_delete := array_append(dado_nao_delete, projeto.id_projeto);
				END IF;
			END LOOP;
			/*
			FOR projeto IN (SELECT * FROM osc.tb_localizacao_projeto WHERE id_projeto = objeto.id_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[projeto.ft_regiao_localizacao_projeto, projeto.ft_nome_regiao_localizacao_projeto, projeto.ft_localizacao_prioritaria]) AS a) THEN
					DELETE FROM osc.tb_localizacao_projeto WHERE id_projeto = projeto.id_projeto AND id_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_localizacao_projeto', osc, fonte, data_atualizacao, row_to_json(projeto), null, id_carga);
				ELSE
					dado_nao_delete := array_append(dado_nao_delete, projeto.id_projeto);
				END IF;
			END LOOP;
			
			FOR projeto IN (SELECT * FROM osc.tb_objetivo_projeto WHERE id_projeto = objeto.id_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[projeto.ft_objetivo_projeto]) AS a) THEN
					DELETE FROM osc.tb_objetivo_projeto WHERE id_projeto = projeto.id_projeto AND id_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_objetivo_projeto', osc, fonte, data_atualizacao, row_to_json(projeto), null, id_carga);
				ELSE
					dado_nao_delete := array_append(dado_nao_delete, projeto.id_projeto);
				END IF;
			END LOOP;
			*/
			FOR projeto IN (SELECT * FROM osc.tb_osc_parceira_projeto WHERE id_projeto = objeto.id_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[projeto.ft_osc_parceira_projeto]) AS a) THEN
					DELETE FROM osc.tb_osc_parceira_projeto WHERE id_projeto = projeto.id_projeto AND id_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_osc_parceira_projeto', osc, fonte, data_atualizacao, row_to_json(projeto), null, id_carga);
				ELSE
					dado_nao_delete := array_append(dado_nao_delete, projeto.id_projeto);
				END IF;
			END LOOP;
			
			FOR projeto IN (SELECT * FROM osc.tb_publico_beneficiado_projeto WHERE id_projeto = objeto.id_projeto)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[projeto.ft_publico_beneficiado_projeto]) AS a) THEN
					DELETE FROM osc.tb_publico_beneficiado_projeto WHERE id_projeto = projeto.id_projeto AND id_projeto != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_publico_beneficiado_projeto', osc, fonte, data_atualizacao, row_to_json(projeto), null, id_carga);
				ELSE
					dado_nao_delete := array_append(dado_nao_delete, projeto.id_projeto);
				END IF;
			END LOOP;
			
			IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_identificador_projeto_externo, objeto.ft_uf, objeto.ft_municipio, objeto.ft_nome_projeto, objeto.ft_status_projeto, objeto.ft_data_inicio_projeto, objeto.ft_data_fim_projeto, objeto.ft_valor_total_projeto, objeto.ft_valor_captado_projeto, objeto.ft_total_beneficiarios, objeto.ft_abrangencia_projeto, objeto.ft_zona_atuacao_projeto, objeto.ft_descricao_projeto, objeto.ft_metodologia_monitoramento, objeto.ft_link_projeto]) AS a) THEN
				DELETE FROM osc.tb_participacao_social_conselho WHERE id_projeto = objeto.id_projeto AND id_projeto != ALL(dado_nao_delete);
				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
			ELSE
				dado_nao_delete := array_append(dado_nao_delete, projeto.id_projeto);
			END IF;
		END LOOP;
	END IF;
	
	IF nao_possui AND (SELECT EXISTS(SELECT * FROM osc.tb_participacao_social_conselho WHERE id_osc = osc)) THEN 
		RAISE EXCEPTION 'nao_possui_invalido';
	END IF;
	
	flag := true;
	mensagem := 'Projetos de OSC atualizado.';
	
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
