DO $$ 
BEGIN 
	ALTER TABLE osc.tb_osc_parceira_projeto 
	ADD CONSTRAINT fk_ft_osc_parceira_projeto 
	FOREIGN KEY (ft_osc_parceira_projeto) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
