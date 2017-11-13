DROP FUNCTION IF EXISTS portal.atualizar_projeto(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, deletevalido BOOLEAN, errolog BOOLEAN, idcarga INTEGER, tipobusca INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_projeto(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, deletevalido BOOLEAN, errolog BOOLEAN, idcarga INTEGER, tipobusca INTEGER) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$

DECLARE 
	nome_tabela TEXT;
	fonte_dados RECORD;
	objeto RECORD;
	dado_anterior RECORD;
	dado_posterior RECORD;
	registro_nao_delete INTEGER[];
	flag_update BOOLEAN;
	
BEGIN 
	nome_tabela := 'osc.tb_projeto';
	tipo_identificador := lower(tipo_identificador);
	
	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);
	
	IF fonte_dados IS null THEN
		RAISE EXCEPTION 'fonte_invalida';
	ELSIF osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	END IF;
	
	IF tipo_identificador = 'cnpj' THEN 
		SELECT id_osc INTO osc FROM osc.tb_osc WHERE cd_identificador_osc = identificador;
	ELSIF tipo_identificador = 'id_osc' THEN 
		osc := identificador;
	END IF;
	
	IF tipo_identificador != 'cnpj' OR tipo_identificador != 'id_osc' THEN
		RAISE EXCEPTION 'tipo_identificador_invalido';
	ELSIF osc IS null THEN 
		RAISE EXCEPTION 'identificador_invalido';
	END IF;
	
	registro_nao_delete := '{}';
	
	IF json_typeof(json::JSON) = 'object' THEN 
		json := ('[' || json || ']');
	END IF;
	
	FOR objeto IN (SELECT * FROM json_populate_recordset(null::osc.tb_projeto, json::JSON)) 
	LOOP 
		dado_anterior := null;
		
		IF tipobusca = 1 THEN 
			SELECT INTO dado_anterior * FROM osc.tb_projeto WHERE id_projeto = objeto.id_projeto;
			
		ELSIF tipobusca = 2 THEN 
			SELECT INTO dado_anterior * FROM osc.tb_projeto 
			WHERE (tx_identificador_projeto_externo = objeto.tx_identificador_projeto_externo AND cd_uf = objeto.cd_uf AND cd_municipio is null) 
			OR (tx_identificador_projeto_externo = objeto.tx_identificador_projeto_externo AND cd_uf is null AND cd_municipio = objeto.cd_municipio);
			
		ELSE 
			RAISE EXCEPTION 'dado_invalido';
			
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
				tx_orgao_concedente, 
				ft_orgao_concedente, 
				tx_descricao_projeto, 
				ft_descricao_projeto, 
				tx_metodologia_monitoramento, 
				ft_metodologia_monitoramento, 
				tx_link_projeto, 
				ft_link_projeto
			) VALUES (
				osc, 
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
				objeto.tx_orgao_concedente, 
				fonte_dados.nome_fonte, 
				objeto.tx_descricao_projeto, 
				fonte_dados.nome_fonte, 
				objeto.tx_metodologia_monitoramento, 
				fonte_dados.nome_fonte, 
				objeto.tx_link_projeto, 
				fonte_dados.nome_fonte
			) RETURNING * INTO dado_posterior;
			
			registro_nao_delete := array_append(registro_nao_delete, dado_posterior.id_projeto);
			
			PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, dataatualizacao, null, row_to_json(dado_posterior));
			
		ELSE 
			dado_posterior := dado_anterior;
			registro_nao_delete := array_append(registro_nao_delete, dado_posterior.id_projeto);
			flag_update := false;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_identificador_projeto_externo::TEXT, dado_anterior.ft_identificador_projeto_externo, objeto.tx_identificador_projeto_externo::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.tx_identificador_projeto_externo := objeto.tx_identificador_projeto_externo;
				dado_posterior.ft_identificador_projeto_externo := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_municipio::TEXT, dado_anterior.ft_municipio, objeto.cd_municipio::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.cd_municipio := objeto.cd_municipio;
				dado_posterior.ft_municipio := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_uf::TEXT, dado_anterior.ft_uf, objeto.cd_uf::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.cd_uf := objeto.cd_uf;
				dado_posterior.ft_uf := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_nome_projeto::TEXT, dado_anterior.ft_nome_projeto, objeto.tx_nome_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.tx_nome_projeto := objeto.tx_nome_projeto;
				dado_posterior.ft_nome_projeto := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_status_projeto::TEXT, dado_anterior.ft_status_projeto, objeto.cd_status_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.cd_status_projeto := objeto.cd_status_projeto;
				dado_posterior.ft_status_projeto := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_data_inicio_projeto::TEXT, dado_anterior.ft_data_inicio_projeto, objeto.dt_data_inicio_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.dt_data_inicio_projeto := objeto.dt_data_inicio_projeto;
				dado_posterior.ft_data_inicio_projeto := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_data_fim_projeto::TEXT, dado_anterior.ft_data_fim_projeto, objeto.dt_data_fim_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.dt_data_fim_projeto := objeto.dt_data_fim_projeto;
				dado_posterior.ft_data_fim_projeto := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_valor_total_projeto::TEXT, dado_anterior.ft_valor_total_projeto, objeto.nr_valor_total_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.nr_valor_total_projeto := objeto.nr_valor_total_projeto;
				dado_posterior.ft_valor_total_projeto := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_valor_captado_projeto::TEXT, dado_anterior.ft_valor_captado_projeto, objeto.nr_valor_captado_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.nr_valor_captado_projeto := objeto.nr_valor_captado_projeto;
				dado_posterior.ft_valor_captado_projeto := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_total_beneficiarios::TEXT, dado_anterior.ft_total_beneficiarios, objeto.nr_total_beneficiarios::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.nr_total_beneficiarios := objeto.nr_total_beneficiarios;
				dado_posterior.ft_total_beneficiarios := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_abrangencia_projeto::TEXT, dado_anterior.ft_abrangencia_projeto, objeto.cd_abrangencia_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.cd_abrangencia_projeto := objeto.cd_abrangencia_projeto;
				dado_posterior.ft_abrangencia_projeto := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_zona_atuacao_projeto::TEXT, dado_anterior.ft_zona_atuacao_projeto, objeto.cd_zona_atuacao_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.cd_zona_atuacao_projeto := objeto.cd_zona_atuacao_projeto;
				dado_posterior.ft_zona_atuacao_projeto := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_orgao_concedente::TEXT, dado_anterior.ft_orgao_concedente, objeto.tx_orgao_concedente::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.tx_orgao_concedente := objeto.tx_orgao_concedente;
				dado_posterior.ft_orgao_concedente := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_descricao_projeto::TEXT, dado_anterior.ft_descricao_projeto, objeto.tx_descricao_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.tx_descricao_projeto := objeto.tx_descricao_projeto;
				dado_posterior.ft_descricao_projeto := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_metodologia_monitoramento::TEXT, dado_anterior.ft_metodologia_monitoramento, objeto.tx_metodologia_monitoramento::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.tx_metodologia_monitoramento := objeto.tx_metodologia_monitoramento;
				dado_posterior.ft_metodologia_monitoramento := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_link_projeto::TEXT, dado_anterior.ft_link_projeto, objeto.tx_link_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
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
					tx_orgao_concedente = dado_posterior.tx_orgao_concedente, 
					ft_orgao_concedente = dado_posterior.ft_orgao_concedente, 
					tx_descricao_projeto = dado_posterior.tx_descricao_projeto, 
					ft_descricao_projeto = dado_posterior.ft_descricao_projeto, 
					tx_metodologia_monitoramento = dado_posterior.tx_metodologia_monitoramento, 
					ft_metodologia_monitoramento = dado_posterior.ft_metodologia_monitoramento, 
					tx_link_projeto = dado_posterior.tx_link_projeto, 
					ft_link_projeto = dado_posterior.ft_link_projeto 
				WHERE id_projeto = dado_posterior.id_projeto;
				
				PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, dataatualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior));
			END IF;
		
		END IF;
		
	END LOOP;
	
	IF deletevalido THEN 
		DELETE FROM osc.tb_projeto WHERE id_projeto != ALL(registro_nao_delete);
	END IF;
	
	flag := true;
	mensagem := 'Projeto atualizado.';
	
	RETURN NEXT;
	
EXCEPTION 
	WHEN others THEN 
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, osc, dataatualizacao::TIMESTAMP, errolog, idcarga) AS a;
		RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
