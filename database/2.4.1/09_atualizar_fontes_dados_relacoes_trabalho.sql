DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_relacoes_trabalho(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_relacoes_trabalho(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$
	
BEGIN 
	UPDATE osc.tb_relacoes_trabalho 
	SET	ft_trabalhadores_vinculo = fonte_nova 
	WHERE ft_trabalhadores_vinculo = fonte_antiga;
	
	UPDATE osc.tb_relacoes_trabalho 
	SET	ft_trabalhadores_deficiencia = fonte_nova 
	WHERE ft_trabalhadores_deficiencia = fonte_antiga;
	
	UPDATE osc.tb_relacoes_trabalho 
	SET	ft_trabalhadores_voluntarios = fonte_nova 
	WHERE ft_trabalhadores_voluntarios = fonte_antiga;
	
	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
