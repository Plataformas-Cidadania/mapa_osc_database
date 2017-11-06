DO $$ 
BEGIN 
	ALTER TABLE osc.tb_dados_gerais 
	ADD CONSTRAINT fk_ft_natureza_juridica_osc 
	FOREIGN KEY (ft_natureza_juridica_osc) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_dados_gerais 
	ADD CONSTRAINT fk_ft_subclasse_atividade_economica_osc 
	FOREIGN KEY (ft_subclasse_atividade_economica_osc) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_dados_gerais 
	ADD CONSTRAINT fk_ft_razao_social_osc 
	FOREIGN KEY (ft_razao_social_osc) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_dados_gerais 
	ADD CONSTRAINT fk_ft_nome_fantasia_osc 
	FOREIGN KEY (ft_nome_fantasia_osc) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_dados_gerais 
	ADD CONSTRAINT fk_ft_logo 
	FOREIGN KEY (ft_logo) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_dados_gerais 
	ADD CONSTRAINT fk_ft_missao_osc 
	FOREIGN KEY (ft_missao_osc) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_dados_gerais 
	ADD CONSTRAINT fk_ft_visao_osc 
	FOREIGN KEY (ft_visao_osc) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_dados_gerais 
	ADD CONSTRAINT fk_ft_fundacao_osc 
	FOREIGN KEY (ft_fundacao_osc) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_dados_gerais 
	ADD CONSTRAINT fk_ft_ano_cadastro_cnpj 
	FOREIGN KEY (ft_ano_cadastro_cnpj) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_dados_gerais 
	ADD CONSTRAINT fk_ft_sigla_osc 
	FOREIGN KEY (ft_sigla_osc) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_dados_gerais 
	ADD CONSTRAINT fk_ft_resumo_osc 
	FOREIGN KEY (ft_resumo_osc) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_dados_gerais 
	ADD CONSTRAINT fk_ft_situacao_imovel_osc 
	FOREIGN KEY (ft_situacao_imovel_osc) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_dados_gerais 
	ADD CONSTRAINT fk_ft_link_estatuto_osc 
	FOREIGN KEY (ft_link_estatuto_osc) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_dados_gerais 
	ADD CONSTRAINT fk_ft_historico 
	FOREIGN KEY (ft_historico) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_dados_gerais 
	ADD CONSTRAINT fk_ft_finalidades_estatutarias 
	FOREIGN KEY (ft_finalidades_estatutarias) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_dados_gerais 
	ADD CONSTRAINT fk_ft_link_relatorio_auditoria 
	FOREIGN KEY (ft_link_relatorio_auditoria) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_dados_gerais 
	ADD CONSTRAINT fk_ft_link_demonstracao_contabil 
	FOREIGN KEY (ft_link_demonstracao_contabil) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

	ALTER TABLE osc.tb_dados_gerais 
	ADD CONSTRAINT fk_ft_nome_responsavel_legal 
	FOREIGN KEY (ft_nome_responsavel_legal) 
	REFERENCES syst.dc_fonte_dados(cd_sigla_fonte_dados);

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
