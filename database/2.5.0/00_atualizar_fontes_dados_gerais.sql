DROP FUNCTION IF EXISTS syst.atualizar_fontes_dados_dados_gerais(fonte_antiga TEXT, fonte_nova TEXT);

CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_dados_gerais(fonte_antiga TEXT, fonte_nova TEXT) RETURNS TABLE(
	mensagem TEXT,
	flag BOOLEAN
)AS $$

BEGIN
	UPDATE osc.tb_dados_gerais
	SET	ft_natureza_juridica_osc = fonte_nova
	WHERE ft_natureza_juridica_osc = fonte_antiga;

	UPDATE osc.tb_dados_gerais
	SET	ft_classe_atividade_economica_osc = fonte_nova
	WHERE ft_classe_atividade_economica_osc = fonte_antiga;

	UPDATE osc.tb_dados_gerais
	SET	ft_razao_social_osc = fonte_nova
	WHERE ft_razao_social_osc = fonte_antiga;

	UPDATE osc.tb_dados_gerais
	SET	ft_nome_fantasia_osc = fonte_nova
	WHERE ft_nome_fantasia_osc = fonte_antiga;

	UPDATE osc.tb_dados_gerais
	SET	ft_logo = fonte_nova
	WHERE ft_logo = fonte_antiga;

	UPDATE osc.tb_dados_gerais
	SET	ft_missao_osc = fonte_nova
	WHERE ft_missao_osc = fonte_antiga;

	UPDATE osc.tb_dados_gerais
	SET	ft_visao_osc = fonte_nova
	WHERE ft_visao_osc = fonte_antiga;

	UPDATE osc.tb_dados_gerais
	SET	ft_fundacao_osc = fonte_nova
	WHERE ft_fundacao_osc = fonte_antiga;

	UPDATE osc.tb_dados_gerais
	SET	ft_ano_cadastro_cnpj = fonte_nova
	WHERE ft_ano_cadastro_cnpj = fonte_antiga;

	UPDATE osc.tb_dados_gerais
	SET	ft_sigla_osc = fonte_nova
	WHERE ft_sigla_osc = fonte_antiga;

	UPDATE osc.tb_dados_gerais
	SET	ft_resumo_osc = fonte_nova
	WHERE ft_resumo_osc = fonte_antiga;

	UPDATE osc.tb_dados_gerais
	SET	ft_situacao_imovel_osc = fonte_nova
	WHERE ft_situacao_imovel_osc = fonte_antiga;

	UPDATE osc.tb_dados_gerais
	SET	ft_link_estatuto_osc = fonte_nova
	WHERE ft_link_estatuto_osc = fonte_antiga;

	UPDATE osc.tb_dados_gerais
	SET	ft_historico = fonte_nova
	WHERE ft_historico = fonte_antiga;

	UPDATE osc.tb_dados_gerais
	SET	ft_finalidades_estatutarias = fonte_nova
	WHERE ft_finalidades_estatutarias = fonte_antiga;

	UPDATE osc.tb_dados_gerais
	SET	ft_link_relatorio_auditoria = fonte_nova
	WHERE ft_link_relatorio_auditoria = fonte_antiga;

	UPDATE osc.tb_dados_gerais
	SET	ft_link_demonstracao_contabil = fonte_nova
	WHERE ft_link_demonstracao_contabil = fonte_antiga;

	UPDATE osc.tb_dados_gerais
	SET	ft_nome_responsavel_legal = fonte_nova
	WHERE ft_nome_responsavel_legal = fonte_antiga;

	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
