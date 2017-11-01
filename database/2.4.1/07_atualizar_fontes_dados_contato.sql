DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_contato(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_contato(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$
	
BEGIN 
	UPDATE osc.tb_contato 
	SET	ft_telefone = fonte_nova 
	WHERE ft_telefone = fonte_antiga;
	
	UPDATE osc.tb_contato 
	SET	ft_email = fonte_nova 
	WHERE ft_email = fonte_antiga;
	
	UPDATE osc.tb_contato 
	SET	ft_representante = fonte_nova 
	WHERE ft_representante = fonte_antiga;
	
	UPDATE osc.tb_contato 
	SET	ft_site = fonte_nova 
	WHERE ft_site = fonte_antiga;
	
	UPDATE osc.tb_contato 
	SET	ft_facebook = fonte_nova 
	WHERE ft_facebook = fonte_antiga;
	
	UPDATE osc.tb_contato 
	SET	ft_google = fonte_nova 
	WHERE ft_google = fonte_antiga;
	
	UPDATE osc.tb_contato 
	SET	ft_linkedin = fonte_nova 
	WHERE ft_linkedin = fonte_antiga;
	
	UPDATE osc.tb_contato 
	SET	ft_twitter = fonte_nova 
	WHERE ft_twitter = fonte_antiga;
	
	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
