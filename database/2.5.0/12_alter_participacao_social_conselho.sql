DO $$ 
BEGIN 
	ALTER TABLE osc.tb_participacao_social_conselho 
	ADD CONSTRAINT fk_ft_conselho 
	FOREIGN KEY (ft_conselho) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_participacao_social_conselho 
	ADD CONSTRAINT fk_ft_tipo_participacao 
	FOREIGN KEY (ft_tipo_participacao) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_participacao_social_conselho 
	ADD CONSTRAINT fk_ft_periodicidade_reuniao 
	FOREIGN KEY (ft_periodicidade_reuniao) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_participacao_social_conselho 
	ADD CONSTRAINT fk_ft_data_inicio_conselho 
	FOREIGN KEY (ft_data_inicio_conselho) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_participacao_social_conselho 
	ADD CONSTRAINT fk_ft_data_fim_conselho 
	FOREIGN KEY (ft_data_fim_conselho) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
