DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_trabalhadores CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_trabalhadores AS 

SELECT 
	SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1) AS localidade,
	SUM(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0)) AS vinculos,
	SUM(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0)) AS deficiencia,
	SUM(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)) AS voluntarios,
	SUM(
		COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) + 
		COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) +
		COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)
	) AS total,
	REPLACE(('{' || TRIM(TRANSLATE(
		(
			SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
			ARRAY_CAT(
				ARRAY_CAT(
					ARRAY_CAT(
						ARRAY_CAT(
							ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
							ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
						),
						ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, ''))
					),
					ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho.ft_trabalhadores_deficiencia, ''))
				),
				ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho.ft_trabalhadores_voluntarios, ''))
			))) AS a
		)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM osc.tb_osc
LEFT JOIN osc.tb_relacoes_trabalho
ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY localidade

UNION

SELECT 
	COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2), 'Sem informação') AS localidade,
	SUM(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0)) AS vinculos,
	SUM(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0)) AS deficiencia,
	SUM(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)) AS voluntarios,
	SUM(
		COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) + 
		COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) +
		COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)
	) AS total,
	REPLACE(('{' || TRIM(TRANSLATE(
		(
			SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
			ARRAY_CAT(
				ARRAY_CAT(
					ARRAY_CAT(
						ARRAY_CAT(
							ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
							ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
						),
						ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, ''))
					),
					ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho.ft_trabalhadores_deficiencia, ''))
				),
				ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho.ft_trabalhadores_voluntarios, ''))
			))) AS a
		)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM osc.tb_osc
LEFT JOIN osc.tb_relacoes_trabalho
ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY localidade

UNION

SELECT 
	COALESCE(tb_localizacao.cd_municipio::TEXT, 'Sem informação') AS localidade,
	SUM(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0)) AS vinculos,
	SUM(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0)) AS deficiencia,
	SUM(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)) AS voluntarios,
	SUM(
		COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) + 
		COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) +
		COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)
	) AS total,
	REPLACE(('{' || TRIM(TRANSLATE(
		(
			SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
			ARRAY_CAT(
				ARRAY_CAT(
					ARRAY_CAT(
						ARRAY_CAT(
							ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
							ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
						),
						ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, ''))
					),
					ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho.ft_trabalhadores_deficiencia, ''))
				),
				ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho.ft_trabalhadores_voluntarios, ''))
			))) AS a
		)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM osc.tb_osc
LEFT JOIN osc.tb_relacoes_trabalho
ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY localidade;

CREATE INDEX ix_localidade_vw_perfil_localidade_trabalhadores
    ON analysis.vw_perfil_localidade_trabalhadores USING btree
    (localidade ASC NULLS LAST)
    TABLESPACE pg_default;