DO $$ 
BEGIN 
	ALTER TABLE osc.tb_area_atuacao_projeto 
	ADD CONSTRAINT fk_ft_area_atuacao_projeto 
	FOREIGN KEY (ft_area_atuacao_projeto) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
