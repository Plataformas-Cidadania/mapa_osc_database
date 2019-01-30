DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_caracteristicas CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_caracteristicas AS 

SELECT 
	COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1), 'Sem informação')::TEXT AS localidade,
	COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação')::TEXT AS nome_localidade,
	'regiao' AS tipo_localidade,
	COUNT(tb_osc) AS quantidade_oscs,
	COALESCE(SUM(
		COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) + 
		COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) + 
		COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0) + 
		COALESCE(tb_relacoes_trabalho_outra.nr_trabalhadores, 0)
	), 0) AS quantidade_trabalhadores,
	COALESCE(SUM(
		COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0) +
		COALESCE(tb_recursos_outro_osc.nr_valor_recursos_outro_osc, 0)
	), 0) AS quantidade_recursos,
	COUNT(tb_projeto) AS quantidade_projetos,
	REPLACE(('{' || TRIM(TRANSLATE(
		(
		    SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
			ARRAY_CAT(
			    ARRAY_CAT(
				ARRAY_CAT(
				    ARRAY_CAT(
					ARRAY_CAT(
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
					    ),
					    ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho_outra.ft_trabalhadores, ''))
					),
					ARRAY_AGG(DISTINCT COALESCE(tb_recursos_osc.ft_valor_recursos_osc, ''))
				    ),
				    ARRAY_AGG(DISTINCT COALESCE(tb_recursos_outro_osc.ft_valor_recursos_outro_osc, ''))
				),
				ARRAY_AGG(DISTINCT COALESCE(tb_projeto.ft_nome_projeto, ''))
			    ),
			    ARRAY_AGG(DISTINCT COALESCE(tb_projeto.ft_identificador_projeto_externo, ''))
			)
		    )) AS a
		)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM osc.tb_osc
LEFT JOIN osc.tb_relacoes_trabalho
ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
LEFT JOIN osc.tb_relacoes_trabalho_outra
ON tb_osc.id_osc = tb_relacoes_trabalho_outra.id_osc
LEFT JOIN osc.tb_recursos_osc
ON tb_osc.id_osc = tb_recursos_osc.id_osc
LEFT JOIN osc.tb_recursos_outro_osc
ON tb_osc.id_osc = tb_recursos_outro_osc.id_osc
LEFT JOIN osc.tb_projeto
ON tb_osc.id_osc = tb_projeto.id_osc
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
LEFT JOIN spat.ed_regiao
ON edre_cd_regiao = SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1)::NUMERIC
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY localidade, nome_localidade

UNION

SELECT
	COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2), 'Sem informação')::TEXT AS localidade,
	COALESCE(ed_uf.eduf_nm_uf, 'Sem informação')::TEXT AS nome_localidade,
	'estado' AS tipo_localidade,
	COUNT(tb_osc) AS nr_quantidade_oscs,
	COALESCE(SUM(
		COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) + 
		COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) + 
		COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0) + 
		COALESCE(tb_relacoes_trabalho_outra.nr_trabalhadores, 0)
	), 0) AS nr_quantidade_trabalhadores,
	COALESCE(SUM(
		COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0) +
		COALESCE(tb_recursos_outro_osc.nr_valor_recursos_outro_osc, 0)
	), 0) AS nr_quantidade_recursos,
	COUNT(tb_projeto) AS nr_quantidade_projetos,
	REPLACE(('{' || TRIM(TRANSLATE(
		(
		    SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
			ARRAY_CAT(
			    ARRAY_CAT(
				ARRAY_CAT(
				    ARRAY_CAT(
					ARRAY_CAT(
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
					    ),
					    ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho_outra.ft_trabalhadores, ''))
					),
					ARRAY_AGG(DISTINCT COALESCE(tb_recursos_osc.ft_valor_recursos_osc, ''))
				    ),
				    ARRAY_AGG(DISTINCT COALESCE(tb_recursos_outro_osc.ft_valor_recursos_outro_osc, ''))
				),
				ARRAY_AGG(DISTINCT COALESCE(tb_projeto.ft_nome_projeto, ''))
			    ),
			    ARRAY_AGG(DISTINCT COALESCE(tb_projeto.ft_identificador_projeto_externo, ''))
			)
		    )) AS a
		)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes_caracteristicas
