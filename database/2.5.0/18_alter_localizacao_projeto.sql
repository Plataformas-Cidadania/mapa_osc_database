DO $$ 
BEGIN 
	ALTER TABLE osc.tb_localizacao_projeto 
	ADD CONSTRAINT fk_ft_regiao_localizacao_projeto 
	FOREIGN KEY (ft_regiao_localizacao_projeto) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_localizacao_projeto 
	ADD CONSTRAINT fk_ft_nome_regiao_localizacao_projeto 
	FOREIGN KEY (ft_nome_regiao_localizacao_projeto) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_localizacao_projeto 
	ADD CONSTRAINT fk_ft_localizacao_prioritaria 
	FOREIGN KEY (ft_localizacao_prioritaria) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
