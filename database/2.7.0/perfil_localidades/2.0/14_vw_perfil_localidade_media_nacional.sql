DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_media_nacional CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_media_nacional AS 

SELECT
	'natureza_juridica'::TEXT AS tipo_media,
	ARRAY_AGG(a.natureza_juridica) AS maior_natureza_juridica,
	(
		MAX(a.quantidade_osc)
		/ (SELECT SUM(quantidade_oscs) FROM analysis.vw_perfil_localidade_natureza_juridica AS c)
		* 100
	) AS maior_porcentagem
FROM (
	SELECT 
		natureza_juridica,
		SUM(quantidade_oscs) AS quantidade_osc
	FROM analysis.vw_perfil_localidade_natureza_juridica
	GROUP BY natureza_juridica
) AS a
INNER JOIN (
	SELECT SUM(quantidade_oscs)::DOUBLE PRECISION AS quantidade_osc
	FROM analysis.vw_perfil_localidade_natureza_juridica AS a
	GROUP BY natureza_juridica
	ORDER BY quantidade_osc DESC
	LIMIT 1
) AS b
ON a.quantidade_osc = b.quantidade_osc

UNION

SELECT
	'repasse_recursos'::TEXT AS tipo_media,
	ARRAY_AGG(a.natureza_juridica) AS maior_natureza_juridica,
	(
		MAX(a.quantidade_osc)
		/ (SELECT SUM(quantidade_oscs) FROM analysis.vw_perfil_localidade_natureza_juridica AS c)
		* 100
	) AS maior_porcentagem
FROM (
	SELECT 
		natureza_juridica,
		SUM(quantidade_oscs) AS quantidade_osc
	FROM analysis.vw_perfil_localidade_natureza_juridica
	GROUP BY natureza_juridica
) AS a
INNER JOIN (
	SELECT SUM(quantidade_oscs)::DOUBLE PRECISION AS quantidade_osc
	FROM analysis.vw_perfil_localidade_natureza_juridica AS a
	GROUP BY natureza_juridica
	ORDER BY quantidade_osc DESC
	LIMIT 1
) AS b
ON a.quantidade_osc = b.quantidade_osc
;