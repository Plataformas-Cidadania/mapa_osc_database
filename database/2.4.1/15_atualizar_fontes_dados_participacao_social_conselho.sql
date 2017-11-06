DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_participacao_social_conselho(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_participacao_social_conselho(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$
	
BEGIN 
	UPDATE osc.tb_participacao_social_conselho 
	SET	ft_conselho = fonte_nova 
	WHERE ft_conselho = fonte_antiga;
	
	UPDATE osc.tb_participacao_social_conselho 
	SET	ft_tipo_participacao = fonte_nova 
	WHERE ft_tipo_participacao = fonte_antiga;
	
	UPDATE osc.tb_participacao_social_conselho 
	SET	ft_periodicidade_reuniao = fonte_nova 
	WHERE ft_periodicidade_reuniao = fonte_antiga;
	
	UPDATE osc.tb_participacao_social_conselho 
	SET	ft_data_inicio_conselho = fonte_nova 
	WHERE ft_data_inicio_conselho = fonte_antiga;
	
	UPDATE osc.tb_participacao_social_conselho 
	SET	ft_data_fim_conselho = fonte_nova 
	WHERE ft_data_fim_conselho = fonte_antiga;
	
	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
