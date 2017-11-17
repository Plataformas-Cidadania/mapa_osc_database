DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_relacoes_trabalho_outra(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_relacoes_trabalho_outra(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$
	
BEGIN 
	UPDATE osc.tb_relacoes_trabalho_outra 
	SET	ft_trabalhadores = fonte_nova 
	WHERE ft_trabalhadores = fonte_antiga;
	
	UPDATE osc.tb_relacoes_trabalho_outra 
	SET	ft_tipo_relacao_trabalho = fonte_nova 
	WHERE ft_tipo_relacao_trabalho = fonte_antiga;
	
	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
