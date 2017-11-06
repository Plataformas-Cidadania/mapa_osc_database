DO $$ 
BEGIN 
	ALTER TABLE osc.tb_contato 
	ADD CONSTRAINT fk_ft_telefone 
	FOREIGN KEY (ft_telefone) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_contato 
	ADD CONSTRAINT fk_ft_email 
	FOREIGN KEY (ft_email) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_contato 
	ADD CONSTRAINT fk_ft_representante 
	FOREIGN KEY (ft_representante) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_contato 
	ADD CONSTRAINT fk_ft_site 
	FOREIGN KEY (ft_site) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_contato 
	ADD CONSTRAINT fk_ft_facebook 
	FOREIGN KEY (ft_facebook) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_contato 
	ADD CONSTRAINT fk_ft_google 
	FOREIGN KEY (ft_google) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_contato 
	ADD CONSTRAINT fk_ft_linkedin 
	FOREIGN KEY (ft_linkedin) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_contato 
	ADD CONSTRAINT fk_ft_twitter 
	FOREIGN KEY (ft_twitter) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