FROM osc.tb_osc
LEFT JOIN osc.tb_relacoes_trabalho
ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
LEFT JOIN osc.tb_relacoes_trabalho_outra
ON tb_osc.id_osc = tb_relacoes_trabalho_outra.id_osc
LEFT JOIN osc.tb_recursos_osc
ON tb_osc.id_osc = tb_recursos_osc.id_osc
LEFT JOIN osc.tb_recursos_outro_osc
ON tb_osc.id_osc = tb_recursos_outro_osc.id_osc
LEFT JOIN osc.tb_projeto
ON tb_osc.id_osc = tb_projeto.id_osc
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
LEFT JOIN spat.ed_uf
ON eduf_cd_uf = SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2)::NUMERIC
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY localidade, nome_localidade

UNION

SELECT 
	COALESCE(tb_localizacao.cd_municipio::TEXT, 'Sem informação')::TEXT AS localidade,
	COALESCE(ed_municipio.edmu_nm_municipio || ' - ' || ed_uf.eduf_sg_uf, 'Sem informação')::TEXT AS nome_localidade,
	'municipio' AS tipo_localidade,
	COUNT(tb_osc) AS nr_quantidade_oscs,
	COALESCE(SUM(
		COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) + 
		COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) + 
		COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0) + 
		COALESCE(tb_relacoes_trabalho_outra.nr_trabalhadores, 0)
	), 0) AS nr_quantidade_trabalhadores,
	COALESCE(SUM(
		COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0) +
		COALESCE(tb_recursos_outro_osc.nr_valor_recursos_outro_osc, 0)
	), 0) AS nr_quantidade_recursos,
	COUNT(tb_projeto) AS nr_quantidade_projetos,
	REPLACE(('{' || TRIM(TRANSLATE(
		(
		    SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
			ARRAY_CAT(
			    ARRAY_CAT(
				ARRAY_CAT(
				    ARRAY_CAT(
					ARRAY_CAT(
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
					    ),
					    ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho_outra.ft_trabalhadores, ''))
					),
					ARRAY_AGG(DISTINCT COALESCE(tb_recursos_osc.ft_valor_recursos_osc, ''))
				    ),
				    ARRAY_AGG(DISTINCT COALESCE(tb_recursos_outro_osc.ft_valor_recursos_outro_osc, ''))
				),
				ARRAY_AGG(DISTINCT COALESCE(tb_projeto.ft_nome_projeto, ''))
			    ),
			    ARRAY_AGG(DISTINCT COALESCE(tb_projeto.ft_identificador_projeto_externo, ''))
			)
		    )) AS a
		)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes_caracteristicas
FROM osc.tb_osc
LEFT JOIN osc.tb_relacoes_trabalho
ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
LEFT JOIN osc.tb_relacoes_trabalho_outra
ON tb_osc.id_osc = tb_relacoes_trabalho_outra.id_osc
LEFT JOIN osc.tb_recursos_osc
ON tb_osc.id_osc = tb_recursos_osc.id_osc
LEFT JOIN osc.tb_recursos_outro_osc
ON tb_osc.id_osc = tb_recursos_outro_osc.id_osc
LEFT JOIN osc.tb_projeto
ON tb_osc.id_osc = tb_projeto.id_osc
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
LEFT JOIN spat.ed_municipio
ON edmu_cd_municipio = tb_localizacao.cd_municipio
LEFT JOIN spat.ed_uf
ON ed_uf.eduf_cd_uf = SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2)::NUMERIC
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY localidade, nome_localidade;

CREATE INDEX ix_localidade_vw_perfil_localidade_caracteristicas
    ON analysis.vw_perfil_localidade_caracteristicas USING btree
    (localidade ASC NULLS LAST)
    TABLESPACE pg_default;