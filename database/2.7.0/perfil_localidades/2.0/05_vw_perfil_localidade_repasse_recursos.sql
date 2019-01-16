DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_repasse_recursos CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_repasse_recursos AS 

(
	SELECT 
		COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1), 'Sem informação') AS localidade,
		COALESCE(DATE_PART('year', tb_recursos_osc.dt_ano_recursos_osc)::TEXT, 'Sem informação') AS ano,
		COALESCE(dc_fonte_recursos_osc.tx_nome_fonte_recursos_osc::TEXT, 'Sem informação') AS fonte_recursos,
		SUM(COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0)) AS valor_recursos,
		('{' || TRIM(TRANSLATE(
			(
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
				ARRAY_CAT(
					ARRAY_CAT(
						ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
						ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
					),
					ARRAY_AGG(DISTINCT COALESCE(tb_dados_gerais.ft_natureza_juridica_osc, ''))
				)
				)) AS a
			)::TEXT
		, '"\{}', ''), ',') || '}')::TEXT[] AS fontes_caracteristicas
	FROM osc.tb_osc
	LEFT JOIN osc.tb_dados_gerais
	ON tb_osc.id_osc = tb_dados_gerais.id_osc
	LEFT JOIN osc.tb_recursos_osc
	ON tb_osc.id_osc = tb_recursos_osc.id_osc
	LEFT JOIN syst.dc_fonte_recursos_osc
	ON tb_recursos_osc.cd_fonte_recursos_osc = dc_fonte_recursos_osc.cd_fonte_recursos_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	GROUP BY localidade, ano, fonte_recursos

	UNION

	SELECT 
		COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1), 'Sem informação') AS localidade,
		COALESCE(DATE_PART('year', tb_recursos_outro_osc.dt_ano_recursos_outro_osc)::TEXT, 'Sem informação') AS ano,
		COALESCE(tb_recursos_outro_osc.tx_nome_fonte_recursos_outro_osc::TEXT, 'Sem informação') AS fonte_recursos,
		SUM(COALESCE(tb_recursos_outro_osc.nr_valor_recursos_outro_osc, 0)) AS valor_recursos,
		('{' || TRIM(TRANSLATE(
			(
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
				ARRAY_CAT(
					ARRAY_CAT(
						ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
						ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
					),
					ARRAY_AGG(DISTINCT COALESCE(tb_dados_gerais.ft_natureza_juridica_osc, ''))
				)
				)) AS a
			)::TEXT
		, '"\{}', ''), ',') || '}')::TEXT[] AS fontes_caracteristicas
	FROM osc.tb_osc
	LEFT JOIN osc.tb_dados_gerais
	ON tb_osc.id_osc = tb_dados_gerais.id_osc
	LEFT JOIN osc.tb_recursos_outro_osc
	ON tb_osc.id_osc = tb_recursos_outro_osc.id_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	GROUP BY localidade, ano, fonte_recursos
)

UNION

