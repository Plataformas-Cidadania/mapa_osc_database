DROP FUNCTION IF EXISTS portal.atualizar_projeto_estado_municipio(osc INTEGER, identificadorexterno TEXT, localidade INTEGER, nome TEXT, status INTEGER, datainicio DATE, datafim DATE, valortotal DOUBLE PRECISION, valorcaptado DOUBLE PRECISION, totalbeneficiarios INTEGER, abrangencia INTEGER, zonaatuacao INTEGER, orgaoconcedente TEXT, descricao TEXT, metodologiamonitoramento TEXT, link TEXT, fonte TEXT, dataatualizacao TIMESTAMP, nullvalido BOOLEAN);

CREATE OR REPLACE FUNCTION portal.atualizar_projeto_estado_municipio(osc INTEGER, identificadorexterno TEXT, localidade INTEGER, nome TEXT, status INTEGER, datainicio DATE, datafim DATE, valortotal DOUBLE PRECISION, valorcaptado DOUBLE PRECISION, totalbeneficiarios INTEGER, abrangencia INTEGER, zonaatuacao INTEGER, orgaoconcedente TEXT, descricao TEXT, metodologiamonitoramento TEXT, link TEXT, fonte TEXT, dataatualizacao TIMESTAMP, nullvalido BOOLEAN) RETURNS TABLE(
	mensagem TEXT
)AS $$

DECLARE 
	projeto_anterior RECORD;
	projeto_posterior RECORD;
	gravar_log BOOLEAN;
	
