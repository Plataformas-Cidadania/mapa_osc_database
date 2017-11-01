DO $$ 
BEGIN 
	ALTER TABLE osc.tb_financiador_projeto 
	ADD CONSTRAINT fk_ft_nome_financiador 
	FOREIGN KEY (ft_nome_financiador) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