(
	SELECT 
		COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2), 'Sem informação') AS localidade,
		COALESCE(DATE_PART('year', tb_recursos_osc.dt_ano_recursos_osc)::TEXT, 'Sem informação') AS ano,
		COALESCE(dc_fonte_recursos_osc.tx_nome_fonte_recursos_osc::TEXT, 'Sem informação') AS fonte_recursos,
		SUM(COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0)) AS valor_recursos,
		('{' || TRIM(TRANSLATE(
			(
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
				ARRAY_CAT(
					ARRAY_CAT(
						ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
						ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
					),
					ARRAY_AGG(DISTINCT COALESCE(tb_dados_gerais.ft_natureza_juridica_osc, ''))
				)
				)) AS a
			)::TEXT
		, '"\{}', ''), ',') || '}')::TEXT[] AS fontes_caracteristicas
	FROM osc.tb_osc
	LEFT JOIN osc.tb_dados_gerais
	ON tb_osc.id_osc = tb_dados_gerais.id_osc
	LEFT JOIN osc.tb_recursos_osc
	ON tb_osc.id_osc = tb_recursos_osc.id_osc
	LEFT JOIN syst.dc_fonte_recursos_osc
	ON tb_recursos_osc.cd_fonte_recursos_osc = dc_fonte_recursos_osc.cd_fonte_recursos_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	GROUP BY localidade, ano, fonte_recursos

	UNION

	SELECT 
		COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2), 'Sem informação') AS localidade,
		COALESCE(DATE_PART('year', tb_recursos_outro_osc.dt_ano_recursos_outro_osc)::TEXT, 'Sem informação') AS ano,
		COALESCE(tb_recursos_outro_osc.tx_nome_fonte_recursos_outro_osc::TEXT, 'Sem informação') AS fonte_recursos,
		SUM(COALESCE(tb_recursos_outro_osc.nr_valor_recursos_outro_osc, 0)) AS valor_recursos,
		('{' || TRIM(TRANSLATE(
			(
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
				ARRAY_CAT(
					ARRAY_CAT(
						ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
						ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
					),
					ARRAY_AGG(DISTINCT COALESCE(tb_dados_gerais.ft_natureza_juridica_osc, ''))
				)
				)) AS a
			)::TEXT
		, '"\{}', ''), ',') || '}')::TEXT[] AS fontes_caracteristicas
	FROM osc.tb_osc
	LEFT JOIN osc.tb_dados_gerais
	ON tb_osc.id_osc = tb_dados_gerais.id_osc
	LEFT JOIN osc.tb_recursos_outro_osc
	ON tb_osc.id_osc = tb_recursos_outro_osc.id_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	GROUP BY localidade, ano, fonte_recursos
)

UNION

(
	SELECT 
		COALESCE(tb_localizacao.cd_municipio::TEXT, 'Sem informação') AS localidade,
		COALESCE(DATE_PART('year', tb_recursos_osc.dt_ano_recursos_osc)::TEXT, 'Sem informação') AS ano,
		COALESCE(dc_fonte_recursos_osc.tx_nome_fonte_recursos_osc::TEXT, 'Sem informação') AS fonte_recursos,
		SUM(COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0)) AS valor_recursos,
		('{' || TRIM(TRANSLATE(
			(
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
				ARRAY_CAT(
					ARRAY_CAT(
						ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
						ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
					),
					ARRAY_AGG(DISTINCT COALESCE(tb_dados_gerais.ft_natureza_juridica_osc, ''))
				)
				)) AS a
			)::TEXT
		, '"\{}', ''), ',') || '}')::TEXT[] AS fontes_caracteristicas
	FROM osc.tb_osc
	LEFT JOIN osc.tb_dados_gerais
	ON tb_osc.id_osc = tb_dados_gerais.id_osc
	LEFT JOIN osc.tb_recursos_osc
	ON tb_osc.id_osc = tb_recursos_osc.id_osc
	LEFT JOIN syst.dc_fonte_recursos_osc
	ON tb_recursos_osc.cd_fonte_recursos_osc = dc_fonte_recursos_osc.cd_fonte_recursos_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	GROUP BY localidade, ano, fonte_recursos

	UNION

	SELECT 
		COALESCE(tb_localizacao.cd_municipio::TEXT, 'Sem informação') AS localidade,
		COALESCE(DATE_PART('year', tb_recursos_outro_osc.dt_ano_recursos_outro_osc)::TEXT, 'Sem informação') AS ano,
		COALESCE(tb_recursos_outro_osc.tx_nome_fonte_recursos_outro_osc::TEXT, 'Sem informação') AS fonte_recursos,
		SUM(COALESCE(tb_recursos_outro_osc.nr_valor_recursos_outro_osc, 0)) AS valor_recursos,
		('{' || TRIM(TRANSLATE(
			(
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
				ARRAY_CAT(
					ARRAY_CAT(
						ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
						ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
					),
					ARRAY_AGG(DISTINCT COALESCE(tb_dados_gerais.ft_natureza_juridica_osc, ''))
				)
				)) AS a
			)::TEXT
		, '"\{}', ''), ',') || '}')::TEXT[] AS fontes_caracteristicas
	FROM osc.tb_osc
	LEFT JOIN osc.tb_dados_gerais
	ON tb_osc.id_osc = tb_dados_gerais.id_osc
	LEFT JOIN osc.tb_recursos_outro_osc
	ON tb_osc.id_osc = tb_recursos_outro_osc.id_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	GROUP BY localidade, ano, fonte_recursos
);