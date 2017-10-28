DROP FUNCTION IF EXISTS portal.atualizar_projeto(fonte TEXT, osc INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN, deletevalido BOOLEAN, tipobusca INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_projeto(fonte TEXT, osc INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN, deletevalido BOOLEAN, tipobusca INTEGER) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$

DECLARE 
	fonte_dados_nao_oficiais TEXT[];
	tipo_usuario TEXT;
	objeto RECORD;
	registro_anterior RECORD;
	registro_posterior RECORD;
	registro_nao_delete INTEGER[];
	flag_log BOOLEAN;
	
BEGIN 
	SELECT INTO tipo_usuario (
		SELECT dc_tipo_usuario.tx_nome_tipo_usuario 
		FROM portal.tb_usuario 
		INNER JOIN syst.dc_tipo_usuario 
		ON tb_usuario.cd_tipo_usuario = dc_tipo_usuario.cd_tipo_usuario 
		WHERE tb_usuario.id_usuario::TEXT = fonte 
		UNION 
		SELECT cd_sigla_fonte_dados 
		FROM syst.dc_fonte_dados 
		WHERE dc_fonte_dados.cd_sigla_fonte_dados::TEXT = fonte
	);
	
	IF tipo_usuario IS NOT null THEN 
		flag := false;
		mensagem := 'Fonte de dados inválida.';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT, dataatualizacao::TIMESTAMP);
		END IF;
		
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
		RAISE NOTICE 'TESTE';
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
						objeto.id_osc, 
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
						objeto.id_osc, 
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
				VALUES ('osc.tb_projeto', osc, fonte::INTEGER, dataatualizacao, null, row_to_json(registro_posterior));
				
			ELSE 
				registro_posterior := registro_anterior;
				registro_nao_delete := array_append(registro_nao_delete, registro_posterior.id_projeto);
				flag_log := false;
				
				IF (
					(nullvalido = true AND registro_anterior.tx_identificador_projeto_externo <> objeto.tx_identificador_projeto_externo) OR 
					(nullvalido = false AND registro_anterior.tx_identificador_projeto_externo <> objeto.tx_identificador_projeto_externo AND objeto.tx_identificador_projeto_externo IS NOT null)
				) AND (
					registro_anterior.ft_identificador_projeto_externo IS null OR registro_anterior.ft_identificador_projeto_externo = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.tx_identificador_projeto_externo := objeto.tx_identificador_projeto_externo;
					registro_posterior.ft_identificador_projeto_externo := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.cd_municipio <> objeto.cd_municipio) OR 
					(nullvalido = false AND registro_anterior.cd_municipio <> objeto.cd_municipio AND objeto.cd_municipio IS NOT null)
				) AND (
					registro_anterior.ft_municipio IS null OR registro_anterior.ft_municipio = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.cd_municipio := objeto.cd_municipio;
					registro_posterior.ft_municipio := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.cd_uf <> objeto.cd_uf) OR 
					(nullvalido = false AND registro_anterior.cd_uf <> objeto.cd_uf AND objeto.cd_uf IS NOT null)
				) AND (
					registro_anterior.ft_uf IS null OR registro_anterior.ft_uf = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.cd_uf := objeto.cd_uf;
					registro_posterior.ft_uf := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.tx_nome_projeto <> objeto.tx_nome_projeto) OR 
					(nullvalido = false AND registro_anterior.tx_nome_projeto <> objeto.tx_nome_projeto AND objeto.tx_nome_projeto IS NOT null)
				) AND (
					registro_anterior.ft_nome_projeto IS null OR registro_anterior.ft_nome_projeto = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.tx_nome_projeto := objeto.tx_nome_projeto;
					registro_posterior.ft_nome_projeto := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.cd_status_projeto <> objeto.cd_status_projeto) OR 
					(nullvalido = false AND registro_anterior.cd_status_projeto <> objeto.cd_status_projeto AND objeto.cd_status_projeto IS NOT null)
				) AND (
					registro_anterior.ft_status_projeto IS null OR registro_anterior.ft_status_projeto = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.cd_status_projeto := objeto.cd_status_projeto;
					registro_posterior.ft_status_projeto := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.dt_data_inicio_projeto <> objeto.dt_data_inicio_projeto) OR 
					(nullvalido = false AND registro_anterior.dt_data_inicio_projeto <> objeto.dt_data_inicio_projeto AND objeto.dt_data_inicio_projeto IS NOT null)
				) AND (
					registro_anterior.ft_data_inicio_projeto IS null OR registro_anterior.ft_data_inicio_projeto = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.dt_data_inicio_projeto := objeto.dt_data_inicio_projeto;
					registro_posterior.ft_data_inicio_projeto := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.dt_data_fim_projeto <> objeto.dt_data_fim_projeto) OR 
					(nullvalido = false AND registro_anterior.dt_data_fim_projeto <> objeto.dt_data_fim_projeto AND objeto.dt_data_fim_projeto IS NOT null)
				) AND (
					registro_anterior.ft_data_fim_projeto IS null OR registro_anterior.ft_data_fim_projeto = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.dt_data_fim_projeto := objeto.dt_data_fim_projeto;
					registro_posterior.ft_data_fim_projeto := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.nr_valor_total_projeto <> objeto.nr_valor_total_projeto) OR 
					(nullvalido = false AND registro_anterior.nr_valor_total_projeto <> objeto.nr_valor_total_projeto AND objeto.nr_valor_total_projeto IS NOT null)
				) AND (
					registro_anterior.ft_valor_total_projeto IS null OR registro_anterior.ft_valor_total_projeto = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.nr_valor_total_projeto := objeto.nr_valor_total_projeto;
					registro_posterior.ft_valor_total_projeto := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.nr_valor_captado_projeto <> objeto.nr_valor_captado_projeto) OR 
					(nullvalido = false AND registro_anterior.nr_valor_captado_projeto <> objeto.nr_valor_captado_projeto AND objeto.nr_valor_captado_projeto IS NOT null)
				) AND (
					registro_anterior.ft_valor_captado_projeto IS null OR registro_anterior.ft_valor_captado_projeto = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.nr_valor_captado_projeto := objeto.nr_valor_captado_projeto;
					registro_posterior.ft_valor_captado_projeto := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.nr_total_beneficiarios <> objeto.nr_total_beneficiarios) OR 
					(nullvalido = false AND registro_anterior.nr_total_beneficiarios <> objeto.nr_total_beneficiarios AND objeto.nr_total_beneficiarios IS NOT null)
				) AND (
					registro_anterior.ft_total_beneficiarios IS null OR registro_anterior.ft_total_beneficiarios = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.nr_total_beneficiarios := objeto.nr_total_beneficiarios;
					registro_posterior.ft_total_beneficiarios := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.cd_abrangencia_projeto <> objeto.cd_abrangencia_projeto) OR 
					(nullvalido = false AND registro_anterior.cd_abrangencia_projeto <> objeto.cd_abrangencia_projeto AND objeto.cd_abrangencia_projeto IS NOT null)
				) AND (
					registro_anterior.ft_abrangencia_projeto IS null OR registro_anterior.ft_abrangencia_projeto = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.cd_abrangencia_projeto := objeto.cd_abrangencia_projeto;
					registro_posterior.ft_abrangencia_projeto := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.cd_zona_atuacao_projeto <> objeto.cd_zona_atuacao_projeto) OR 
					(nullvalido = false AND registro_anterior.cd_zona_atuacao_projeto <> objeto.cd_zona_atuacao_projeto AND objeto.cd_zona_atuacao_projeto IS NOT null)
				) AND (
					registro_anterior.ft_zona_atuacao_projeto IS null OR registro_anterior.ft_zona_atuacao_projeto = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.cd_zona_atuacao_projeto := objeto.cd_zona_atuacao_projeto;
					registro_posterior.ft_zona_atuacao_projeto := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.tx_orgao_concedente <> objeto.tx_orgao_concedente) OR 
					(nullvalido = false AND registro_anterior.tx_orgao_concedente <> objeto.tx_orgao_concedente AND objeto.tx_orgao_concedente IS NOT null)
				) AND (
					registro_anterior.ft_orgao_concedente IS null OR registro_anterior.ft_orgao_concedente = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.tx_orgao_concedente := objeto.tx_orgao_concedente;
					registro_posterior.ft_orgao_concedente := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.tx_descricao_projeto <> objeto.tx_descricao_projeto) OR 
					(nullvalido = false AND registro_anterior.tx_descricao_projeto <> objeto.tx_descricao_projeto AND objeto.tx_descricao_projeto IS NOT null)
				) AND (
					registro_anterior.ft_descricao_projeto IS null OR registro_anterior.ft_descricao_projeto = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.tx_descricao_projeto := objeto.tx_descricao_projeto;
					registro_posterior.ft_descricao_projeto := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.tx_metodologia_monitoramento <> objeto.tx_metodologia_monitoramento) OR 
					(nullvalido = false AND registro_anterior.tx_metodologia_monitoramento <> objeto.tx_metodologia_monitoramento AND objeto.tx_metodologia_monitoramento IS NOT null)
				) AND (
					registro_anterior.ft_metodologia_monitoramento IS null OR registro_anterior.ft_metodologia_monitoramento = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.tx_metodologia_monitoramento := objeto.tx_metodologia_monitoramento;
					registro_posterior.ft_metodologia_monitoramento := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.tx_link_projeto <> objeto.tx_link_projeto) OR 
					(nullvalido = false AND registro_anterior.tx_link_projeto <> objeto.tx_link_projeto AND objeto.tx_link_projeto IS NOT null)
				) AND (
					registro_anterior.ft_link_projeto IS null OR registro_anterior.ft_link_projeto = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.tx_link_projeto := objeto.tx_link_projeto;
					registro_posterior.ft_link_projeto := tipo_usuario;
					flag_log := true;
				END IF;
				
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
				
				IF flag_log THEN 		
					INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
					VALUES ('osc.tb_projeto', osc, fonte::INTEGER, dataatualizacao, row_to_json(registro_anterior), row_to_json(registro_posterior));
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
	WHEN not_null_violation THEN 
		flag := false;
		mensagem := 'Dado(s) obrigatório(s) não enviado(s).';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT, dataatualizacao::TIMESTAMP);
		END IF;
		
		RETURN NEXT;
		
	WHEN unique_violation THEN 
		flag := false;
		mensagem := 'Dado(s) único(s) violado(s).';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT, dataatualizacao::TIMESTAMP);
		END IF;
		
		RETURN NEXT;
		
	WHEN foreign_key_violation THEN 
		flag := false;
		mensagem := 'Dado(s) com chave(s) estrangeira(s) violada(s).';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT, dataatualizacao::TIMESTAMP);
		END IF;
		
		RETURN NEXT;
		
	WHEN others THEN 
		flag := false;
		mensagem := 'Ocorreu um erro. ' || json;
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT, dataatualizacao::TIMESTAMP);
		END IF;
		
		RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';


/*
SELECT * FROM portal.atualizar_projeto(
	'2'::TEXT, 
	'1221345'::INTEGER, 
	'2017/10/28 04:23:09.647'::TIMESTAMP, 
	'[{"cd_uf": "35", "id_osc": "1221345", "cd_municipio": "", "tx_link_projeto": null, "tx_nome_projeto": "Parceria 000007", "cd_status_projeto": "3", "dt_data_fim_projeto": "31-12-2011", "tx_orgao_concedente": "", "tx_descricao_projeto": "", "cd_abrangencia_projeto": null, "dt_data_inicio_projeto": "01-01-2010", "nr_total_beneficiarios": null, "nr_valor_total_projeto": "100000.0", "cd_zona_atuacao_projeto": null, "tx_status_projeto_outro": null, "nr_valor_captado_projeto": "100000.0", "tx_metodologia_monitoramento": null, "tx_identificador_projeto_externo": "000007"}]'::JSONB, 
	false::BOOLEAN, 
	true::BOOLEAN, 
	false::BOOLEAN, 
	2
);
*/