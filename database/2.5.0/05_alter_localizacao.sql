DO $$ 
BEGIN 
	ALTER TABLE osc.tb_localizacao 
	ADD CONSTRAINT fk_ft_endereco 
	FOREIGN KEY (ft_endereco) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_localizacao 
	ADD CONSTRAINT fk_ft_localizacao 
	FOREIGN KEY (ft_localizacao) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_localizacao 
	ADD CONSTRAINT fk_ft_endereco_complemento 
	FOREIGN KEY (ft_endereco_complemento) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_localizacao 
	ADD CONSTRAINT fk_ft_bairro 
	FOREIGN KEY (ft_bairro) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_localizacao 
	ADD CONSTRAINT fk_ft_municipio 
	FOREIGN KEY (ft_municipio) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_localizacao 
	ADD CONSTRAINT fk_ft_geo_localizacao 
	FOREIGN KEY (ft_geo_localizacao) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_localizacao 
	ADD CONSTRAINT fk_ft_cep 
	FOREIGN KEY (ft_cep) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_localizacao 
	ADD CONSTRAINT fk_ft_endereco_corrigido 
	FOREIGN KEY (ft_endereco_corrigido) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_localizacao 
	ADD CONSTRAINT fk_ft_bairro_encontrado 
	FOREIGN KEY (ft_bairro_encontrado) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_localizacao 
	ADD CONSTRAINT fk_ft_fonte_geocodificacao 
	FOREIGN KEY (ft_fonte_geocodificacao) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_localizacao 
	ADD CONSTRAINT fk_ft_data_geocodificacao 
	FOREIGN KEY (ft_data_geocodificacao) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
