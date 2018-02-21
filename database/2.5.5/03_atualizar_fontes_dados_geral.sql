DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_geral(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_geral(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$
	
BEGIN 
	PERFORM syst.atualizar_fontes_dados_osc(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_dados_gerais(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_contato(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_localizacao(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_relacoes_trabalho(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_relacoes_trabalho_outra(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_conselho_fiscal(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_area_atuacao(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_certificado(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_participacao_social_conferencia(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_participacao_social_conselho(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_representante_conselho(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_participacao_social_outra(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_fonte_recursos_osc(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_projeto(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_area_atuacao_projeto(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_localizacao_projeto(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_fonte_recursos_projeto(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_financiador_projeto(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_objetivo_projeto(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_parceria_projeto(fonte_antiga, fonte_nova);
	PERFORM syst.atualizar_fontes_dados_publico_beneficiado_projeto(fonte_antiga, fonte_nova);
	
	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
