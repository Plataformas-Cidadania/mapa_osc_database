DO $$ 
BEGIN 
	ALTER TABLE osc.tb_projeto 
	ADD CONSTRAINT fk_ft_nome_projeto 
	FOREIGN KEY (ft_nome_projeto) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_projeto 
	ADD CONSTRAINT fk_ft_status_projeto 
	FOREIGN KEY (ft_status_projeto) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_projeto 
	ADD CONSTRAINT fk_ft_data_inicio_projeto 
	FOREIGN KEY (ft_data_inicio_projeto) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_projeto 
	ADD CONSTRAINT fk_ft_data_fim_projeto 
	FOREIGN KEY (ft_data_fim_projeto) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_projeto 
	ADD CONSTRAINT fk_ft_link_projeto 
	FOREIGN KEY (ft_link_projeto) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_projeto 
	ADD CONSTRAINT fk_ft_total_beneficiarios 
	FOREIGN KEY (ft_total_beneficiarios) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_projeto 
	ADD CONSTRAINT fk_ft_valor_captado_projeto 
	FOREIGN KEY (ft_valor_captado_projeto) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_projeto 
	ADD CONSTRAINT fk_ft_valor_total_projeto 
	FOREIGN KEY (ft_valor_total_projeto) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_projeto 
	ADD CONSTRAINT fk_ft_abrangencia_projeto 
	FOREIGN KEY (ft_abrangencia_projeto) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_projeto 
	ADD CONSTRAINT fk_ft_zona_atuacao_projeto 
	FOREIGN KEY (ft_zona_atuacao_projeto) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_projeto 
	ADD CONSTRAINT fk_ft_descricao_projeto 
	FOREIGN KEY (ft_descricao_projeto) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_projeto 
	ADD CONSTRAINT fk_ft_metodologia_monitoramento 
	FOREIGN KEY (ft_metodologia_monitoramento) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_projeto 
	ADD CONSTRAINT fk_ft_identificador_projeto_externo 
	FOREIGN KEY (ft_identificador_projeto_externo) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_projeto 
	ADD CONSTRAINT fk_ft_municipio 
	FOREIGN KEY (ft_municipio) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_projeto 
	ADD CONSTRAINT fk_ft_uf 
	FOREIGN KEY (ft_uf) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';