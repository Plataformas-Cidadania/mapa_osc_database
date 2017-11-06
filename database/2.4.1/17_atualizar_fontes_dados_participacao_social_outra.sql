DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_participacao_social_outra(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_participacao_social_outra(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$
	
BEGIN 
	UPDATE osc.tb_participacao_social_outra 
	SET	ft_participacao_social_outra = fonte_nova 
	WHERE ft_participacao_social_outra = fonte_antiga;
	
	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
