DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_participacao_social_conferencia(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_participacao_social_conferencia(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$
	
BEGIN 
	UPDATE osc.tb_participacao_social_conferencia 
	SET	ft_conferencia = fonte_nova 
	WHERE ft_conferencia = fonte_antiga;
	
	UPDATE osc.tb_participacao_social_conferencia 
	SET	ft_ano_realizacao = fonte_nova 
	WHERE ft_ano_realizacao = fonte_antiga;
	
	UPDATE osc.tb_participacao_social_conferencia 
	SET	ft_forma_participacao_conferencia = fonte_nova 
	WHERE ft_forma_participacao_conferencia = fonte_antiga;
	
	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
