DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_media_nacional CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_media_nacional AS 

SELECT
	'maior_natureza_juridica'::TEXT AS tipo_dado,
	ARRAY_AGG(a.natureza_juridica) AS dado,
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
	'maior_repasse_recursos'::TEXT AS tipo_dado,
	ARRAY_AGG(a.fonte_recursos) AS dado,
	(
		MAX(a.valor_recursos)
		/ (SELECT SUM(valor_recursos) FROM analysis.vw_perfil_localidade_repasse_recursos AS c)
		* 100
	) AS maior_porcentagem
FROM (
	SELECT 
		fonte_recursos,
		SUM(valor_recursos) AS valor_recursos
	FROM analysis.vw_perfil_localidade_repasse_recursos
	GROUP BY fonte_recursos
) AS a
INNER JOIN (
	SELECT SUM(valor_recursos)::DOUBLE PRECISION AS valor_recursos
	FROM analysis.vw_perfil_localidade_repasse_recursos AS a
	GROUP BY fonte_recursos
	ORDER BY SUM(valor_recursos) DESC
	LIMIT 1
) AS b
ON a.valor_recursos = b.valor_recursos

UNION

SELECT
	'maior_area_atuacao'::TEXT AS tipo_dado,
	ARRAY_AGG(a.area_atuacao) AS dado,
	(
		MAX(a.quantidade_osc)
		/ (SELECT SUM(quantidade_oscs) FROM analysis.vw_perfil_localidade_area_atuacao AS c)
		* 100
	) AS maior_porcentagem
FROM (
	SELECT 
		area_atuacao,
		SUM(quantidade_oscs) AS quantidade_osc
	FROM analysis.vw_perfil_localidade_area_atuacao
	GROUP BY area_atuacao
) AS a
INNER JOIN (
	SELECT SUM(quantidade_oscs)::DOUBLE PRECISION AS quantidade_osc
	FROM analysis.vw_perfil_localidade_area_atuacao AS a
	GROUP BY area_atuacao
	ORDER BY quantidade_osc DESC
	LIMIT 1
) AS b
ON a.quantidade_osc = b.quantidade_osc

UNION

SELECT
	'maior_trabalhadores'::TEXT AS tipo_dado,
	ARRAY_AGG(tipo_trabalhadores) AS dado,
	(
		MAX(quantidade_trabalhadores) / MAX(total) * 100
	) AS porcentagem_maior_trabalhadores
FROM (
	SELECT
		'Trabalhadores com vínculos'::TEXT AS tipo_trabalhadores,
		SUM(total) AS total,
		SUM(vinculos)::DOUBLE PRECISION AS quantidade_trabalhadores
	FROM analysis.vw_perfil_localidade_trabalhadores

	UNION

	SELECT
		'Trabalhadores com deficiência'::TEXT AS tipo_trabalhadores,
		SUM(total) AS total,
		SUM(deficiencia)::DOUBLE PRECISION AS quantidade_trabalhadores
	FROM analysis.vw_perfil_localidade_trabalhadores

	UNION

	SELECT
		'Trabalhadores voluntários'::TEXT AS tipo_trabalhadores,
		SUM(total) AS total,
		SUM(voluntarios)::DOUBLE PRECISION AS quantidade_trabalhadores
	FROM analysis.vw_perfil_localidade_trabalhadores
) AS a
WHERE quantidade_trabalhadores IN (
	(
		SELECT
			SUM(vinculos)::DOUBLE PRECISION AS porcentagem_maior_trabalhadores
		FROM analysis.vw_perfil_localidade_trabalhadores

		UNION

		SELECT
			SUM(deficiencia)::DOUBLE PRECISION AS porcentagem_maior_trabalhadores
		FROM analysis.vw_perfil_localidade_trabalhadores

		UNION

		SELECT
			SUM(voluntarios)::DOUBLE PRECISION AS porcentagem_maior_trabalhadores
		FROM analysis.vw_perfil_localidade_trabalhadores
	)
	ORDER BY porcentagem_maior_trabalhadores DESC
	LIMIT 1
);