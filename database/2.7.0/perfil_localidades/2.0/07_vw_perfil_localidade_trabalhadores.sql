DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_trabalhadores CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_trabalhadores AS 

SELECT 
	COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1), 'Sem informação') AS localidade,
	SUM(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0)) AS vinculos,
	SUM(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0)) AS deficiencia,
	SUM(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)) AS voluntarios,
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
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes_caracteristicas
FROM osc.tb_osc
LEFT JOIN osc.tb_relacoes_trabalho
ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
GROUP BY localidade

UNION

SELECT 
	COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2), 'Sem informação') AS localidade,
	SUM(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0)) AS vinculos,
	SUM(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0)) AS deficiencia,
	SUM(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)) AS voluntarios,
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
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes_caracteristicas
FROM osc.tb_osc
LEFT JOIN osc.tb_relacoes_trabalho
ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
GROUP BY localidade

UNION

SELECT 
	COALESCE(tb_localizacao.cd_municipio::TEXT, 'Sem informação') AS localidade,
	SUM(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0)) AS vinculos,
	SUM(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0)) AS deficiencia,
	SUM(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)) AS voluntarios,
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
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes_caracteristicas
FROM osc.tb_osc
LEFT JOIN osc.tb_relacoes_trabalho
ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
GROUP BY localidade;