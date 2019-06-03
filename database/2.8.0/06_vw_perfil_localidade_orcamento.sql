DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_orcamento CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_orcamento AS 

SELECT
	COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1), 'Sem informação')::TEXT AS localidade,
	COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação')::TEXT AS nome_localidade,
	tb_orcamento_def.nr_orcamento_ano AS ano,
	SUM(tb_orcamento_def.nr_vl_empenhado_def) AS empenhado,
	'{"SIGABR"}'::TEXT[] AS fontes
FROM graph.tb_orcamento_def
LEFT JOIN osc.tb_osc
ON tb_orcamento_def.nr_orcamento_cnpj = tb_osc.cd_identificador_osc
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
LEFT JOIN spat.ed_regiao
ON edre_cd_regiao = SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1)::NUMERIC
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY localidade, nome_localidade, nr_orcamento_ano

UNION

SELECT
	COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2), 'Sem informação')::TEXT AS localidade,
	COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação')::TEXT AS nome_localidade,
	tb_orcamento_def.nr_orcamento_ano AS ano,
	SUM(tb_orcamento_def.nr_vl_empenhado_def) AS empenhado,
	'{"SIGABR"}'::TEXT[] AS fontes
FROM graph.tb_orcamento_def
LEFT JOIN osc.tb_osc
ON tb_orcamento_def.nr_orcamento_cnpj = tb_osc.cd_identificador_osc
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
LEFT JOIN spat.ed_regiao
ON edre_cd_regiao = SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1)::NUMERIC
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY localidade, nome_localidade, nr_orcamento_ano

UNION

SELECT
	COALESCE(tb_localizacao.cd_municipio::TEXT, 'Sem informação')::TEXT AS localidade,
	COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação')::TEXT AS nome_localidade,
	tb_orcamento_def.nr_orcamento_ano AS ano,
	SUM(tb_orcamento_def.nr_vl_empenhado_def) AS empenhado,
	'{"SIGABR"}'::TEXT[] AS fontes
FROM graph.tb_orcamento_def
LEFT JOIN osc.tb_osc
ON tb_orcamento_def.nr_orcamento_cnpj = tb_osc.cd_identificador_osc
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
LEFT JOIN spat.ed_regiao
ON edre_cd_regiao = SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1)::NUMERIC
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY localidade, nome_localidade, nr_orcamento_ano;

CREATE INDEX ix_vw_perfil_localidade_orcamento
    ON analysis.vw_perfil_localidade_orcamento USING btree
    (localidade ASC NULLS LAST)
    TABLESPACE pg_default;