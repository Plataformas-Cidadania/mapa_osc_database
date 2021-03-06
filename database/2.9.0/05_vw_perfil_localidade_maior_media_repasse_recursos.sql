DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_maior_media_repasse_recursos CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_maior_media_repasse_recursos AS 

SELECT
	a.localidade,
	ARRAY_AGG(a.fonte_recursos) AS tipo_repasse,
	(
		SELECT
			CASE 
				WHEN SUM(valor_recursos) > 0 THEN (
					(COUNT(*) / SUM(valor_recursos))::DOUBLE PRECISION
				)
				ELSE (
					0::DOUBLE PRECISION
				)
			END
		FROM analysis.vw_perfil_localidade_repasse_recursos
		WHERE localidade = a.localidade
	) AS media,
	CASE
		WHEN MAX(a.valor_recursos) > 0 THEN (
			MAX(a.valor_recursos)::DOUBLE PRECISION
			/ (SELECT SUM(valor_recursos) FROM analysis.vw_perfil_localidade_repasse_recursos WHERE localidade = a.localidade)::DOUBLE PRECISION 
			* 100
		)::DOUBLE PRECISION
		ELSE (
			0::DOUBLE PRECISION
		)
	END AS porcertagem_maior,
	REPLACE(('{' || TRIM(TRANSLATE(
		ARRAY_AGG(fontes::TEXT)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM analysis.vw_perfil_localidade_repasse_recursos AS a
RIGHT JOIN (
	SELECT
		localidade,
		MAX(valor_recursos) AS valor_recursos
	FROM analysis.vw_perfil_localidade_repasse_recursos
	WHERE (
		CASE 
			WHEN SUBSTRING(localidade FROM '[0-9]*') = '' THEN '0'
			ELSE SUBSTRING(localidade FROM '[0-9]*')
		END
	)::INTEGER BETWEEN 1 AND 9
	GROUP BY localidade
) AS b
ON a.localidade = b.localidade
AND a.valor_recursos = b.valor_recursos
GROUP BY a.localidade

UNION

SELECT
	a.localidade,
	ARRAY_AGG(a.fonte_recursos) AS tipo_repasse,
	(
		SELECT
			CASE 
				WHEN SUM(valor_recursos) > 0 THEN (
					(COUNT(*) / SUM(valor_recursos))::DOUBLE PRECISION
				)
				ELSE (
					0::DOUBLE PRECISION
				)
			END
		FROM analysis.vw_perfil_localidade_repasse_recursos
		WHERE localidade = a.localidade
	) AS media,
	CASE 
		WHEN MAX(a.valor_recursos) > 0 THEN (
			MAX(a.valor_recursos)::DOUBLE PRECISION
			/ (SELECT SUM(valor_recursos) FROM analysis.vw_perfil_localidade_repasse_recursos WHERE localidade = a.localidade)::DOUBLE PRECISION 
			* 100
		)::DOUBLE PRECISION
		ELSE (
			0::DOUBLE PRECISION
		)
	END AS porcertagem_maior,
	REPLACE(('{' || TRIM(TRANSLATE(
		ARRAY_AGG(fontes::TEXT)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM analysis.vw_perfil_localidade_repasse_recursos AS a
RIGHT JOIN (
	SELECT
		localidade,
		MAX(valor_recursos) AS valor_recursos
	FROM analysis.vw_perfil_localidade_repasse_recursos
	WHERE (
		CASE 
			WHEN SUBSTRING(localidade FROM '[0-9]*') = '' THEN '0'
			ELSE SUBSTRING(localidade FROM '[0-9]*')
		END
	)::INTEGER BETWEEN 10 AND 99
	GROUP BY localidade
) AS b
ON a.localidade = b.localidade
AND a.valor_recursos = b.valor_recursos
GROUP BY a.localidade

UNION

SELECT
	a.localidade,
	ARRAY_AGG(a.fonte_recursos) AS tipo_repasse,
	(
		SELECT
			CASE 
				WHEN SUM(valor_recursos) > 0 THEN (
					(COUNT(*) / SUM(valor_recursos))::DOUBLE PRECISION
				)
				ELSE (
					0::DOUBLE PRECISION
				)
			END
		FROM analysis.vw_perfil_localidade_repasse_recursos
		WHERE localidade = a.localidade
	) AS media,
	CASE 
		WHEN MAX(a.valor_recursos) > 0 THEN (
			MAX(a.valor_recursos)::DOUBLE PRECISION
			/ (SELECT SUM(valor_recursos) FROM analysis.vw_perfil_localidade_repasse_recursos WHERE localidade = a.localidade)::DOUBLE PRECISION 
			* 100
		)::DOUBLE PRECISION
		ELSE (
			0::DOUBLE PRECISION
		)
	END AS porcertagem_maior,
	REPLACE(('{' || TRIM(TRANSLATE(
		ARRAY_AGG(fontes::TEXT)::TEXT
	, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
FROM analysis.vw_perfil_localidade_repasse_recursos AS a
RIGHT JOIN (
	SELECT
		localidade,
		MAX(valor_recursos) AS valor_recursos
	FROM analysis.vw_perfil_localidade_repasse_recursos
	WHERE (
		CASE 
			WHEN SUBSTRING(localidade FROM '[0-9]*') = '' THEN '0'
			ELSE SUBSTRING(localidade FROM '[0-9]*')
		END
	)::INTEGER > 99
	GROUP BY localidade
) AS b
ON a.localidade = b.localidade
AND a.valor_recursos = b.valor_recursos
GROUP BY a.localidade;

CREATE INDEX ix_localidade_vw_perfil_localidade_maior_media_repasse_recursos
    ON analysis.vw_perfil_localidade_maior_media_repasse_recursos USING btree
    (localidade ASC NULLS LAST)
    TABLESPACE pg_default;