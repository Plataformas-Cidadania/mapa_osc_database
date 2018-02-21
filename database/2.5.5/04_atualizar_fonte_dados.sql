ALTER TABLE osc.tb_area_atuacao DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_area_atuacao_outra DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_area_atuacao_outra_projeto DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_area_atuacao_projeto DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_certificado DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_conselho_fiscal DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_contato DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_dados_gerais DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_financiador_projeto DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_fonte_recursos_projeto DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_governanca DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_localizacao_projeto DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_objetivo_osc DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_objetivo_projeto DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_osc_parceira_projeto DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_participacao_social_conferencia DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_participacao_social_conferencia_outra DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_participacao_social_conselho DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_participacao_social_conselho_outro DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_participacao_social_outra DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_projeto DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_publico_beneficiado_projeto DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_recursos_osc DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_recursos_outro_osc DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_relacoes_trabalho DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_relacoes_trabalho_outra DISABLE TRIGGER ALL;
ALTER TABLE osc.tb_representante_conselho DISABLE TRIGGER ALL;

DO $$
BEGIN
	PERFORM syst.atualizar_fontes_dados_geral('3', 'Galileo');
	PERFORM syst.atualizar_fontes_dados_geral('1', 'Representante de OSC');
	PERFORM syst.atualizar_fontes_dados_geral('Representante', 'Representante de OSC');
	PERFORM syst.atualizar_fontes_dados_geral('Representate', 'Representante de OSC');
	PERFORM syst.atualizar_fontes_dados_geral('FNDCT/FINEP', 'FINEP/FNDCT');
	PERFORM syst.atualizar_fontes_dados_geral('MCID/MCMV-E', 'MCMV-E/MCID');
	PERFORM syst.atualizar_fontes_dados_geral('MDS/Base', 'Base/MDS');
	PERFORM syst.atualizar_fontes_dados_geral('MDS/CEBAS', 'CEBAS/MDS');
	PERFORM syst.atualizar_fontes_dados_geral('MS/AS', 'CEBAS/MDS');
	PERFORM syst.atualizar_fontes_dados_geral('MDS/Censo SUAS', 'Censo SUAS/MDS');
	PERFORM syst.atualizar_fontes_dados_geral('MEC/CEBAS', 'CEBAS/MEC');
	PERFORM syst.atualizar_fontes_dados_geral('MESP/LIE', 'LIE/MESP');
	PERFORM syst.atualizar_fontes_dados_geral('MINC/SALICWEB', 'SALICWEB/MINC');
	PERFORM syst.atualizar_fontes_dados_geral('MJ/CNES/OSCIP', 'OSCIP/MJ');
	PERFORM syst.atualizar_fontes_dados_geral('MJ/CNES/UPF', 'UPF/MJ');
	PERFORM syst.atualizar_fontes_dados_geral('MMA/CNEA', 'CNEA/MMA');
	PERFORM syst.atualizar_fontes_dados_geral('MPOG/SICONV', 'SICONV/MPOG');
	PERFORM syst.atualizar_fontes_dados_geral('MS/CEBAS', 'CEBAS/MS');
	PERFORM syst.atualizar_fontes_dados_geral('MTE/RAIS', 'RAIS/MTE');
	PERFORM syst.atualizar_fontes_dados_geral('SGPR/Conselhos', 'Conselhos/SGPR');

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';



ALTER TABLE osc.tb_area_atuacao ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_area_atuacao_outra ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_area_atuacao_outra_projeto ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_area_atuacao_projeto ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_certificado ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_conselho_fiscal ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_contato ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_dados_gerais ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_financiador_projeto ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_fonte_recursos_projeto ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_governanca ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_localizacao_projeto ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_objetivo_osc ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_objetivo_projeto ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_osc_parceira_projeto ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_participacao_social_conferencia ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_participacao_social_conferencia_outra ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_participacao_social_conselho ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_participacao_social_conselho_outro ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_participacao_social_outra ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_projeto ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_publico_beneficiado_projeto ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_recursos_osc ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_recursos_outro_osc ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_relacoes_trabalho ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_relacoes_trabalho_outra ENABLE TRIGGER ALL;
ALTER TABLE osc.tb_representante_conselho ENABLE TRIGGER ALL;
