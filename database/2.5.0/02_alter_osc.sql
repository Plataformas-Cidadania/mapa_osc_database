DO $$ 
BEGIN 
	ALTER TABLE osc.tb_osc 
	ADD CONSTRAINT fk_ft_apelido_osc 
	FOREIGN KEY (ft_apelido_osc) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_osc 
	ADD CONSTRAINT fk_ft_identificador_osc 
	FOREIGN KEY (ft_identificador_osc) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_osc 
	ADD CONSTRAINT fk_ft_osc_ativa 
	FOREIGN KEY (ft_osc_ativa) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);
	
EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
