DROP FUNCTION IF EXISTS portal.atualizar_projeto(fonte TEXT, osc INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN, deletevalido BOOLEAN, tipobusca INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_projeto(fonte TEXT, osc INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN, deletevalido BOOLEAN, tipobusca INTEGER) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$

DECLARE 
	nome_tabela TEXT;
	operacao TEXT;
	fonte_dados_nao_oficiais TEXT[];
	tipo_usuario TEXT;
	objeto RECORD;
	registro_anterior RECORD;
	registro_posterior RECORD;
	registro_nao_delete INTEGER[];
	flag_update BOOLEAN;
	
BEGIN 
	nome_tabela := 'osc.tb_projeto';
	operacao := 'portal.atualizar_projeto(' || fonte::TEXT || ', ' || osc::TEXT || ', ' || dataatualizacao::TEXT || ', ' || json::TEXT || ', ' || nullvalido::TEXT || ', ' || errolog::TEXT || ', ' || deletevalido::TEXT || ', ' || tipobusca::TEXT || ')';
	
	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);
	
	IF fonte_dados.nome_fonte IS null THEN 
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro('fonte_invalida', operacao, fonte, osc, dataatualizacao::TIMESTAMP, errolog) AS a;
	
	ELSIF osc != ALL(fonte_dados.representacao) THEN 
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro('permissao_negada_usuario', operacao, fonte, osc, dataatualizacao::TIMESTAMP, errolog) AS a;
	
	ELSE 
		IF tipobusca IS null THEN 
			tipobusca := 1;
		END IF;
		
		SELECT INTO fonte_dados_nao_oficiais array_agg(tx_nome_tipo_usuario) 
		FROM syst.dc_tipo_usuario;
		
		registro_nao_delete := '{}';
		
		IF json_typeof(json::JSON) = 'object' THEN 
			json := ('[' || json || ']');
		END IF;
		
		FOR objeto IN (SELECT *FROM json_populate_recordset(null::osc.tb_projeto, json::JSON)) 
		LOOP 
			registro_anterior := null;
			
			IF tipobusca = 1 THEN 
				SELECT INTO registro_anterior * 
				FROM osc.tb_projeto 
				WHERE id_projeto = objeto.id_projeto;
				
			ELSIF tipobusca = 2 THEN 
				SELECT INTO registro_anterior * 
				FROM osc.tb_projeto 
				WHERE (tx_identificador_projeto_externo = objeto.tx_identificador_projeto_externo AND cd_uf = objeto.cd_uf AND cd_municipio is null) 
				OR (tx_identificador_projeto_externo = objeto.tx_identificador_projeto_externo AND cd_uf is null AND cd_municipio = objeto.cd_municipio);
				
			END IF;
			
			IF registro_anterior.id_projeto IS null THEN 
				IF objeto.cd_municipio > 0 THEN 
					INSERT INTO osc.tb_projeto (
						id_osc, 
						tx_identificador_projeto_externo, 
						ft_identificador_projeto_externo, 
						cd_municipio, 
						ft_municipio, 
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
						tipo_usuario, 
						objeto.cd_municipio, 
						tipo_usuario, 
						objeto.tx_nome_projeto, 
						tipo_usuario, 
						objeto.cd_status_projeto, 
						tipo_usuario, 
						objeto.dt_data_inicio_projeto, 
						tipo_usuario, 
						objeto.dt_data_fim_projeto, 
						tipo_usuario, 
						objeto.nr_valor_total_projeto, 
						tipo_usuario, 
						objeto.nr_valor_captado_projeto, 
						tipo_usuario, 
						objeto.nr_total_beneficiarios, 
						tipo_usuario, 
						objeto.cd_abrangencia_projeto, 
						tipo_usuario, 
						objeto.cd_zona_atuacao_projeto, 
						tipo_usuario, 
						objeto.tx_orgao_concedente, 
						tipo_usuario, 
						objeto.tx_descricao_projeto, 
						tipo_usuario, 
						objeto.tx_metodologia_monitoramento, 
						tipo_usuario, 
						objeto.tx_link_projeto, 
						tipo_usuario
					) RETURNING * INTO registro_posterior;
					
				ELSE 
					INSERT INTO osc.tb_projeto (
						id_osc, 
						tx_identificador_projeto_externo, 
						ft_identificador_projeto_externo, 
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
						tipo_usuario, 
						objeto.cd_uf, 
						tipo_usuario, 
						objeto.tx_nome_projeto, 
						tipo_usuario, 
						objeto.cd_status_projeto, 
						tipo_usuario, 
						objeto.dt_data_inicio_projeto, 
						tipo_usuario, 
						objeto.dt_data_fim_projeto, 
						tipo_usuario, 
						objeto.nr_valor_total_projeto, 
						tipo_usuario, 
						objeto.nr_valor_captado_projeto, 
						tipo_usuario, 
						objeto.nr_total_beneficiarios, 
						tipo_usuario, 
						objeto.cd_abrangencia_projeto, 
						tipo_usuario, 
						objeto.cd_zona_atuacao_projeto, 
						tipo_usuario, 
						objeto.tx_orgao_concedente, 
						tipo_usuario, 
						objeto.tx_descricao_projeto, 
						tipo_usuario, 
						objeto.tx_metodologia_monitoramento, 
						tipo_usuario, 
						objeto.tx_link_projeto, 
						tipo_usuario
					) RETURNING * INTO registro_posterior;

				END IF;
				
				registro_nao_delete := array_append(registro_nao_delete, registro_posterior.id_projeto);
				
				INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
				VALUES (nome_tabela, osc, fonte::INTEGER, dataatualizacao, null, row_to_json(registro_posterior));
				
			ELSE 
				registro_posterior := registro_anterior;
				registro_nao_delete := array_append(registro_nao_delete, registro_posterior.id_projeto);
				flag_update := false;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_identificador_projeto_externo::TEXT, dado_anterior.ft_identificador_projeto_externo, objeto.tx_identificador_projeto_externo::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
					registro_posterior.tx_identificador_projeto_externo := objeto.tx_identificador_projeto_externo;
					registro_posterior.ft_identificador_projeto_externo := tipo_usuario;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_municipio::TEXT, dado_anterior.ft_municipio, objeto.cd_municipio::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
					registro_posterior.cd_municipio := objeto.cd_municipio;
					registro_posterior.ft_municipio := tipo_usuario;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_uf::TEXT, dado_anterior.ft_uf, objeto.cd_uf::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
					registro_posterior.cd_uf := objeto.cd_uf;
					registro_posterior.ft_uf := tipo_usuario;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_nome_projeto::TEXT, dado_anterior.ft_nome_projeto, objeto.tx_nome_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
					registro_posterior.tx_nome_projeto := objeto.tx_nome_projeto;
					registro_posterior.ft_nome_projeto := tipo_usuario;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_status_projeto::TEXT, dado_anterior.ft_status_projeto, objeto.cd_status_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
					registro_posterior.cd_status_projeto := objeto.cd_status_projeto;
					registro_posterior.ft_status_projeto := tipo_usuario;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_data_inicio_projeto::TEXT, dado_anterior.ft_data_inicio_projeto, objeto.dt_data_inicio_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
					registro_posterior.dt_data_inicio_projeto := objeto.dt_data_inicio_projeto;
					registro_posterior.ft_data_inicio_projeto := tipo_usuario;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_data_fim_projeto::TEXT, dado_anterior.ft_data_fim_projeto, objeto.dt_data_fim_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
					registro_posterior.dt_data_fim_projeto := objeto.dt_data_fim_projeto;
					registro_posterior.ft_data_fim_projeto := tipo_usuario;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_valor_total_projeto::TEXT, dado_anterior.ft_valor_total_projeto, objeto.nr_valor_total_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
					registro_posterior.nr_valor_total_projeto := objeto.nr_valor_total_projeto;
					registro_posterior.ft_valor_total_projeto := tipo_usuario;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_valor_captado_projeto::TEXT, dado_anterior.ft_valor_captado_projeto, objeto.nr_valor_captado_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
					registro_posterior.nr_valor_captado_projeto := objeto.nr_valor_captado_projeto;
					registro_posterior.ft_valor_captado_projeto := tipo_usuario;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_total_beneficiarios::TEXT, dado_anterior.ft_total_beneficiarios, objeto.nr_total_beneficiarios::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
					registro_posterior.nr_total_beneficiarios := objeto.nr_total_beneficiarios;
					registro_posterior.ft_total_beneficiarios := tipo_usuario;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_abrangencia_projeto::TEXT, dado_anterior.ft_abrangencia_projeto, objeto.cd_abrangencia_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
					registro_posterior.cd_abrangencia_projeto := objeto.cd_abrangencia_projeto;
					registro_posterior.ft_abrangencia_projeto := tipo_usuario;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_zona_atuacao_projeto::TEXT, dado_anterior.ft_zona_atuacao_projeto, objeto.cd_zona_atuacao_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
					registro_posterior.cd_zona_atuacao_projeto := objeto.cd_zona_atuacao_projeto;
					registro_posterior.ft_zona_atuacao_projeto := tipo_usuario;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_orgao_concedente::TEXT, dado_anterior.ft_orgao_concedente, objeto.tx_orgao_concedente::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
					registro_posterior.tx_orgao_concedente := objeto.tx_orgao_concedente;
					registro_posterior.ft_orgao_concedente := tipo_usuario;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_descricao_projeto::TEXT, dado_anterior.ft_descricao_projeto, objeto.tx_descricao_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
					registro_posterior.tx_descricao_projeto := objeto.tx_descricao_projeto;
					registro_posterior.ft_descricao_projeto := tipo_usuario;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_metodologia_monitoramento::TEXT, dado_anterior.ft_metodologia_monitoramento, objeto.tx_metodologia_monitoramento::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
					registro_posterior.tx_metodologia_monitoramento := objeto.tx_metodologia_monitoramento;
					registro_posterior.ft_metodologia_monitoramento := tipo_usuario;
					flag_update := true;
				END IF;
				
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_link_projeto::TEXT, dado_anterior.ft_link_projeto, objeto.tx_link_projeto::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
					registro_posterior.tx_link_projeto := objeto.tx_link_projeto;
					registro_posterior.ft_link_projeto := tipo_usuario;
					flag_update := true;
				END IF;
				
				IF flag_update THEN 
					UPDATE osc.tb_projeto 
					SET	tx_identificador_projeto_externo = registro_posterior.tx_identificador_projeto_externo, 
						ft_identificador_projeto_externo = registro_posterior.ft_identificador_projeto_externo, 
						cd_uf = registro_posterior.cd_uf, 
						ft_uf = registro_posterior.ft_uf, 
						cd_municipio = registro_posterior.cd_municipio, 
						ft_municipio = registro_posterior.ft_municipio, 
						tx_nome_projeto = registro_posterior.tx_nome_projeto, 
						ft_nome_projeto = registro_posterior.ft_nome_projeto, 
						cd_status_projeto = registro_posterior.cd_status_projeto, 
						ft_status_projeto = registro_posterior.ft_status_projeto, 
						dt_data_inicio_projeto = registro_posterior.dt_data_inicio_projeto, 
						ft_data_inicio_projeto = registro_posterior.ft_data_inicio_projeto, 
						dt_data_fim_projeto = registro_posterior.dt_data_fim_projeto, 
						ft_data_fim_projeto = registro_posterior.ft_data_fim_projeto, 
						nr_valor_total_projeto = registro_posterior.nr_valor_total_projeto, 
						ft_valor_total_projeto = registro_posterior.ft_valor_total_projeto, 
						nr_valor_captado_projeto = registro_posterior.nr_valor_captado_projeto, 
						ft_valor_captado_projeto = registro_posterior.ft_valor_captado_projeto, 
						nr_total_beneficiarios = registro_posterior.nr_total_beneficiarios, 
						ft_total_beneficiarios = registro_posterior.ft_total_beneficiarios, 
						cd_abrangencia_projeto = registro_posterior.cd_abrangencia_projeto, 
						ft_abrangencia_projeto = registro_posterior.ft_abrangencia_projeto, 
						cd_zona_atuacao_projeto = registro_posterior.cd_zona_atuacao_projeto, 
						ft_zona_atuacao_projeto = registro_posterior.ft_zona_atuacao_projeto, 
						tx_orgao_concedente = registro_posterior.tx_orgao_concedente, 
						ft_orgao_concedente = registro_posterior.ft_orgao_concedente, 
						tx_descricao_projeto = registro_posterior.tx_descricao_projeto, 
						ft_descricao_projeto = registro_posterior.ft_descricao_projeto, 
						tx_metodologia_monitoramento = registro_posterior.tx_metodologia_monitoramento, 
						ft_metodologia_monitoramento = registro_posterior.ft_metodologia_monitoramento, 
						tx_link_projeto = registro_posterior.tx_link_projeto, 
						ft_link_projeto = registro_posterior.ft_link_projeto 
					WHERE id_projeto = registro_posterior.id_projeto;
					
					INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
					VALUES (nome_tabela, osc, fonte::INTEGER, dataatualizacao, row_to_json(registro_anterior), row_to_json(registro_posterior));
				END IF;
			
			END IF;
			
		END LOOP;
		
		IF deletevalido THEN 
			DELETE FROM osc.tb_projeto WHERE id_projeto != ALL(registro_nao_delete);
		END IF;
		
		flag := true;
		mensagem := 'Projeto atualizado.';
	END IF;
	
	RETURN NEXT;

EXCEPTION 
	WHEN others THEN 
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, operacao, fonte, osc, dataatualizacao::TIMESTAMP, errolog) AS a;
		
		RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
