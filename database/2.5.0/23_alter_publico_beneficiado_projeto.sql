DO $$ 
BEGIN 
	ALTER TABLE osc.tb_publico_beneficiado_projeto 
	ADD CONSTRAINT fk_ft_publico_beneficiado_projeto 
	FOREIGN KEY (ft_publico_beneficiado_projeto) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);
	/*
	ALTER TABLE osc.tb_publico_beneficiado_projeto 
	ADD CONSTRAINT fk_ft_publico_beneficiado 
	FOREIGN KEY (ft_publico_beneficiado) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);
	*/
EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
