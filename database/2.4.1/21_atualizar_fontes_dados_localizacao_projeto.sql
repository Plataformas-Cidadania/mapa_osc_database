DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_localizacao_projeto(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_localizacao_projeto(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$
	
BEGIN 
	UPDATE osc.tb_localizacao_projeto 
	SET	ft_regiao_localizacao_projeto = fonte_nova 
	WHERE ft_regiao_localizacao_projeto = fonte_antiga;
	
	UPDATE osc.tb_localizacao_projeto 
	SET	ft_nome_regiao_localizacao_projeto = fonte_nova 
	WHERE ft_nome_regiao_localizacao_projeto = fonte_antiga;
	
	UPDATE osc.tb_localizacao_projeto 
	SET	ft_localizacao_prioritaria = fonte_nova 
	WHERE ft_localizacao_prioritaria = fonte_antiga;
	
	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
