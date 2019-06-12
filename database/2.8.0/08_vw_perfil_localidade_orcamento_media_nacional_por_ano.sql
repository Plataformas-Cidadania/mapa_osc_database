DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_orcamento_media_nacional_por_ano CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_orcamento_media_nacional_por_ano AS 

SELECT
	'Região' AS tipo_localidade,
	ano AS ano,
	(SUM(empenhado) / COUNT(*)) AS media,
	COUNT(*) AS quantidade_localidades
FROM analysis.vw_perfil_localidade_orcamento
WHERE localidade BETWEEN 0 AND 9
GROUP BY ano

UNION

SELECT
	'Estado' AS tipo_localidade,
	ano AS ano,
	(SUM(empenhado) / COUNT(*)) AS media,
	COUNT(*) AS quantidade_localidades
FROM analysis.vw_perfil_localidade_orcamento
WHERE localidade BETWEEN 10 AND 99
GROUP BY ano

UNION

SELECT
	'Município' AS tipo_localidade,
	ano AS ano,
	(SUM(empenhado) / COUNT(*)) AS media,
	COUNT(*) AS quantidade_localidades
FROM analysis.vw_perfil_localidade_orcamento
WHERE localidade > 99
GROUP BY ano;