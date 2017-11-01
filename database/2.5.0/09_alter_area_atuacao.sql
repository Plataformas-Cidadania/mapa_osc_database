DO $$ 
BEGIN 
	ALTER TABLE osc.tb_area_atuacao 
	ADD CONSTRAINT fk_ft_area_atuacao 
	FOREIGN KEY (ft_area_atuacao) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
