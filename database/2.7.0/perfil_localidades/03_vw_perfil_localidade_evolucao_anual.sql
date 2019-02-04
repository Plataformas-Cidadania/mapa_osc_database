DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_evolucao_anual CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_evolucao_anual AS 

SELECT 
	SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1) AS localidade,
	(
		CASE 
			WHEN tb_dados_gerais.dt_fundacao_osc > '1500-01-01'::DATE THEN DATE_PART('year', tb_dados_gerais.dt_fundacao_osc)::INTEGER
			ELSE null
		END
	) AS ano_fundacao,
	COUNT(DISTINCT tb_osc.id_osc) AS quantidade_oscs,
	REPLACE(('{' || TRIM(TRANSLATE(
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
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM osc.tb_osc
LEFT JOIN osc.tb_dados_gerais
ON tb_osc.id_osc = tb_dados_gerais.id_osc
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
AND tb_localizacao.cd_municipio IS NOT NULL
AND tb_dados_gerais.dt_fundacao_osc IS NOT NULL
GROUP BY localidade, ano_fundacao

UNION

SELECT 
	SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2) AS localidade,
	(
		CASE 
			WHEN tb_dados_gerais.dt_fundacao_osc > '1500-01-01'::DATE THEN DATE_PART('year', tb_dados_gerais.dt_fundacao_osc)::INTEGER
			ELSE null
		END
	) AS ano_fundacao,
	COUNT(DISTINCT tb_osc.id_osc) AS quantidade_oscs,
	REPLACE(('{' || TRIM(TRANSLATE(
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
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM osc.tb_osc
LEFT JOIN osc.tb_dados_gerais
ON tb_osc.id_osc = tb_dados_gerais.id_osc
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
AND tb_localizacao.cd_municipio IS NOT NULL
AND tb_dados_gerais.dt_fundacao_osc IS NOT NULL
GROUP BY localidade, ano_fundacao

UNION

SELECT 
	tb_localizacao.cd_municipio::TEXT AS localidade,
	(
		CASE 
			WHEN tb_dados_gerais.dt_fundacao_osc > '1500-01-01'::DATE THEN DATE_PART('year', tb_dados_gerais.dt_fundacao_osc)::INTEGER
			ELSE null
		END
	) AS ano_fundacao,
	COUNT(DISTINCT tb_osc.id_osc) AS quantidade_oscs,
	REPLACE(('{' || TRIM(TRANSLATE(
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
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM osc.tb_osc
LEFT JOIN osc.tb_dados_gerais
ON tb_osc.id_osc = tb_dados_gerais.id_osc
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
AND tb_localizacao.cd_municipio IS NOT NULL
AND tb_dados_gerais.dt_fundacao_osc IS NOT NULL
GROUP BY localidade, ano_fundacao;

CREATE INDEX ix_localidade_vw_perfil_localidade_evolucao_anual
    ON analysis.vw_perfil_localidade_evolucao_anual USING btree
    (localidade ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX ix_ano_fundacao_vw_perfil_localidade_evolucao_anual
    ON analysis.vw_perfil_localidade_evolucao_anual USING btree
    (ano_fundacao ASC NULLS LAST)
    TABLESPACE pg_default;