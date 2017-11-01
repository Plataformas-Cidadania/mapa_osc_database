DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_localizacao(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_localizacao(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$
	
BEGIN 
	UPDATE osc.tb_localizacao 
	SET	ft_endereco = fonte_nova 
	WHERE ft_endereco = fonte_antiga;
	
	UPDATE osc.tb_localizacao 
	SET	ft_localizacao = fonte_nova 
	WHERE ft_localizacao = fonte_antiga;
	
	UPDATE osc.tb_localizacao 
	SET	ft_endereco_complemento = fonte_nova 
	WHERE ft_endereco_complemento = fonte_antiga;
	
	UPDATE osc.tb_localizacao 
	SET	ft_bairro = fonte_nova 
	WHERE ft_bairro = fonte_antiga;
	
	UPDATE osc.tb_localizacao 
	SET	ft_municipio = fonte_nova 
	WHERE ft_municipio = fonte_antiga;
	
	UPDATE osc.tb_localizacao 
	SET	ft_geo_localizacao = fonte_nova 
	WHERE ft_geo_localizacao = fonte_antiga;
	
	UPDATE osc.tb_localizacao 
	SET	ft_cep = fonte_nova 
	WHERE ft_cep = fonte_antiga;
	
	UPDATE osc.tb_localizacao 
	SET	ft_endereco_corrigido = fonte_nova 
	WHERE ft_endereco_corrigido = fonte_antiga;
	
	UPDATE osc.tb_localizacao 
	SET	ft_bairro_encontrado = fonte_nova 
	WHERE ft_bairro_encontrado = fonte_antiga;
	
	UPDATE osc.tb_localizacao 
	SET	ft_fonte_geocodificacao = fonte_nova 
	WHERE ft_fonte_geocodificacao = fonte_antiga;
	
	UPDATE osc.tb_localizacao 
	SET	ft_data_geocodificacao = fonte_nova 
	WHERE ft_data_geocodificacao = fonte_antiga;
	
	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
