DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_natureza_juridica CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_natureza_juridica AS 

SELECT 
	COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1), 'Sem informação') AS localidade,
	COALESCE(dc_natureza_juridica.tx_nome_natureza_juridica::TEXT, 'Sem informação') AS natureza_juridica,
	COUNT(tb_osc) AS quantidade_oscs,
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
GROUP BY localidade, natureza_juridica

UNION

SELECT 
	COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2), 'Sem informação') AS localidade,
	COALESCE(dc_natureza_juridica.tx_nome_natureza_juridica::TEXT, 'Sem informação') AS natureza_juridica,
	COUNT(tb_osc) AS nr_quantidade_oscs,
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
GROUP BY localidade, natureza_juridica

UNION

SELECT 
	COALESCE(tb_localizacao.cd_municipio::TEXT, 'Sem informação') AS localidade,
	COALESCE(dc_natureza_juridica.tx_nome_natureza_juridica::TEXT, 'Sem informação') AS natureza_juridica,
	COUNT(tb_osc) AS nr_quantidade_oscs,
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
GROUP BY localidade, natureza_juridica;