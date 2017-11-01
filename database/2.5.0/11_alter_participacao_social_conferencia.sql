DO $$ 
BEGIN 
	ALTER TABLE osc.tb_participacao_social_conferencia 
	ADD CONSTRAINT fk_ft_conferencia 
	FOREIGN KEY (ft_conferencia) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_participacao_social_conferencia 
	ADD CONSTRAINT fk_ft_ano_realizacao 
	FOREIGN KEY (ft_ano_realizacao) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_participacao_social_conferencia 
	ADD CONSTRAINT fk_ft_forma_participacao_conferencia 
	FOREIGN KEY (ft_forma_participacao_conferencia) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
