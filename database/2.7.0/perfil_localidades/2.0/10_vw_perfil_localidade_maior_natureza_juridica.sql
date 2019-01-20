DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_maior_natureza_juridica CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_maior_natureza_juridica AS 

SELECT
	localidade,
	ARRAY_AGG(natureza_juridica),
	(
		quantidade_oscs::DOUBLE PRECISION / 
		(SELECT SUM(quantidade_oscs) FROM analysis.vw_perfil_localidade_natureza_juridica WHERE localidade = a.localidade)::DOUBLE PRECISION 
		* 100
	) AS porcertagem_maior,
	REPLACE(('{' || TRIM(TRANSLATE(
		ARRAY_AGG(fontes_caracteristicas::TEXT)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM analysis.vw_perfil_localidade_natureza_juridica AS a
WHERE a.quantidade_oscs IN (
	SELECT MAX(quantidade_oscs)
	FROM analysis.vw_perfil_localidade_natureza_juridica
	WHERE (
		CASE 
			WHEN SUBSTRING(localidade FROM '[0-9]*') = '' THEN '0'
			ELSE SUBSTRING(localidade FROM '[0-9]*')
		END
	)::INTEGER BETWEEN 1 AND 9
	GROUP BY localidade
)
GROUP BY localidade, natureza_juridica, quantidade_oscs

UNION

SELECT
	localidade,
	ARRAY_AGG(natureza_juridica),
	(
		quantidade_oscs::DOUBLE PRECISION / 
		(SELECT SUM(quantidade_oscs) FROM analysis.vw_perfil_localidade_natureza_juridica WHERE localidade = a.localidade)::DOUBLE PRECISION 
		* 100
	) AS porcertagem_maior,
	REPLACE(('{' || TRIM(TRANSLATE(
		ARRAY_AGG(fontes_caracteristicas::TEXT)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM analysis.vw_perfil_localidade_natureza_juridica AS a
WHERE a.quantidade_oscs IN (
	SELECT MAX(quantidade_oscs)
	FROM analysis.vw_perfil_localidade_natureza_juridica
	WHERE (
		CASE 
			WHEN SUBSTRING(localidade FROM '[0-9]*') = '' THEN '0'
			ELSE SUBSTRING(localidade FROM '[0-9]*')
		END
	)::INTEGER BETWEEN 10 AND 99
	GROUP BY localidade
)
GROUP BY localidade, natureza_juridica, quantidade_oscs

UNION

SELECT
	localidade,
	ARRAY_AGG(natureza_juridica),
	(
		quantidade_oscs::DOUBLE PRECISION / 
		(SELECT SUM(quantidade_oscs) FROM analysis.vw_perfil_localidade_natureza_juridica WHERE localidade = a.localidade)::DOUBLE PRECISION 
		* 100
	) AS porcertagem_maior,
	REPLACE(('{' || TRIM(TRANSLATE(
		ARRAY_AGG(fontes_caracteristicas::TEXT)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM analysis.vw_perfil_localidade_natureza_juridica AS a
WHERE a.quantidade_oscs IN (
	SELECT MAX(quantidade_oscs)
	FROM analysis.vw_perfil_localidade_natureza_juridica
	WHERE (
		CASE 
			WHEN SUBSTRING(localidade FROM '[0-9]*') = '' THEN '0'
			ELSE SUBSTRING(localidade FROM '[0-9]*')
		END
	)::INTEGER > 99
	GROUP BY localidade
)
GROUP BY localidade, natureza_juridica, quantidade_oscs

/*
SELECT
	a.localidade,
	ARRAY_AGG(natureza_juridica),
	quantidade_oscs::DOUBLE PRECISION AS quantidade_oscs_natureza_juridica,
	MAX(b.quantidade_oscs_localidade) AS quantidade_oscs_localidade,
	(
		quantidade_oscs::DOUBLE PRECISION / 
		MAX(b.quantidade_oscs_localidade)::DOUBLE PRECISION 
		* 100
	) AS porcertagem_maior,
	REPLACE(('{' || TRIM(TRANSLATE(
		ARRAY_AGG(fontes_caracteristicas::TEXT)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes,
	'regiao'::TEXT AS tipo_rank
FROM analysis.vw_perfil_localidade_natureza_juridica AS a
LEFT JOIN (
	SELECT localidade, SUM(quantidade_oscs) AS quantidade_oscs_localidade
	FROM analysis.vw_perfil_localidade_natureza_juridica
	GROUP BY localidade
) AS b
ON a.localidade = b.localidade
WHERE a.quantidade_oscs IN (
	SELECT MAX(quantidade_oscs)
	FROM analysis.vw_perfil_localidade_natureza_juridica
	WHERE (
		CASE 
			WHEN SUBSTRING(localidade FROM '[0-9]*') = '' THEN '0'
			ELSE SUBSTRING(localidade FROM '[0-9]*')
		END
	)::INTEGER BETWEEN 1 AND 9
	GROUP BY localidade
)
GROUP BY a.localidade, a.natureza_juridica, a.quantidade_oscs
*/