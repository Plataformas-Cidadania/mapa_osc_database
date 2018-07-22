DROP FUNCTION IF EXISTS portal.atualizar_participacao_social_outra(TEXT, NUMERIC, TEXT, TIMESTAMP, JSONB, BOOLEAN, BOOLEAN, BOOLEAN, INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_participacao_social_outra(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER) RETURNS TABLE(
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

BEGIN
	nome_tabela := 'osc.tb_participacao_social_outra';
	tipo_identificador := lower(tipo_identificador);
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
	
	FOR objeto IN (SELECT * FROM jsonb_to_recordset(null::osc.tb_participacao_social_outra, json))
	LOOP
		dado_anterior := null;
		
		SELECT INTO dado_anterior *
		FROM osc.tb_participacao_social_outra
		WHERE id_participacao_social_outra = objeto.id_participacao_social_outra;

		IF dado_anterior.id_participacao_social_outra IS null THEN
			INSERT INTO osc.tb_participacao_social_outra (
				id_osc,
				tx_nome_participacao_social_outra,
				bo_nao_possui,
				ft_participacao_social_outra
			) VALUES (
				osc.id_osc,
				objeto.tx_nome_participacao_social_outra,
				objeto.bo_nao_possui,
				fonte_dados.nome_fonte
			) RETURNING * INTO dado_posterior;
			
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_participacao_social_outra);
			
			PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, null::JSON, row_to_json(dado_posterior), id_carga);
			
		ELSE
			dado_posterior := dado_anterior;
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_participacao_social_outra);
			flag_update := false;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_nome_participacao_social_outra::TEXT, dado_anterior.ft_participacao_social_outra, objeto.tx_nome_participacao_social_outra::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.tx_nome_participacao_social_outra := objeto.tx_nome_participacao_social_outra;
				dado_posterior.ft_participacao_social_outra := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.bo_nao_possui::TEXT, dado_anterior.ft_participacao_social_outra, objeto.bo_nao_possui::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.bo_nao_possui := objeto.bo_nao_possui;
				dado_posterior.ft_participacao_social_outra := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF flag_update THEN
				UPDATE osc.tb_participacao_social_outra
				SET	tx_nome_participacao_social_outra = dado_posterior.tx_nome_participacao_social_outra,
					bo_nao_possui = dado_posterior.bo_nao_possui,
					ft_participacao_social_outra = dado_posterior.ft_participacao_social_outra
				WHERE id_participacao_social_outra = dado_posterior.id_participacao_social_outra;
				
				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior), id_carga);
			END IF;
		END IF;
		
		IF objeto.bo_nao_possui THEN
			dado_nao_delete := ('{' || dado_posterior.id_participacao_social_outra::TEXT || '}')::INTEGER[];
			nao_possui := true;
			EXIT;
		END IF;
	END LOOP;

	IF delete_valido THEN
		FOR objeto IN (SELECT * FROM osc.tb_participacao_social_outra WHERE id_osc = osc.id_osc AND id_participacao_social_outra != ALL(dado_nao_delete))
		LOOP
			IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_participacao_social_outra]) AS a) THEN
				DELETE FROM osc.tb_participacao_social_outra WHERE id_participacao_social_outra = objeto.id_participacao_social_outra AND id_participacao_social_outra != ALL(dado_nao_delete);
				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto), null::JSON, id_carga);
			END IF;
		END LOOP;
	END IF;
	
	IF nao_possui AND (SELECT EXISTS(SELECT * FROM osc.tb_participacao_social_outra WHERE bo_nao_possui IS false AND id_osc = osc.id_osc)) THEN 
		RAISE EXCEPTION 'nao_possui_invalido';
	END IF;
	
	flag := true;
	mensagem := 'Outra participação social atualizada.';
	
	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, identificador, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
