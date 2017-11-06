DO $$ 
BEGIN 
	ALTER TABLE osc.tb_fonte_recursos_projeto 
	ADD CONSTRAINT fk_ft_fonte_recursos_projeto 
	FOREIGN KEY (ft_fonte_recursos_projeto) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_fonte_recursos_projeto 
	ADD CONSTRAINT fk_ft_tipo_parceria 
	FOREIGN KEY (ft_tipo_parceria) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_fonte_recursos_projeto 
	ADD CONSTRAINT fk_ft_orgao_concedente 
	FOREIGN KEY (ft_orgao_concedente) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
