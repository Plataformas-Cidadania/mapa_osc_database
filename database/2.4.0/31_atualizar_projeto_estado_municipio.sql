DROP FUNCTION IF EXISTS portal.atualizar_projeto_estado_municipio(osc INTEGER, identificadorexterno TEXT, localidade INTEGER, nome TEXT, status INTEGER, datainicio DATE, datafim DATE, valortotal DOUBLE PRECISION, valorcaptado DOUBLE PRECISION, totalbeneficiarios INTEGER, abrangencia INTEGER, zonaatuacao INTEGER, orgaoconcedente TEXT, descricao TEXT, metodologiamonitoramento TEXT, link TEXT, fonte TEXT, dataatualizacao TIMESTAMP, nullvalido BOOLEAN, deletevalido BOOLEAN, errovalido BOOLEAN);

CREATE OR REPLACE FUNCTION portal.atualizar_projeto_estado_municipio(osc INTEGER, identificadorexterno TEXT, localidade INTEGER, nome TEXT, status INTEGER, datainicio DATE, datafim DATE, valortotal DOUBLE PRECISION, valorcaptado DOUBLE PRECISION, totalbeneficiarios INTEGER, abrangencia INTEGER, zonaatuacao INTEGER, orgaoconcedente TEXT, descricao TEXT, metodologiamonitoramento TEXT, link TEXT, fonte TEXT, dataatualizacao TIMESTAMP, nullvalido BOOLEAN, deletevalido BOOLEAN, errovalido BOOLEAN) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$

DECLARE 
	registro_anterior RECORD;
	registro_posterior RECORD;
	registro_nao_delete INTEGER[];
	flag_log BOOLEAN;
	
