DROP FUNCTION IF EXISTS portal.obter_osc_descricao(param TEXT);

CREATE OR REPLACE FUNCTION portal.obter_osc_descricao(param TEXT) RETURNS TABLE (
	tx_historico TEXT, 
	ft_historico TEXT, 
	tx_missao_osc TEXT, 
	ft_missao_osc TEXT, 
	tx_visao_osc TEXT, 
	ft_visao_osc TEXT, 
	tx_link_estatuto_osc TEXT, 
	ft_link_estatuto_osc TEXT, 
	tx_finalidades_estatutarias TEXT, 
	ft_finalidades_estatutarias TEXT
) AS $$ 
BEGIN 
	RETURN QUERY 
		SELECT
			tb_dados_gerais.tx_historico,
			tb_dados_gerais.ft_historico,
			tb_dados_gerais.tx_missao_osc,
			tb_dados_gerais.ft_missao_osc,
			tb_dados_gerais.tx_visao_osc,
			tb_dados_gerais.ft_visao_osc,
			tb_dados_gerais.tx_finalidades_estatutarias,
			tb_dados_gerais.ft_finalidades_estatutarias,
			tb_dados_gerais.tx_link_estatuto_osc,
			tb_dados_gerais.ft_link_estatuto_osc
		FROM osc.tb_osc
		LEFT JOIN osc.tb_dados_gerais ON tb_osc.id_osc = tb_dados_gerais.id_osc
		WHERE tb_osc.bo_osc_ativa
		AND (
			tb_osc.id_osc = param::INTEGER
			OR tb_osc.tx_apelido_osc = param
		);

END;
$$ LANGUAGE 'plpgsql';
