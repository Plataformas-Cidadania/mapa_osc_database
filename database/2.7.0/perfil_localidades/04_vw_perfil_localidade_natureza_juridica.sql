DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_natureza_juridica CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_natureza_juridica AS 

SELECT 
	SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1) AS localidade,
	COALESCE(dc_natureza_juridica.tx_nome_natureza_juridica::TEXT, 'Sem informação') AS natureza_juridica,
	COUNT(DISTINCT tb_osc.id_osc) AS quantidade_oscs,
	REPLACE(('{' || TRIM(TRANSLATE(
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
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM osc.tb_osc
LEFT JOIN osc.tb_dados_gerais
ON tb_osc.id_osc = tb_dados_gerais.id_osc
LEFT JOIN syst.dc_natureza_juridica
ON tb_dados_gerais.cd_natureza_juridica_osc = dc_natureza_juridica.cd_natureza_juridica
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY localidade, natureza_juridica

UNION

SELECT 
	SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2) AS localidade,
	COALESCE(dc_natureza_juridica.tx_nome_natureza_juridica::TEXT, 'Sem informação') AS natureza_juridica,
	COUNT(DISTINCT tb_osc.id_osc) AS quantidade_oscs,
	REPLACE(('{' || TRIM(TRANSLATE(
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
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM osc.tb_osc
LEFT JOIN osc.tb_dados_gerais
ON tb_osc.id_osc = tb_dados_gerais.id_osc
LEFT JOIN syst.dc_natureza_juridica
ON tb_dados_gerais.cd_natureza_juridica_osc = dc_natureza_juridica.cd_natureza_juridica
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY localidade, natureza_juridica

UNION

SELECT 
	tb_localizacao.cd_municipio::TEXT AS localidade,
	COALESCE(dc_natureza_juridica.tx_nome_natureza_juridica::TEXT, 'Sem informação') AS natureza_juridica,
	COUNT(DISTINCT tb_osc.id_osc) AS quantidade_oscs,
	REPLACE(('{' || TRIM(TRANSLATE(
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
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM osc.tb_osc
LEFT JOIN osc.tb_dados_gerais
ON tb_osc.id_osc = tb_dados_gerais.id_osc
LEFT JOIN syst.dc_natureza_juridica
ON tb_dados_gerais.cd_natureza_juridica_osc = dc_natureza_juridica.cd_natureza_juridica
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY localidade, natureza_juridica;

CREATE INDEX ix_localidade_vw_perfil_localidade_natureza_juridica
    ON analysis.vw_perfil_localidade_natureza_juridica USING btree
    (localidade ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX ix_natureza_juridica_vw_perfil_localidade_natureza_juridica
    ON analysis.vw_perfil_localidade_natureza_juridica USING btree
    (natureza_juridica ASC NULLS LAST)
    TABLESPACE pg_default;