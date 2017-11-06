DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_publico_beneficiado_projeto(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_publico_beneficiado_projeto(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$
	
BEGIN 
	UPDATE osc.tb_publico_beneficiado_projeto 
	SET	ft_publico_beneficiado_projeto = fonte_nova 
	WHERE ft_publico_beneficiado_projeto = fonte_antiga;
	
	UPDATE osc.tb_publico_beneficiado 
	SET	ft_publico_beneficiado = fonte_nova 
	WHERE ft_publico_beneficiado = fonte_antiga;
	
	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
