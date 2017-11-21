DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_representante_conselho(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_representante_conselho(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$
	
BEGIN 
	UPDATE osc.tb_representante_conselho 
	SET	ft_nome_representante_conselho = fonte_nova 
	WHERE ft_nome_representante_conselho = fonte_antiga;
	
	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
