DO $$ 
BEGIN 
	ALTER TABLE osc.tb_conselho_fiscal 
	ADD CONSTRAINT fk_ft_nome_conselheiro 
	FOREIGN KEY (ft_nome_conselheiro) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
