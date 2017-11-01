DO $$ 
BEGIN 
	ALTER TABLE osc.tb_representante_conselho 
	ADD CONSTRAINT fk_ft_nome_representante_conselho 
	FOREIGN KEY (ft_nome_representante_conselho) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
