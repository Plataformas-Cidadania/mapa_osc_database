DO $$ 
BEGIN 
	ALTER TABLE osc.tb_relacoes_trabalho 
	ADD CONSTRAINT fk_ft_trabalhadores_vinculo 
	FOREIGN KEY (ft_trabalhadores_vinculo) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_relacoes_trabalho 
	ADD CONSTRAINT fk_ft_trabalhadores_deficiencia 
	FOREIGN KEY (ft_trabalhadores_deficiencia) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_relacoes_trabalho 
	ADD CONSTRAINT fk_ft_trabalhadores_voluntarios 
	FOREIGN KEY (ft_trabalhadores_voluntarios) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
