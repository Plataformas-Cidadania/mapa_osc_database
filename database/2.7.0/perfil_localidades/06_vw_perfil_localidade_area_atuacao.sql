DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_area_atuacao CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_area_atuacao AS 

SELECT 
	SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1) AS localidade,
	COALESCE(dc_area_atuacao.tx_nome_area_atuacao::TEXT, 'Sem informação') AS area_atuacao,
	COUNT(DISTINCT tb_osc.id_osc) AS quantidade_oscs,
	REPLACE(('{' || TRIM(TRANSLATE(
		(
		    SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
			ARRAY_CAT(
				ARRAY_CAT(
					ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
					ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
				),
				ARRAY_AGG(DISTINCT COALESCE(tb_area_atuacao.ft_area_atuacao, ''))
			)
		    )) AS a
		)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM osc.tb_osc
LEFT JOIN osc.tb_area_atuacao
ON tb_osc.id_osc = tb_area_atuacao.id_osc
LEFT JOIN syst.dc_area_atuacao
ON tb_area_atuacao.cd_area_atuacao = dc_area_atuacao.cd_area_atuacao
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY localidade, area_atuacao

UNION

SELECT 
	SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2) AS localidade,
	COALESCE(dc_area_atuacao.tx_nome_area_atuacao::TEXT, 'Sem informação') AS area_atuacao,
	COUNT(DISTINCT tb_osc.id_osc) AS quantidade_oscs,
	REPLACE(('{' || TRIM(TRANSLATE(
		(
		    SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
			ARRAY_CAT(
				ARRAY_CAT(
					ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
					ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
				),
				ARRAY_AGG(DISTINCT COALESCE(tb_area_atuacao.ft_area_atuacao, ''))
			)
		    )) AS a
		)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM osc.tb_osc
LEFT JOIN osc.tb_area_atuacao
ON tb_osc.id_osc = tb_area_atuacao.id_osc
LEFT JOIN syst.dc_area_atuacao
ON tb_area_atuacao.cd_area_atuacao = dc_area_atuacao.cd_area_atuacao
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY localidade, area_atuacao

UNION

SELECT 
	tb_localizacao.cd_municipio::TEXT AS localidade,
	COALESCE(dc_area_atuacao.tx_nome_area_atuacao::TEXT, 'Sem informação') AS area_atuacao,
	COUNT(DISTINCT tb_osc.id_osc) AS quantidade_oscs,
	REPLACE(('{' || TRIM(TRANSLATE(
		(
		    SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
			ARRAY_CAT(
				ARRAY_CAT(
					ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
					ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
				),
				ARRAY_AGG(DISTINCT COALESCE(tb_area_atuacao.ft_area_atuacao, ''))
			)
		    )) AS a
		)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM osc.tb_osc
LEFT JOIN osc.tb_area_atuacao
ON tb_osc.id_osc = tb_area_atuacao.id_osc
LEFT JOIN syst.dc_area_atuacao
ON tb_area_atuacao.cd_area_atuacao = dc_area_atuacao.cd_area_atuacao
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY localidade, area_atuacao;

CREATE INDEX ix_localidade_vw_perfil_localidade_area_atuacao
    ON analysis.vw_perfil_localidade_area_atuacao USING btree
    (localidade ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX ix_area_atuacao_vw_perfil_localidade_area_atuacao
    ON analysis.vw_perfil_localidade_area_atuacao USING btree
    (area_atuacao ASC NULLS LAST)
    TABLESPACE pg_default;