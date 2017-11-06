DO $$ 
BEGIN 
	ALTER TABLE osc.tb_recursos_osc 
	ADD CONSTRAINT fk_ft_fonte_recursos_osc 
	FOREIGN KEY (ft_fonte_recursos_osc) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_recursos_osc 
	ADD CONSTRAINT fk_ft_ano_recursos_osc 
	FOREIGN KEY (ft_ano_recursos_osc) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_recursos_osc 
	ADD CONSTRAINT fk_ft_valor_recursos_osc 
	FOREIGN KEY (ft_valor_recursos_osc) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
