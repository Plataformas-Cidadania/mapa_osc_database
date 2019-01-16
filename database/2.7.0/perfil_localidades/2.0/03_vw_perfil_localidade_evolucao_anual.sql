DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_evolucao_anual CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_evolucao_anual AS 

SELECT 
	COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1), 'Sem informação') AS localidade,
	COALESCE(DATE_PART('year', tb_dados_gerais.dt_fundacao_osc)::TEXT, 'Sem informação') AS fundacao,
	COUNT(tb_osc) AS nr_quantidade_oscs,
	('{' || TRIM(TRANSLATE(
		(
		    SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
			ARRAY_CAT(
				ARRAY_CAT(
					ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
					ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
				),
				ARRAY_AGG(DISTINCT COALESCE(tb_dados_gerais.ft_fundacao_osc, ''))
			)
		    )) AS a
		)::TEXT
	, '"\{}', ''), ',') || '}')::TEXT[] AS fontes_caracteristicas
FROM osc.tb_osc
LEFT JOIN osc.tb_dados_gerais
ON tb_osc.id_osc = tb_dados_gerais.id_osc
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
GROUP BY localidade, fundacao

UNION

SELECT 
	COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2), 'Sem informação') AS localidade,
	COALESCE(DATE_PART('year', tb_dados_gerais.dt_fundacao_osc)::TEXT, 'Sem informação') AS fundacao,
	COUNT(tb_osc) AS nr_quantidade_oscs,
	('{' || TRIM(TRANSLATE(
		(
		    SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
			ARRAY_CAT(
				ARRAY_CAT(
					ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
					ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
				),
				ARRAY_AGG(DISTINCT COALESCE(tb_dados_gerais.ft_fundacao_osc, ''))
			)
		    )) AS a
		)::TEXT
	, '"\{}', ''), ',') || '}')::TEXT[] AS fontes_caracteristicas
FROM osc.tb_osc
LEFT JOIN osc.tb_dados_gerais
ON tb_osc.id_osc = tb_dados_gerais.id_osc
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
GROUP BY localidade, fundacao

UNION

SELECT 
	COALESCE(tb_localizacao.cd_municipio::TEXT, 'Sem informação') AS localidade,
	COALESCE(DATE_PART('year', tb_dados_gerais.dt_fundacao_osc)::TEXT, 'Sem informação') AS fundacao,
	COUNT(tb_osc) AS nr_quantidade_oscs,
	('{' || TRIM(TRANSLATE(
		(
		    SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
			ARRAY_CAT(
				ARRAY_CAT(
					ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
					ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
				),
				ARRAY_AGG(DISTINCT COALESCE(tb_dados_gerais.ft_fundacao_osc, ''))
			)
		    )) AS a
		)::TEXT
	, '"\{}', ''), ',') || '}')::TEXT[] AS fontes_caracteristicas
FROM osc.tb_osc
LEFT JOIN osc.tb_dados_gerais
ON tb_osc.id_osc = tb_dados_gerais.id_osc
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
GROUP BY localidade, fundacao;