BEGIN 
	registro_nao_delete := '{}';
	
	SELECT INTO registro_anterior * 
	FROM osc.tb_projeto 
	WHERE (tx_identificador_projeto_externo = identificadorexterno AND cd_uf = localidade AND cd_municipio is null) 
	OR (tx_identificador_projeto_externo = identificadorexterno AND cd_uf is null AND cd_municipio = localidade);
	
	IF registro_anterior.id_projeto IS null THEN 
		IF localidade > 99 THEN 
			INSERT INTO 
				osc.tb_projeto (
					id_osc, 
					tx_identificador_projeto_externo, 
					cd_uf, 
					cd_municipio, 
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
				) 
			VALUES (
				osc, 
				identificadorexterno, 
				null, 
				localidade, 
				nome, 
				fonte, 
				status, 
				fonte, 
				datainicio, 
				fonte, 
				datafim, 
				fonte, 
				valortotal, 
				fonte, 
				valorcaptado, 
				fonte, 
				totalbeneficiarios, 
				fonte, 
				abrangencia, 
				fonte, 
				zonaatuacao, 
				fonte, 
				orgaoconcedente, 
				fonte, 
				descricao, 
				fonte, 
				metodologiamonitoramento, 
				fonte, 
				link, 
				fonte
			) RETURNING * INTO registro_posterior;
			
		ELSE 
			INSERT INTO 
				osc.tb_projeto (
					id_osc, 
					tx_identificador_projeto_externo, 
					cd_uf, 
					cd_municipio, 
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
				) 
			VALUES (
				osc, 
				identificadorexterno, 
				localidade, 
				null, 
				nome, 
				fonte, 
				status, 
				fonte, 
				datainicio, 
				fonte, 
				datafim, 
				fonte, 
				valortotal, 
				fonte, 
				valorcaptado, 
				fonte, 
				totalbeneficiarios, 
				fonte, 
				abrangencia, 
				fonte, 
				zonaatuacao, 
				fonte, 
				orgaoconcedente, 
				fonte, 
				descricao, 
				fonte, 
				metodologiamonitoramento, 
				fonte, 
				link, 
				fonte
			) RETURNING * INTO registro_posterior;

		END IF;
		
		registro_nao_delete := array_append(registro_nao_delete, registro_posterior.id_fonte_recursos_projeto);
		
		INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
		VALUES ('osc.tb_projeto', osc, fonte::INTEGER, dataatualizacao, null, row_to_json(registro_posterior));
		
	ELSE 
		registro_posterior := registro_anterior;
		registro_nao_delete := array_append(registro_nao_delete, registro_posterior.id_fonte_recursos_projeto);
		flag_log := false;
		
		IF (nullvalido = true AND registro_anterior.tx_nome_projeto <> nome) OR (nullvalido = false AND registro_anterior.tx_nome_projeto <> nome AND nome IS NOT null) THEN 
			registro_posterior.tx_nome_projeto := nome;
			registro_posterior.ft_nome_projeto := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.cd_status_projeto <> status) OR (nullvalido = false AND registro_anterior.cd_status_projeto <> status AND status IS NOT null) THEN 
			registro_posterior.cd_status_projeto := status;
			registro_posterior.ft_status_projeto := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.dt_data_inicio_projeto <> datainicio) OR (nullvalido = false AND registro_anterior.dt_data_inicio_projeto <> datainicio AND datainicio IS NOT null) THEN 
			registro_posterior.dt_data_inicio_projeto := datainicio;
			registro_posterior.ft_data_inicio_projeto := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.dt_data_fim_projeto <> datafim) OR (nullvalido = false AND registro_anterior.dt_data_fim_projeto <> datafim AND datafim IS NOT null) THEN 
			registro_posterior.dt_data_fim_projeto := datafim;
			registro_posterior.ft_data_fim_projeto := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.tx_link_projeto <> link) OR (nullvalido = false AND registro_anterior.tx_link_projeto <> link AND link IS NOT null) THEN 
			registro_posterior.tx_link_projeto := link;
			registro_posterior.ft_link_projeto := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.nr_total_beneficiarios <> totalbeneficiarios) OR (nullvalido = false AND registro_anterior.nr_total_beneficiarios <> totalbeneficiarios AND totalbeneficiarios IS NOT null) THEN 
			registro_posterior.nr_total_beneficiarios := totalbeneficiarios;
			registro_posterior.ft_total_beneficiarios := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.nr_valor_captado_projeto <> valorcaptado) OR (nullvalido = false AND registro_anterior.nr_valor_captado_projeto <> valorcaptado AND valorcaptado IS NOT null) THEN 
			registro_posterior.nr_valor_captado_projeto := valorcaptado;
			registro_posterior.ft_valor_captado_projeto := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.nr_valor_total_projeto <> valortotal) OR (nullvalido = false AND registro_anterior.nr_valor_total_projeto <> valortotal AND valortotal IS NOT null) THEN 
			registro_posterior.nr_valor_total_projeto := valortotal;
			registro_posterior.ft_valor_total_projeto := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.cd_abrangencia_projeto <> abrangencia) OR (nullvalido = false AND registro_anterior.cd_abrangencia_projeto <> abrangencia AND abrangencia IS NOT null) THEN 
			registro_posterior.cd_abrangencia_projeto := abrangencia;
			registro_posterior.ft_abrangencia_projeto := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.cd_zona_atuacao_projeto <> zonaatuacao) OR (nullvalido = false AND registro_anterior.cd_zona_atuacao_projeto <> zonaatuacao AND zonaatuacao IS NOT null) THEN 
			registro_posterior.cd_zona_atuacao_projeto := zonaatuacao;
			registro_posterior.ft_zona_atuacao_projeto := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.tx_descricao_projeto <> descricao) OR (nullvalido = false AND registro_anterior.tx_descricao_projeto <> descricao AND descricao IS NOT null) THEN 
			registro_posterior.tx_descricao_projeto := descricao;
			registro_posterior.ft_descricao_projeto := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.tx_metodologia_monitoramento <> metodologiamonitoramento) OR (nullvalido = false AND registro_anterior.tx_metodologia_monitoramento <> metodologiamonitoramento AND metodologiamonitoramento IS NOT null) THEN 
			registro_posterior.tx_metodologia_monitoramento := metodologiamonitoramento;
			registro_posterior.ft_metodologia_monitoramento := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.tx_orgao_concedente <> orgaoconcedente) OR (nullvalido = false AND registro_anterior.tx_orgao_concedente <> orgaoconcedente AND orgaoconcedente IS NOT null) THEN 
			registro_posterior.tx_orgao_concedente := orgaoconcedente;
			registro_posterior.ft_orgao_concedente := fonte;
			flag_log := true;
		END IF;
		
		UPDATE 
			osc.tb_projeto 
		SET 
			id_osc = registro_posterior.id_osc, 
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
		WHERE 
			id_projeto = registro_posterior.id_projeto; 
		
		IF flag_log THEN 		
			INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
			VALUES ('osc.tb_projeto', osc, fonte::INTEGER, dataatualizacao, row_to_json(registro_anterior), row_to_json(registro_posterior));
		END IF;
	
	END IF;
	
	IF deletevalido THEN 
		DELETE FROM osc.tb_fonte_recursos_projeto WHERE id_fonte_recursos_projeto != ALL(registro_nao_delete);
	END IF;
	
	flag := true;
	mensagem := 'Projeto atualizado.';
	RETURN NEXT;
	
EXCEPTION 
	WHEN not_null_violation THEN 
		IF errovalido THEN 
			RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;
		END IF;
		
		flag := false;
		mensagem := 'Dado(s) obrigatório(s) não enviado(s).';
		RETURN NEXT;
		
	WHEN unique_violation THEN 
		IF errovalido THEN 
			RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;
		END IF;
		
		flag := false;
		mensagem := 'Dado(s) único(s) violado(s).';
		RETURN NEXT;
		
	WHEN foreign_key_violation THEN 
		IF errovalido THEN 
			RAISE EXCEPTION '(%) %', SQLSTATE, SQLERRM;
		END IF;
		
		flag := false;
		mensagem := 'Dado(s) com chave(s) estrangeira(s) violada(s).';
		RETURN NEXT;
		
	WHEN others THEN 
		IF errovalido THEN 
			RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;
		END IF;
		
		flag := false;
		mensagem := 'Ocorreu um erro.';
		RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
