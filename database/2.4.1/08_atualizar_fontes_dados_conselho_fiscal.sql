DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_conselho_fiscal(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_conselho_fiscal(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$
	
BEGIN 
	UPDATE osc.tb_conselho_fiscal 
	SET	ft_nome_conselheiro = fonte_nova 
	WHERE ft_nome_conselheiro = fonte_antiga;
	
	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
