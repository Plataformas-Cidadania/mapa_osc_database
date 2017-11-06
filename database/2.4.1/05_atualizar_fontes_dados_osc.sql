DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_osc(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_osc(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$
	
BEGIN 
	UPDATE osc.tb_osc 
	SET	ft_apelido_osc = fonte_nova 
	WHERE ft_apelido_osc = fonte_antiga;
	
	UPDATE osc.tb_osc 
	SET	ft_identificador_osc = fonte_nova 
	WHERE ft_identificador_osc = fonte_antiga;
	
	UPDATE osc.tb_osc 
	SET	ft_osc_ativa = fonte_nova 
	WHERE ft_osc_ativa = fonte_antiga;
	
	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
