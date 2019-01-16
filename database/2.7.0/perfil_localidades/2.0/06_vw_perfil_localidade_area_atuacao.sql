DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_area_atuacao CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_area_atuacao AS 

SELECT 
	COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1), 'Sem informação') AS localidade,
	COALESCE(dc_area_atuacao.tx_nome_area_atuacao::TEXT, 'Sem informação') AS area_atuacao,
	COUNT(tb_osc) AS nr_quantidade_oscs,
	('{' || TRIM(TRANSLATE(
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
	, '"\{}', ''), ',') || '}')::TEXT[] AS fontes_caracteristicas
FROM osc.tb_osc
LEFT JOIN osc.tb_area_atuacao
ON tb_osc.id_osc = tb_area_atuacao.id_osc
LEFT JOIN syst.dc_area_atuacao
ON tb_area_atuacao.cd_area_atuacao = dc_area_atuacao.cd_area_atuacao
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
GROUP BY localidade, area_atuacao

UNION

SELECT 
	COALESCE(SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2), 'Sem informação') AS localidade,
	COALESCE(dc_area_atuacao.tx_nome_area_atuacao::TEXT, 'Sem informação') AS area_atuacao,
	COUNT(tb_osc) AS nr_quantidade_oscs,
	('{' || TRIM(TRANSLATE(
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
	, '"\{}', ''), ',') || '}')::TEXT[] AS fontes_caracteristicas
FROM osc.tb_osc
LEFT JOIN osc.tb_area_atuacao
ON tb_osc.id_osc = tb_area_atuacao.id_osc
LEFT JOIN syst.dc_area_atuacao
ON tb_area_atuacao.cd_area_atuacao = dc_area_atuacao.cd_area_atuacao
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
GROUP BY localidade, area_atuacao

UNION

SELECT 
	COALESCE(tb_localizacao.cd_municipio::TEXT, 'Sem informação') AS localidade,
	COALESCE(dc_area_atuacao.tx_nome_area_atuacao::TEXT, 'Sem informação') AS area_atuacao,
	COUNT(tb_osc) AS nr_quantidade_oscs,
	('{' || TRIM(TRANSLATE(
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
	, '"\{}', ''), ',') || '}')::TEXT[] AS fontes_caracteristicas
FROM osc.tb_osc
LEFT JOIN osc.tb_area_atuacao
ON tb_osc.id_osc = tb_area_atuacao.id_osc
LEFT JOIN syst.dc_area_atuacao
ON tb_area_atuacao.cd_area_atuacao = dc_area_atuacao.cd_area_atuacao
LEFT JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
AND tb_osc.id_osc <> 789809
GROUP BY localidade, area_atuacao;