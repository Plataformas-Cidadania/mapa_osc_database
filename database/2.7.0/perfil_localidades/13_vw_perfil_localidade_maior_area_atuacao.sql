DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_maior_area_atuacao CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_maior_area_atuacao AS 

SELECT
	a.localidade,
	ARRAY_AGG(a.area_atuacao) AS area_atuacao,
	(
		MAX(a.quantidade_oscs)::DOUBLE PRECISION
		/ (SELECT SUM(quantidade_oscs) FROM analysis.vw_perfil_localidade_area_atuacao WHERE localidade = a.localidade)::DOUBLE PRECISION 
		* 100
	) AS porcertagem_maior,
	REPLACE(('{' || TRIM(TRANSLATE(
		ARRAY_AGG(fontes::TEXT)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM analysis.vw_perfil_localidade_area_atuacao AS a
RIGHT JOIN (
	SELECT
		localidade,
		MAX(quantidade_oscs) AS quantidade_oscs
	FROM analysis.vw_perfil_localidade_area_atuacao
	WHERE (
		CASE 
			WHEN SUBSTRING(localidade FROM '[0-9]*') = '' THEN '0'
			ELSE SUBSTRING(localidade FROM '[0-9]*')
		END
	)::INTEGER BETWEEN 1 AND 9
	GROUP BY localidade
) AS b
ON a.localidade = b.localidade
AND a.quantidade_oscs = b.quantidade_oscs
GROUP BY a.localidade

UNION

SELECT
	a.localidade,
	ARRAY_AGG(a.area_atuacao),
	(
		MAX(a.quantidade_oscs)::DOUBLE PRECISION
		/ (SELECT SUM(quantidade_oscs) FROM analysis.vw_perfil_localidade_area_atuacao WHERE localidade = a.localidade)::DOUBLE PRECISION 
		* 100
	) AS porcertagem_maior,
	REPLACE(('{' || TRIM(TRANSLATE(
		ARRAY_AGG(fontes::TEXT)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM analysis.vw_perfil_localidade_area_atuacao AS a
RIGHT JOIN (
	SELECT
		localidade,
		MAX(quantidade_oscs) AS quantidade_oscs
	FROM analysis.vw_perfil_localidade_area_atuacao
	WHERE (
		CASE 
			WHEN SUBSTRING(localidade FROM '[0-9]*') = '' THEN '0'
			ELSE SUBSTRING(localidade FROM '[0-9]*')
		END
	)::INTEGER BETWEEN 10 AND 99
	GROUP BY localidade
) AS b
ON a.localidade = b.localidade
AND a.quantidade_oscs = b.quantidade_oscs
GROUP BY a.localidade

UNION

SELECT
	a.localidade,
	ARRAY_AGG(a.area_atuacao),
	(
		MAX(a.quantidade_oscs)::DOUBLE PRECISION
		/ (SELECT SUM(quantidade_oscs) FROM analysis.vw_perfil_localidade_area_atuacao WHERE localidade = a.localidade)::DOUBLE PRECISION 
		* 100
	) AS porcertagem_maior,
	REPLACE(('{' || TRIM(TRANSLATE(
		ARRAY_AGG(fontes::TEXT)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM analysis.vw_perfil_localidade_area_atuacao AS a
RIGHT JOIN (
	SELECT
		localidade,
		MAX(quantidade_oscs) AS quantidade_oscs
	FROM analysis.vw_perfil_localidade_area_atuacao
	WHERE (
		CASE 
			WHEN SUBSTRING(localidade FROM '[0-9]*') = '' THEN '0'
			ELSE SUBSTRING(localidade FROM '[0-9]*')
		END
	)::INTEGER > 99
	GROUP BY localidade
) AS b
ON a.localidade = b.localidade
AND a.quantidade_oscs = b.quantidade_oscs
GROUP BY a.localidade;

CREATE INDEX ix_localidade_vw_perfil_localidade_maior_area_atuacao
    ON analysis.vw_perfil_localidade_maior_area_atuacao USING btree
    (localidade ASC NULLS LAST)
    TABLESPACE pg_default;