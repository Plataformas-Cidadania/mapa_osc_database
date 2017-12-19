DO $$
BEGIN
	SELECT * FROM syst.atualizar_fontes_dados_geral('3', 'Galileo');
	SELECT * FROM syst.atualizar_fontes_dados_geral('1', 'Representante de OSC');
	SELECT * FROM syst.atualizar_fontes_dados_geral('Representante', 'Representante de OSC');
	SELECT * FROM syst.atualizar_fontes_dados_geral('Representate', 'Representante de OSC');
	SELECT * FROM syst.atualizar_fontes_dados_geral('FNDCT/FINEP', 'FINEP/FNDCT');
	SELECT * FROM syst.atualizar_fontes_dados_geral('MCID/MCMV-E', 'MCMV-E/MCID');
	SELECT * FROM syst.atualizar_fontes_dados_geral('MDS/Base', 'Base/MDS');
	SELECT * FROM syst.atualizar_fontes_dados_geral('MDS/CEBAS', 'CEBAS/MDS');
	SELECT * FROM syst.atualizar_fontes_dados_geral('MS/AS', 'CEBAS/MDS');
	SELECT * FROM syst.atualizar_fontes_dados_geral('MDS/Censo SUAS', 'Censo SUAS/MDS');
	SELECT * FROM syst.atualizar_fontes_dados_geral('MEC/CEBAS', 'CEBAS/MEC');
	SELECT * FROM syst.atualizar_fontes_dados_geral('MESP/LIE', 'LIE/MESP');
	SELECT * FROM syst.atualizar_fontes_dados_geral('MINC/SALICWEB', 'SALICWEB/MINC');
	SELECT * FROM syst.atualizar_fontes_dados_geral('MJ/CNES/OSCIP', 'OSCIP/MJ');
	SELECT * FROM syst.atualizar_fontes_dados_geral('MJ/CNES/UPF', 'UPF/MJ');
	SELECT * FROM syst.atualizar_fontes_dados_geral('MMA/CNEA', 'CNEA/MMA');
	SELECT * FROM syst.atualizar_fontes_dados_geral('MPOG/SICONV', 'SICONV/MPOG');
	SELECT * FROM syst.atualizar_fontes_dados_geral('MS/CEBAS', 'CEBAS/MS');
	SELECT * FROM syst.atualizar_fontes_dados_geral('MTE/RAIS', 'RAIS/MTE');
	SELECT * FROM syst.atualizar_fontes_dados_geral('SGPR/Conselhos', 'Conselhos/SGPR');

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
