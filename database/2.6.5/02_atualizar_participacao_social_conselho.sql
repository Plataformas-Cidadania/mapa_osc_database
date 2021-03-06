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
	conselho_outro TEXT;
	representante RECORD;
	cd_conselho_outra INTEGER;
	cd_conselho_nao_possui INTEGER;
	nao_possui BOOLEAN;
	json_conselho_outro JSONB;
	json_representante JSONB;
	objeto_externo RECORD;
	record_funcao_externa RECORD;

BEGIN
	nome_tabela := 'osc.tb_participacao_social_conselho';
	tipo_identificador := lower(tipo_identificador);
	cd_conselho_outra := (SELECT cd_conselho FROM syst.dc_conselho WHERE tx_nome_conselho = 'Outra' OR tx_nome_conselho = 'Outro' OR tx_nome_conselho = 'Outro Conselho');
	cd_conselho_nao_possui := (SELECT cd_conselho FROM syst.dc_conselho WHERE tx_nome_conselho = 'Não Possui');
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
	
	FOR objeto IN (SELECT * FROM jsonb_to_recordset(json) AS x(conselho JSONB, representante JSONB))
	LOOP
		conselho := (jsonb_populate_record(null::osc.tb_participacao_social_conselho, objeto.conselho));
		conselho_outro := objeto.conselho->>'tx_nome_conselho_outro';
		
		dado_anterior := null;
		
		IF tipo_busca = 1 THEN
			SELECT INTO dado_anterior *
			FROM osc.tb_participacao_social_conselho
			WHERE id_conselho = conselho.id_conselho;
			
		ELSIF tipo_busca = 2 THEN
			SELECT INTO dado_anterior * 
			FROM osc.tb_participacao_social_conselho
			WHERE tb_participacao_social_conselho.cd_conselho = conselho.cd_conselho
			AND tb_participacao_social_conselho.cd_conselho <> cd_conselho_outra
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
			
			PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, null::JSON, row_to_json(dado_posterior), id_carga);
			
		ELSE
			dado_posterior := dado_anterior;
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_conselho);
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
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_periodicidade_reuniao_conselho::TEXT, dado_anterior.ft_periodicidade_reuniao, conselho.cd_periodicidade_reuniao_conselho::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.cd_periodicidade_reuniao_conselho := conselho.cd_periodicidade_reuniao_conselho;
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
				
				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior), id_carga);
			END IF;
		END IF;
		
		json_representante = null::JSONB;
		json_conselho_outro = null::JSONB;
		
		IF conselho.cd_conselho <> cd_conselho_nao_possui THEN
			IF conselho_outro IS NOT null THEN
				json_conselho_outro := ('{"tx_nome_conselho": "' || (objeto.conselho->>'tx_nome_conselho_outro')::TEXT || '"}')::JSONB;
			ELSE
				json_conselho_outro := ('{}')::JSONB;
			END IF;
			
			IF objeto.representante IS NOT null THEN
				json_representante := COALESCE((objeto.representante)::JSONB, '{}'::JSONB);
			END IF;
		ELSE
			dado_nao_delete := ('{' || dado_posterior.id_conselho::TEXT || '}')::INTEGER[];
		END IF;
		
		IF conselho.cd_conselho = cd_conselho_outra AND json_conselho_outro IS NOT null THEN
			SELECT INTO record_funcao_externa * FROM portal.atualizar_osc_participacao_social_conselho_outro(fonte, dado_posterior.id_conselho, data_atualizacao, json_conselho_outro, null_valido, delete_valido, erro_log, id_carga);
			IF record_funcao_externa.flag = false THEN
				RETURN QUERY (SELECT record_funcao_externa.mensagem, false);
			    RETURN;
			END IF;
		END IF;
		
		SELECT INTO record_funcao_externa * FROM portal.atualizar_osc_representante_conselho(fonte, dado_posterior.id_conselho, data_atualizacao, json_representante, null_valido, delete_valido, erro_log, id_carga);
		IF record_funcao_externa.flag = false THEN
				RETURN QUERY (SELECT record_funcao_externa.mensagem, false);
			    RETURN;
		END IF;

		IF conselho.cd_conselho = cd_conselho_nao_possui THEN
			nao_possui := true;
			EXIT;
		END IF;
	END LOOP;

	IF delete_valido THEN
		FOR objeto IN (SELECT * FROM osc.tb_participacao_social_conselho WHERE id_osc = osc.id_osc AND id_conselho != ALL(dado_nao_delete))
		LOOP
			FOR objeto_externo IN (SELECT * FROM osc.tb_participacao_social_conselho_outro WHERE id_conselho = objeto.id_conselho)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto_externo.ft_nome_conselho]) AS a) THEN
					DELETE FROM osc.tb_participacao_social_conselho_outro WHERE id_conselho = objeto_externo.id_conselho AND id_conselho != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_participacao_social_conselho_outro'::TEXT, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto_externo), null::JSON, id_carga);
				END IF;
			END LOOP;
			
			FOR objeto_externo IN (SELECT * FROM osc.tb_representante_conselho WHERE id_participacao_social_conselho = objeto.id_conselho)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto_externo.ft_nome_representante_conselho]) AS a) THEN
					DELETE FROM osc.tb_representante_conselho WHERE id_representante_conselho = objeto_externo.id_representante_conselho AND id_participacao_social_conselho != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_representante_conselho'::TEXT, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto_externo), null::JSON, id_carga);
				END IF;
			END LOOP;

			IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_conselho, objeto.ft_tipo_participacao, objeto.ft_periodicidade_reuniao, objeto.ft_data_inicio_conselho, objeto.ft_data_fim_conselho]) AS a) THEN
				DELETE FROM osc.tb_participacao_social_conselho WHERE id_conselho = objeto.id_conselho AND id_conselho != ALL(dado_nao_delete);
				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto), null::JSON, id_carga);
			END IF;
		END LOOP;
	END IF;
	
	IF nao_possui AND (SELECT EXISTS(SELECT * FROM osc.tb_participacao_social_conselho WHERE cd_conselho <> cd_conselho_nao_possui AND id_osc = osc.id_osc)) THEN 
        SELECT INTO mensagem a.mensagem FROM portal.verificar_erro('P0001', 'nao_possui_invalido', fonte, identificador, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
        RETURN QUERY (SELECT mensagem, false);
		RETURN;
	END IF;
	
	flag := true;
	mensagem := 'Participação social em conselho(s) atualizado.';
	
	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, identificador, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
