DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_caracteristicas CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_caracteristicas AS 

SELECT 
	quantidade_osc.localidade,
	quantidade_osc.nome_localidade,
	'regiao' AS tipo_localidade,
	quantidade_osc.nr_quantidade_osc,
	quantidade_osc.ft_quantidade_osc,
	quantidade_trabalhadores.nr_quantidade_trabalhadores,
	quantidade_trabalhadores.ft_quantidade_trabalhadores,
	quantidade_recursos.nr_quantidade_recursos,
	quantidade_recursos.ft_quantidade_recursos,
	quantidade_projetos.nr_quantidade_projetos,
	quantidade_projetos.ft_quantidade_projetos,
	orcamento.nr_orcamento_empenhado,
	orcamento.ft_orcamento_empenhado
FROM (
	SELECT
		COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1), 'Sem informação')::TEXT AS localidade,
		COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação')::TEXT AS nome_localidade,
		COUNT(DISTINCT tb_osc.id_osc) AS nr_quantidade_osc,
		(
			REPLACE(('{' || TRIM(TRANSLATE((
				SELECT ARRAY_AGG(TRANSLATE(b::TEXT, '()', '')) FROM (
					SELECT DISTINCT UNNEST(
						ARRAY_CAT(
							ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
							ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
						)
					) AS a
				) AS b
			)::TEXT, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[]
		) AS ft_quantidade_osc
	FROM osc.tb_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	LEFT JOIN spat.ed_regiao
	ON edre_cd_regiao = SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1)::NUMERIC
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade, nome_localidade
) AS quantidade_osc
LEFT JOIN (
	SELECT 
		COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1), 'Sem informação') AS localidade,
		SUM(
			COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) + 
			COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) +
			COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)
		) AS nr_quantidade_trabalhadores,
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
		, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS ft_quantidade_trabalhadores
	FROM osc.tb_osc
	LEFT JOIN osc.tb_relacoes_trabalho
	ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade
) AS quantidade_trabalhadores
ON quantidade_osc.localidade = quantidade_trabalhadores.localidade
LEFT JOIN (
	SELECT
		COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1), 'Sem informação')::TEXT AS localidade,
		COALESCE(SUM(
			COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0) +
			COALESCE(tb_recursos_outro_osc.nr_valor_recursos_outro_osc, 0)
		), 0) AS nr_quantidade_recursos,
		(
			REPLACE(('{' || TRIM(TRANSLATE((
				SELECT ARRAY_AGG(TRANSLATE(b::TEXT, '()', '')) FROM (
					SELECT DISTINCT UNNEST(
							ARRAY_CAT(
								ARRAY_AGG(DISTINCT COALESCE(tb_recursos_osc.ft_valor_recursos_osc, '')),
								ARRAY_AGG(DISTINCT COALESCE(tb_recursos_outro_osc.ft_valor_recursos_outro_osc, ''))
							)
						) AS a
				) AS b
			)::TEXT, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[]
		) AS ft_quantidade_recursos
	FROM osc.tb_osc
	LEFT JOIN osc.tb_recursos_osc
	ON tb_osc.id_osc = tb_recursos_osc.id_osc
	LEFT JOIN osc.tb_recursos_outro_osc
	ON tb_osc.id_osc = tb_recursos_outro_osc.id_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade
) AS quantidade_recursos
ON quantidade_osc.localidade = quantidade_recursos.localidade
LEFT JOIN (
	SELECT
		COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1), 'Sem informação')::TEXT AS localidade,
		COUNT(DISTINCT tb_projeto.id_projeto) AS nr_quantidade_projetos,
		(
			REPLACE(('{' || TRIM(TRANSLATE((
				SELECT ARRAY_AGG(TRANSLATE(b::TEXT, '()', '')) FROM (
					SELECT DISTINCT UNNEST(
						ARRAY_CAT(
							ARRAY_AGG(DISTINCT COALESCE(tb_projeto.ft_nome_projeto, '')),
							ARRAY_AGG(DISTINCT COALESCE(tb_projeto.ft_identificador_projeto_externo, ''))
						)
					) AS a
				) AS b
			)::TEXT, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[]
		) AS ft_quantidade_projetos
	FROM osc.tb_osc
	LEFT JOIN osc.tb_projeto
	ON tb_osc.id_osc = tb_projeto.id_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade
) AS quantidade_projetos
ON quantidade_osc.localidade = quantidade_projetos.localidade
LEFT JOIN (
	SELECT
		COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1), 'Sem informação')::TEXT AS localidade,
		SUM(tb_orcamento_def.nr_vl_empenhado_def) AS nr_orcamento_empenhado,
		'{"SIGA Brasil 2010-2018, Valores deflacionados para dez/2018, IPCA IBGE 2018"}'::TEXT[] AS ft_orcamento_empenhado
	FROM osc.tb_osc
	LEFT JOIN graph.tb_orcamento_def
	ON tb_osc.cd_identificador_osc = tb_orcamento_def.nr_orcamento_cnpj
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	LEFT JOIN spat.ed_regiao
	ON edre_cd_regiao = SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1)::NUMERIC
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade
) AS orcamento
ON quantidade_osc.localidade = orcamento.localidade

UNION

SELECT 
	quantidade_osc.localidade,
	quantidade_osc.nome_localidade,
	'estado' AS tipo_localidade,
	quantidade_osc.nr_quantidade_osc,
	quantidade_osc.ft_quantidade_osc,
	quantidade_trabalhadores.nr_quantidade_trabalhadores,
	quantidade_trabalhadores.ft_quantidade_trabalhadores,
	quantidade_recursos.nr_quantidade_recursos,
	quantidade_recursos.ft_quantidade_recursos,
	quantidade_projetos.nr_quantidade_projetos,
	quantidade_projetos.ft_quantidade_projetos,
	orcamento.nr_orcamento_empenhado,
	orcamento.ft_orcamento_empenhado
FROM (
	SELECT
		COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2), 'Sem informação')::TEXT AS localidade,
		COALESCE(ed_uf.eduf_nm_uf, 'Sem informação')::TEXT AS nome_localidade,
		COUNT(DISTINCT tb_osc.id_osc) AS nr_quantidade_osc,
		(
			REPLACE(('{' || TRIM(TRANSLATE((
				SELECT ARRAY_AGG(TRANSLATE(b::TEXT, '()', '')) FROM (
					SELECT DISTINCT UNNEST(
						ARRAY_CAT(
							ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
							ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
						)
					) AS a
				) AS b
			)::TEXT, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[]
		) AS ft_quantidade_osc
	FROM osc.tb_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	LEFT JOIN spat.ed_uf
	ON eduf_cd_uf = SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2)::NUMERIC
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade, nome_localidade
) AS quantidade_osc
LEFT JOIN (
	SELECT 
		COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2), 'Sem informação') AS localidade,
		SUM(
			COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) + 
			COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) +
			COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)
		) AS nr_quantidade_trabalhadores,
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
		, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS ft_quantidade_trabalhadores
	FROM osc.tb_osc
	LEFT JOIN osc.tb_relacoes_trabalho
	ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade
) AS quantidade_trabalhadores
ON quantidade_osc.localidade = quantidade_trabalhadores.localidade
LEFT JOIN (
	SELECT
		COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2), 'Sem informação')::TEXT AS localidade,
		COALESCE(SUM(
			COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0) +
			COALESCE(tb_recursos_outro_osc.nr_valor_recursos_outro_osc, 0)
		), 0) AS nr_quantidade_recursos,
		(
			REPLACE(('{' || TRIM(TRANSLATE((
				SELECT ARRAY_AGG(TRANSLATE(b::TEXT, '()', '')) FROM (
					SELECT DISTINCT UNNEST(
							ARRAY_CAT(
								ARRAY_AGG(DISTINCT COALESCE(tb_recursos_osc.ft_valor_recursos_osc, '')),
								ARRAY_AGG(DISTINCT COALESCE(tb_recursos_outro_osc.ft_valor_recursos_outro_osc, ''))
							)
						) AS a
				) AS b
			)::TEXT, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[]
		) AS ft_quantidade_recursos
	FROM osc.tb_osc
	LEFT JOIN osc.tb_recursos_osc
	ON tb_osc.id_osc = tb_recursos_osc.id_osc
	LEFT JOIN osc.tb_recursos_outro_osc
	ON tb_osc.id_osc = tb_recursos_outro_osc.id_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade
) AS quantidade_recursos
ON quantidade_osc.localidade = quantidade_recursos.localidade
LEFT JOIN (
	SELECT
		COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2), 'Sem informação')::TEXT AS localidade,
		COUNT(DISTINCT tb_projeto.id_projeto) AS nr_quantidade_projetos,
		(
			REPLACE(('{' || TRIM(TRANSLATE((
				SELECT ARRAY_AGG(TRANSLATE(b::TEXT, '()', '')) FROM (
					SELECT DISTINCT UNNEST(
						ARRAY_CAT(
							ARRAY_AGG(DISTINCT COALESCE(tb_projeto.ft_nome_projeto, '')),
							ARRAY_AGG(DISTINCT COALESCE(tb_projeto.ft_identificador_projeto_externo, ''))
						)
					) AS a
				) AS b
			)::TEXT, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[]
		) AS ft_quantidade_projetos
	FROM osc.tb_osc
	LEFT JOIN osc.tb_projeto
	ON tb_osc.id_osc = tb_projeto.id_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade
) AS quantidade_projetos
ON quantidade_osc.localidade = quantidade_projetos.localidade
LEFT JOIN (
	SELECT
		COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2), 'Sem informação')::TEXT AS localidade,
		SUM(tb_orcamento_def.nr_vl_empenhado_def) AS nr_orcamento_empenhado,
		'{"SIGA Brasil 2010-2018, Valores deflacionados para dez/2018, IPCA IBGE 2018"}'::TEXT[] AS ft_orcamento_empenhado
	FROM osc.tb_osc
	LEFT JOIN graph.tb_orcamento_def
	ON tb_osc.cd_identificador_osc = tb_orcamento_def.nr_orcamento_cnpj
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	LEFT JOIN spat.ed_regiao
	ON edre_cd_regiao = SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2)::NUMERIC
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade
) AS orcamento
ON quantidade_osc.localidade = orcamento.localidade

UNION

SELECT 
	quantidade_osc.localidade,
	quantidade_osc.nome_localidade,
	'municipio' AS tipo_localidade,
	quantidade_osc.nr_quantidade_osc,
	quantidade_osc.ft_quantidade_osc,
	quantidade_trabalhadores.nr_quantidade_trabalhadores,
	quantidade_trabalhadores.ft_quantidade_trabalhadores,
	quantidade_recursos.nr_quantidade_recursos,
	quantidade_recursos.ft_quantidade_recursos,
	quantidade_projetos.nr_quantidade_projetos,
	quantidade_projetos.ft_quantidade_projetos,
	orcamento.nr_orcamento_empenhado,
	orcamento.ft_orcamento_empenhado
FROM (
	SELECT
		COALESCE(tb_localizacao.cd_municipio::TEXT, 'Sem informação')::TEXT AS localidade,
		COALESCE(ed_municipio.edmu_nm_municipio || ' - ' || ed_uf.eduf_sg_uf, 'Sem informação')::TEXT AS nome_localidade,
		COUNT(DISTINCT tb_osc.id_osc) AS nr_quantidade_osc,
		(
			REPLACE(('{' || TRIM(TRANSLATE((
				SELECT ARRAY_AGG(TRANSLATE(b::TEXT, '()', '')) FROM (
					SELECT DISTINCT UNNEST(
						ARRAY_CAT(
							ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
							ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
						)
					) AS a
				) AS b
			)::TEXT, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[]
		) AS ft_quantidade_osc
	FROM osc.tb_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	LEFT JOIN spat.ed_municipio
	ON ed_municipio.edmu_cd_municipio = tb_localizacao.cd_municipio::NUMERIC
	LEFT JOIN spat.ed_uf
	ON ed_uf.eduf_cd_uf = ed_municipio.eduf_cd_uf
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade, nome_localidade
) AS quantidade_osc
LEFT JOIN (
	SELECT 
		COALESCE(tb_localizacao.cd_municipio::TEXT, 'Sem informação')::TEXT AS localidade,
		SUM(
			COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) + 
			COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) +
			COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)
		) AS nr_quantidade_trabalhadores,
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
		, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS ft_quantidade_trabalhadores
	FROM osc.tb_osc
	LEFT JOIN osc.tb_relacoes_trabalho
	ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade
) AS quantidade_trabalhadores
ON quantidade_osc.localidade = quantidade_trabalhadores.localidade
LEFT JOIN (
	SELECT
		COALESCE(tb_localizacao.cd_municipio::TEXT, 'Sem informação')::TEXT AS localidade,
		COALESCE(SUM(
			COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0) +
			COALESCE(tb_recursos_outro_osc.nr_valor_recursos_outro_osc, 0)
		), 0) AS nr_quantidade_recursos,
		(
			REPLACE(('{' || TRIM(TRANSLATE((
				SELECT ARRAY_AGG(TRANSLATE(b::TEXT, '()', '')) FROM (
					SELECT DISTINCT UNNEST(
							ARRAY_CAT(
								ARRAY_AGG(DISTINCT COALESCE(tb_recursos_osc.ft_valor_recursos_osc, '')),
								ARRAY_AGG(DISTINCT COALESCE(tb_recursos_outro_osc.ft_valor_recursos_outro_osc, ''))
							)
						) AS a
				) AS b
			)::TEXT, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[]
		) AS ft_quantidade_recursos
	FROM osc.tb_osc
	LEFT JOIN osc.tb_recursos_osc
	ON tb_osc.id_osc = tb_recursos_osc.id_osc
	LEFT JOIN osc.tb_recursos_outro_osc
	ON tb_osc.id_osc = tb_recursos_outro_osc.id_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade
) AS quantidade_recursos
ON quantidade_osc.localidade = quantidade_recursos.localidade
LEFT JOIN (
	SELECT
		COALESCE(tb_localizacao.cd_municipio::TEXT, 'Sem informação')::TEXT AS localidade,
		COUNT(DISTINCT tb_projeto.id_projeto) AS nr_quantidade_projetos,
		(
			REPLACE(('{' || TRIM(TRANSLATE((
				SELECT ARRAY_AGG(TRANSLATE(b::TEXT, '()', '')) FROM (
					SELECT DISTINCT UNNEST(
						ARRAY_CAT(
							ARRAY_AGG(DISTINCT COALESCE(tb_projeto.ft_nome_projeto, '')),
							ARRAY_AGG(DISTINCT COALESCE(tb_projeto.ft_identificador_projeto_externo, ''))
						)
					) AS a
				) AS b
			)::TEXT, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[]
		) AS ft_quantidade_projetos
	FROM osc.tb_osc
	LEFT JOIN osc.tb_projeto
	ON tb_osc.id_osc = tb_projeto.id_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade
) AS quantidade_projetos
ON quantidade_osc.localidade = quantidade_projetos.localidade
LEFT JOIN (
	SELECT
		COALESCE(tb_localizacao.cd_municipio::TEXT, 'Sem informação')::TEXT AS localidade,
		SUM(tb_orcamento_def.nr_vl_empenhado_def) AS nr_orcamento_empenhado,
		'{"SIGA Brasil 2010-2018, Valores deflacionados para dez/2018, IPCA IBGE 2018"}'::TEXT[] AS ft_orcamento_empenhado
	FROM osc.tb_osc
	LEFT JOIN graph.tb_orcamento_def
	ON tb_osc.cd_identificador_osc = tb_orcamento_def.nr_orcamento_cnpj
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	LEFT JOIN spat.ed_regiao
	ON edre_cd_regiao = SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2)::NUMERIC
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade
) AS orcamento
ON quantidade_osc.localidade = orcamento.localidade;

CREATE INDEX ix_localidade_vw_perfil_localidade_caracteristicas
    ON analysis.vw_perfil_localidade_caracteristicas USING btree
    (localidade ASC NULLS LAST)
    TABLESPACE pg_default;