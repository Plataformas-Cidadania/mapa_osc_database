DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_orcamento_media_nacional CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_orcamento_media_nacional AS 

SELECT
	'Região' AS tipo_localidade,
	(SUM(empenhado) / COUNT(*)) AS media,
	COUNT(*) AS quantidade_localidades
FROM (
	SELECT
		SUM(empenhado) AS empenhado,
		localidade
	FROM analysis.vw_perfil_localidade_orcamento
	WHERE localidade BETWEEN 0 AND 9
	GROUP BY localidade
) AS a

UNION

SELECT
	'Estado' AS tipo_localidade,
	(SUM(empenhado) / COUNT(*)) AS media,
	COUNT(*) AS quantidade_localidades
FROM (
	SELECT
		SUM(empenhado) AS empenhado,
		localidade
	FROM analysis.vw_perfil_localidade_orcamento
	WHERE localidade BETWEEN 10 AND 99
	GROUP BY localidade
) AS a

UNION

SELECT
	'Município' AS tipo_localidade,
	(SUM(empenhado) / COUNT(*)) AS media,
	COUNT(*) AS quantidade_localidades
FROM (
	SELECT
		SUM(empenhado) AS empenhado,
		localidade
	FROM analysis.vw_perfil_localidade_orcamento
	WHERE localidade > 99
	GROUP BY localidade
) AS a;