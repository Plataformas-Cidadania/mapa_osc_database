DO $$ 
BEGIN 
	ALTER TABLE osc.tb_participacao_social_outra 
	ADD CONSTRAINT fk_ft_participacao_social_outra 
	FOREIGN KEY (ft_participacao_social_outra) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
