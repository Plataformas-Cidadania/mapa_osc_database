DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_fonte_recursos_osc(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_fonte_recursos_osc(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$
	
BEGIN 
	UPDATE osc.tb_recursos_osc 
	SET	ft_fonte_recursos_osc = fonte_nova 
	WHERE ft_fonte_recursos_osc = fonte_antiga;
	
	UPDATE osc.tb_recursos_osc 
	SET	ft_ano_recursos_osc = fonte_nova 
	WHERE ft_ano_recursos_osc = fonte_antiga;
	
	UPDATE osc.tb_recursos_osc 
	SET	ft_valor_recursos_osc = fonte_nova 
	WHERE ft_valor_recursos_osc = fonte_antiga;
	
	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
