DO $$ 
BEGIN 
	ALTER TABLE osc.tb_certificado 
	ADD CONSTRAINT fk_ft_certificado 
	FOREIGN KEY (ft_certificado) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_certificado 
	ADD CONSTRAINT fk_ft_inicio_certificado 
	FOREIGN KEY (ft_inicio_certificado) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_certificado 
	ADD CONSTRAINT fk_ft_fim_certificado 
	FOREIGN KEY (ft_fim_certificado) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
