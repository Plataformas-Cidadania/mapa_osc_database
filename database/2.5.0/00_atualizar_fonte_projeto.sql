DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_projeto(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_projeto(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT,
	flag BOOLEAN
)AS $$

BEGIN
	UPDATE osc.tb_projeto
	SET	ft_nome_projeto = fonte_nova
	WHERE ft_nome_projeto = fonte_antiga;

	UPDATE osc.tb_projeto
	SET	ft_status_projeto = fonte_nova
	WHERE ft_status_projeto = fonte_antiga;

	UPDATE osc.tb_projeto
	SET	ft_data_inicio_projeto = fonte_nova
	WHERE ft_data_inicio_projeto = fonte_antiga;

	UPDATE osc.tb_projeto
	SET	ft_data_fim_projeto = fonte_nova
	WHERE ft_data_fim_projeto = fonte_antiga;

	UPDATE osc.tb_projeto
	SET	ft_link_projeto = fonte_nova
	WHERE ft_link_projeto = fonte_antiga;

	UPDATE osc.tb_projeto
	SET	ft_total_beneficiarios = fonte_nova
	WHERE ft_total_beneficiarios = fonte_antiga;

	UPDATE osc.tb_projeto
	SET	ft_valor_captado_projeto = fonte_nova
	WHERE ft_valor_captado_projeto = fonte_antiga;

	UPDATE osc.tb_projeto
	SET	ft_valor_total_projeto = fonte_nova
	WHERE ft_valor_total_projeto = fonte_antiga;

	UPDATE osc.tb_projeto
	SET	ft_abrangencia_projeto = fonte_nova
	WHERE ft_abrangencia_projeto = fonte_antiga;

	UPDATE osc.tb_projeto
	SET	ft_zona_atuacao_projeto = fonte_nova
	WHERE ft_zona_atuacao_projeto = fonte_antiga;

	UPDATE osc.tb_projeto
	SET	ft_descricao_projeto = fonte_nova
	WHERE ft_descricao_projeto = fonte_antiga;

	UPDATE osc.tb_projeto
	SET	ft_metodologia_monitoramento = fonte_nova
	WHERE ft_metodologia_monitoramento = fonte_antiga;

	UPDATE osc.tb_projeto
	SET	ft_identificador_projeto_externo = fonte_nova
	WHERE ft_identificador_projeto_externo = fonte_antiga;

	UPDATE osc.tb_projeto
	SET	ft_municipio = fonte_nova
	WHERE ft_municipio = fonte_antiga;

	UPDATE osc.tb_projeto
	SET	ft_uf = fonte_nova
	WHERE ft_uf = fonte_antiga;

	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
