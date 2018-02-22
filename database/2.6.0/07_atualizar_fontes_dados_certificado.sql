DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_certificado(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_certificado(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$
	
BEGIN 
	UPDATE osc.tb_certificado 
	SET	ft_certificado = fonte_nova 
	WHERE ft_certificado = fonte_antiga;
	
	UPDATE osc.tb_certificado 
	SET	ft_inicio_certificado = fonte_nova 
	WHERE ft_inicio_certificado = fonte_antiga;
	
	UPDATE osc.tb_certificado 
	SET	ft_fim_certificado = fonte_nova 
	WHERE ft_fim_certificado = fonte_antiga;
	
	UPDATE osc.tb_certificado 
	SET	ft_fim_certificado = fonte_nova 
	WHERE ft_municipio = fonte_antiga;
	
	UPDATE osc.tb_certificado 
	SET	ft_fim_certificado = fonte_nova 
	WHERE ft_uf = fonte_antiga;
	
	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