BEGIN 
	SELECT INTO projeto_anterior * 
	FROM osc.tb_projeto 
	WHERE (tx_identificador_projeto_externo = identificadorexterno AND cd_uf = localidade AND cd_municipio is null) 
	OR (tx_identificador_projeto_externo = identificadorexterno AND cd_uf is null AND cd_municipio = localidade);
	
	IF projeto_anterior.id_projeto IS null THEN 
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
			) RETURNING * INTO projeto_posterior;
			
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
			) RETURNING * INTO projeto_posterior;

		END IF;
		
		INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
		VALUES ('osc.tb_projeto', osc, fonte::INTEGER, dataatualizacao, null, row_to_json(projeto_posterior));
		
	ELSE 
		projeto_posterior := projeto_anterior;
		
		gravar_log := false;
		projeto_posterior.id_osc = osc;
		
		IF (nullvalido = true AND projeto_anterior.tx_nome_projeto <> nome) OR (nullvalido = false AND projeto_anterior.tx_nome_projeto <> nome AND nome IS NOT null) THEN 
			projeto_posterior.tx_nome_projeto := nome;
			projeto_posterior.ft_nome_projeto := fonte;
			gravar_log := true;
		END IF;
		
		IF (nullvalido = true AND projeto_anterior.cd_status_projeto <> status) OR (nullvalido = false AND projeto_anterior.cd_status_projeto <> status AND status IS NOT null) THEN 
			projeto_posterior.cd_status_projeto := status;
			projeto_posterior.ft_status_projeto := fonte;
			gravar_log := true;
		END IF;
		
		IF (nullvalido = true AND projeto_anterior.dt_data_inicio_projeto <> datainicio) OR (nullvalido = false AND projeto_anterior.dt_data_inicio_projeto <> datainicio AND datainicio IS NOT null) THEN 
			projeto_posterior.dt_data_inicio_projeto := datainicio;
			projeto_posterior.ft_data_inicio_projeto := fonte;
			gravar_log := true;
		END IF;
		
		IF (nullvalido = true AND projeto_anterior.dt_data_fim_projeto <> datafim) OR (nullvalido = false AND projeto_anterior.dt_data_fim_projeto <> datafim AND datafim IS NOT null) THEN 
			projeto_posterior.dt_data_fim_projeto := datafim;
			projeto_posterior.ft_data_fim_projeto := fonte;
			gravar_log := true;
		END IF;
		
		IF (nullvalido = true AND projeto_anterior.tx_link_projeto <> link) OR (nullvalido = false AND projeto_anterior.tx_link_projeto <> link AND link IS NOT null) THEN 
			projeto_posterior.tx_link_projeto := link;
			projeto_posterior.ft_link_projeto := fonte;
			gravar_log := true;
		END IF;
		
		IF (nullvalido = true AND projeto_anterior.nr_total_beneficiarios <> totalbeneficiarios) OR (nullvalido = false AND projeto_anterior.nr_total_beneficiarios <> totalbeneficiarios AND totalbeneficiarios IS NOT null) THEN 
			projeto_posterior.nr_total_beneficiarios := totalbeneficiarios;
			projeto_posterior.ft_total_beneficiarios := fonte;
			gravar_log := true;
		END IF;
		
		IF (nullvalido = true AND projeto_anterior.nr_valor_captado_projeto <> valorcaptado) OR (nullvalido = false AND projeto_anterior.nr_valor_captado_projeto <> valorcaptado AND valorcaptado IS NOT null) THEN 
			projeto_posterior.nr_valor_captado_projeto := valorcaptado;
			projeto_posterior.ft_valor_captado_projeto := fonte;
			gravar_log := true;
		END IF;
		
		IF (nullvalido = true AND projeto_anterior.nr_valor_total_projeto <> valortotal) OR (nullvalido = false AND projeto_anterior.nr_valor_total_projeto <> valortotal AND valortotal IS NOT null) THEN 
			projeto_posterior.nr_valor_total_projeto := valortotal;
			projeto_posterior.ft_valor_total_projeto := fonte;
			gravar_log := true;
		END IF;
		
		IF (nullvalido = true AND projeto_anterior.cd_abrangencia_projeto <> abrangencia) OR (nullvalido = false AND projeto_anterior.cd_abrangencia_projeto <> abrangencia AND abrangencia IS NOT null) THEN 
			projeto_posterior.cd_abrangencia_projeto := abrangencia;
			projeto_posterior.ft_abrangencia_projeto := fonte;
			gravar_log := true;
		END IF;
		
		IF (nullvalido = true AND projeto_anterior.cd_zona_atuacao_projeto <> zonaatuacao) OR (nullvalido = false AND projeto_anterior.cd_zona_atuacao_projeto <> zonaatuacao AND zonaatuacao IS NOT null) THEN 
			projeto_posterior.cd_zona_atuacao_projeto := zonaatuacao;
			projeto_posterior.ft_zona_atuacao_projeto := fonte;
			gravar_log := true;
		END IF;
		
		IF (nullvalido = true AND projeto_anterior.tx_descricao_projeto <> descricao) OR (nullvalido = false AND projeto_anterior.tx_descricao_projeto <> descricao AND descricao IS NOT null) THEN 
			projeto_posterior.tx_descricao_projeto := descricao;
			projeto_posterior.ft_descricao_projeto := fonte;
			gravar_log := true;
		END IF;
		
		IF (nullvalido = true AND projeto_anterior.tx_metodologia_monitoramento <> metodologiamonitoramento) OR (nullvalido = false AND projeto_anterior.tx_metodologia_monitoramento <> metodologiamonitoramento AND metodologiamonitoramento IS NOT null) THEN 
			projeto_posterior.tx_metodologia_monitoramento := metodologiamonitoramento;
			projeto_posterior.ft_metodologia_monitoramento := fonte;
			gravar_log := true;
		END IF;
		
		IF (nullvalido = true AND projeto_anterior.tx_orgao_concedente <> orgaoconcedente) OR (nullvalido = false AND projeto_anterior.tx_orgao_concedente <> orgaoconcedente AND orgaoconcedente IS NOT null) THEN 
			projeto_posterior.tx_orgao_concedente := orgaoconcedente;
			projeto_posterior.ft_orgao_concedente := fonte;
			gravar_log := true;
		END IF;
		
		UPDATE 
			osc.tb_projeto 
		SET 
			id_osc = projeto_posterior.id_osc, 
			tx_nome_projeto = projeto_posterior.tx_nome_projeto, 
			ft_nome_projeto = projeto_posterior.ft_nome_projeto, 
			cd_status_projeto = projeto_posterior.cd_status_projeto, 
			ft_status_projeto = projeto_posterior.ft_status_projeto, 
			dt_data_inicio_projeto = projeto_posterior.dt_data_inicio_projeto, 
			ft_data_inicio_projeto = projeto_posterior.ft_data_inicio_projeto, 
			dt_data_fim_projeto = projeto_posterior.dt_data_fim_projeto, 
			ft_data_fim_projeto = projeto_posterior.ft_data_fim_projeto, 
			nr_valor_total_projeto = projeto_posterior.nr_valor_total_projeto, 
			ft_valor_total_projeto = projeto_posterior.ft_valor_total_projeto, 
			nr_valor_captado_projeto = projeto_posterior.nr_valor_captado_projeto, 
			ft_valor_captado_projeto = projeto_posterior.ft_valor_captado_projeto, 
			nr_total_beneficiarios = projeto_posterior.nr_total_beneficiarios, 
			ft_total_beneficiarios = projeto_posterior.ft_total_beneficiarios, 
			cd_abrangencia_projeto = projeto_posterior.cd_abrangencia_projeto, 
			ft_abrangencia_projeto = projeto_posterior.ft_abrangencia_projeto, 
			cd_zona_atuacao_projeto = projeto_posterior.cd_zona_atuacao_projeto, 
			ft_zona_atuacao_projeto = projeto_posterior.ft_zona_atuacao_projeto, 
			tx_orgao_concedente = projeto_posterior.tx_orgao_concedente, 
			ft_orgao_concedente = projeto_posterior.ft_orgao_concedente, 
			tx_descricao_projeto = projeto_posterior.tx_descricao_projeto, 
			ft_descricao_projeto = projeto_posterior.ft_descricao_projeto, 
			tx_metodologia_monitoramento = projeto_posterior.tx_metodologia_monitoramento, 
			ft_metodologia_monitoramento = projeto_posterior.ft_metodologia_monitoramento, 
			tx_link_projeto = projeto_posterior.tx_link_projeto, 
			ft_link_projeto = projeto_posterior.ft_link_projeto 
		WHERE 
			id_projeto = projeto_posterior.id_projeto; 
		
		IF gravar_log THEN 		
			INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
			VALUES ('osc.tb_projeto', osc, fonte::INTEGER, dataatualizacao, row_to_json(projeto_anterior), row_to_json(projeto_posterior));
		END IF;
	
	END IF;
	
	mensagem := 'Projeto atualizado';
	RETURN NEXT;
END; 
$$ LANGUAGE 'plpgsql';
