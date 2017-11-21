DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_parceria_projeto(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_parceria_projeto(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$
	
BEGIN 
	UPDATE osc.tb_osc_parceira_projeto 
	SET	ft_osc_parceira_projeto = fonte_nova 
	WHERE ft_osc_parceira_projeto = fonte_antiga;
	
	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
