DROP FUNCTION IF EXISTS portal.atualizar_participacao_social_conferencia(TEXT, NUMERIC, TEXT, TIMESTAMP, JSONB, BOOLEAN, BOOLEAN, BOOLEAN, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_participacao_social_conferencia(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER, tipo_busca INTEGER) RETURNS TABLE(
	mensagem TEXT,
	flag BOOLEAN
)AS $$

DECLARE
	nome_tabela TEXT;
	fonte_dados RECORD;
	objeto RECORD;
	objeto_externo RECORD;
	dado_anterior RECORD;
	dado_posterior RECORD;
	dado_nao_delete INTEGER[];
	flag_update BOOLEAN;
	osc RECORD;
	conferencia RECORD;
	cd_conferencia_outra INTEGER;
	cd_conferencia_nao_possui INTEGER;
	nao_possui BOOLEAN;
	json_conferencia_outra JSONB;
	record_funcao_externa RECORD;

BEGIN
	nome_tabela := 'osc.tb_participacao_social_conferencia';
	tipo_identificador := lower(tipo_identificador);
	cd_conferencia_outra := (SELECT cd_conferencia FROM syst.dc_conferencia WHERE tx_nome_conferencia = 'Outra' OR tx_nome_conferencia = 'Outro' OR tx_nome_conferencia = 'Outra Conferência');
	cd_conferencia_nao_possui := (SELECT cd_conferencia FROM syst.dc_conferencia WHERE tx_nome_conferencia = 'Não Possui');
	nao_possui := false;
	dado_nao_delete := '{}'::INTEGER[];
	
	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);
	
	IF tipo_identificador = 'cnpj' THEN
		SELECT * INTO osc FROM osc.tb_osc WHERE cd_identificador_osc = identificador::NUMERIC;
	ELSIF tipo_identificador = 'id_osc' THEN
		SELECT * INTO osc FROM osc.tb_osc WHERE id_osc = identificador::INTEGER;
	ELSE 
		RAISE EXCEPTION 'tipo_identificador_invalido';
	END IF;
	
	IF fonte_dados IS null THEN
		RAISE EXCEPTION 'fonte_invalida';
	ELSIF osc IS null THEN
		RAISE EXCEPTION 'osc_nao_encontrada';
	ELSIF osc.id_osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	ELSIF osc.bo_osc_ativa IS false THEN
		RAISE EXCEPTION 'osc_inativa';
	END IF;
	
	IF jsonb_typeof(json) = 'object' THEN
		json := jsonb_build_array(json);
	END IF;
	
	FOR objeto IN (SELECT * FROM jsonb_to_recordset(json) AS x(id_conferencia INTEGER, cd_conferencia INTEGER, dt_ano_realizacao DATE, cd_forma_participacao_conferencia INTEGER, tx_nome_conferencia_outra TEXT))
	LOOP
		dado_anterior := null;
		
		IF tipo_busca = 1 THEN
			SELECT INTO dado_anterior *
			FROM osc.tb_participacao_social_conferencia
			WHERE id_conferencia = objeto.id_conferencia;
			
		ELSIF tipo_busca = 2 THEN
			SELECT INTO dado_anterior * 
			FROM osc.tb_participacao_social_conferencia
			WHERE tb_participacao_social_conferencia.cd_conferencia = objeto.cd_conferencia
			AND tb_participacao_social_conferencia.id_osc = osc.id_osc;
			
		ELSE
			RAISE EXCEPTION 'tipo_busca_invalido';

		END IF;
		
		IF dado_anterior.id_conferencia IS null THEN
			INSERT INTO osc.tb_participacao_social_conferencia (
				id_osc,
				cd_conferencia,
				ft_conferencia,
				dt_ano_realizacao,
				ft_ano_realizacao,
				cd_forma_participacao_conferencia,
				ft_forma_participacao_conferencia
			) VALUES (
				osc.id_osc,
				objeto.cd_conferencia,
				fonte_dados.nome_fonte,
				objeto.dt_ano_realizacao,
				fonte_dados.nome_fonte,
				objeto.cd_forma_participacao_conferencia,
				fonte_dados.nome_fonte
			) RETURNING * INTO dado_posterior;
			
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_conferencia);
			
			PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, null::JSON, row_to_json(dado_posterior), id_carga);
			
		ELSE
			dado_posterior := dado_anterior;
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_conferencia);
			flag_update := false;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_conferencia::TEXT, dado_anterior.ft_conferencia, objeto.cd_conferencia::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.cd_conferencia := objeto.cd_conferencia;
				dado_posterior.ft_conferencia := fonte_dados.nome_fonte;
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
				UPDATE osc.tb_participacao_social_conferencia
				SET	cd_conferencia = dado_posterior.cd_conferencia,
					ft_conferencia = dado_posterior.ft_conferencia,
					dt_ano_realizacao = dado_posterior.dt_ano_realizacao,
					ft_ano_realizacao = dado_posterior.ft_ano_realizacao,
					cd_forma_participacao_conferencia = dado_posterior.cd_forma_participacao_conferencia,
					ft_forma_participacao_conferencia = dado_posterior.ft_forma_participacao_conferencia
				WHERE id_conferencia = dado_posterior.id_conferencia;
				
				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior), id_carga);
			END IF;
		END IF;
		
		json_conferencia_outra = null::JSONB;
		
		IF objeto.cd_conferencia <> cd_conferencia_nao_possui THEN
			IF objeto.tx_nome_conferencia_outra IS NOT null THEN
				json_conferencia_outra := ('{"tx_nome_conferencia": "' || objeto.tx_nome_conferencia_outra || '"}')::JSONB;
			ELSE
				json_conferencia_outra := ('{}')::JSONB;
			END IF;
		ELSE
			dado_nao_delete := ('{' || dado_posterior.id_conferencia::TEXT || '}')::INTEGER[];
		END IF;
		
		IF objeto.cd_conferencia = cd_conferencia_outra AND json_conferencia_outra IS NOT null THEN
			SELECT INTO record_funcao_externa * FROM portal.atualizar_osc_participacao_social_conferencia_outra(fonte, dado_posterior.id_conferencia, data_atualizacao, json_conferencia_outra, null_valido, delete_valido, erro_log, id_carga);
			IF record_funcao_externa.flag = false THEN
				mensagem := record_funcao_externa.mensagem;
				RAISE EXCEPTION 'funcao_externa';
			END IF;
		END IF;

		IF objeto.cd_conferencia = cd_conferencia_nao_possui THEN
			nao_possui := true;
			EXIT;
		END IF;
	END LOOP;

	IF delete_valido THEN
		FOR objeto IN (SELECT * FROM osc.tb_participacao_social_conferencia WHERE id_osc = osc.id_osc AND id_conferencia != ALL(dado_nao_delete))
		LOOP
			FOR objeto_externo IN (SELECT * FROM osc.tb_participacao_social_conferencia_outra WHERE id_conferencia = objeto.id_conferencia)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto_externo.ft_nome_conferencia]) AS a) THEN
					DELETE FROM osc.tb_participacao_social_conferencia_outra WHERE id_conferencia = objeto_externo.id_conferencia AND id_conferencia != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_participacao_social_conferencia_outra'::TEXT, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto_externo), null::JSON, id_carga);
				END IF;
			END LOOP;

			IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_conferencia, objeto.ft_ano_realizacao, objeto.ft_forma_participacao_conferencia]) AS a) THEN
				DELETE FROM osc.tb_participacao_social_conferencia WHERE id_conferencia = objeto.id_conferencia AND id_conferencia != ALL(dado_nao_delete);
				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto), null::JSON, id_carga);
			END IF;
		END LOOP;
	END IF;
	
	IF nao_possui AND (SELECT EXISTS(SELECT * FROM osc.tb_participacao_social_conferencia WHERE cd_conferencia <> cd_conferencia_nao_possui AND id_osc = osc.id_osc)) THEN 
		RAISE EXCEPTION 'nao_possui_invalido';
	END IF;
	
	flag := true;
	mensagem := 'Participação social em conferência(s) atualizada.';
	
	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		raise notice '%', SQLERRM;
		flag := false;

		IF SQLERRM <> 'funcao_externa' THEN 
			SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, identificador, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		END IF;
		
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
