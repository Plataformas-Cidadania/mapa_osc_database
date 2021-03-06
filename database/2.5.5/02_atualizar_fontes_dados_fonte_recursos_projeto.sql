DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_fonte_recursos_projeto(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_fonte_recursos_projeto(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$
	
BEGIN 
	UPDATE osc.tb_fonte_recursos_projeto 
	SET	ft_fonte_recursos_projeto = fonte_nova 
	WHERE ft_fonte_recursos_projeto = fonte_antiga;
	
	UPDATE osc.tb_fonte_recursos_projeto 
	SET	ft_orgao_concedente = fonte_nova 
	WHERE ft_orgao_concedente = fonte_antiga;
	
	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
