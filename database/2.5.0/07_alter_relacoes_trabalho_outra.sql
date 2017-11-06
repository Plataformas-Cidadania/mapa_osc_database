DO $$ 
BEGIN 
	ALTER TABLE osc.tb_relacoes_trabalho_outra 
	ADD CONSTRAINT fk_ft_trabalhadores 
	FOREIGN KEY (ft_trabalhadores) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_relacoes_trabalho_outra 
	ADD CONSTRAINT fk_ft_tipo_relacao_trabalho 
	FOREIGN KEY (ft_tipo_relacao_trabalho) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
