DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_ranking_quantidade_osc CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_ranking_quantidade_osc AS 

SELECT
	localidade,
	nr_quantidade_osc,
	RANK() over (ORDER BY nr_quantidade_osc DESC) as rank,
	'regiao' AS tipo_rank
FROM analysis.vw_perfil_localidade_caracteristicas
WHERE (
	CASE 
		WHEN SUBSTRING(localidade FROM '[0-9]*') = '' THEN '0'
		ELSE SUBSTRING(localidade FROM '[0-9]*')
	END
)::INTEGER BETWEEN 1 AND 9

UNION

SELECT
	localidade,
	nr_quantidade_osc,
	RANK() over (ORDER BY nr_quantidade_osc DESC) as rank,
	'estado' AS tipo_rank
FROM analysis.vw_perfil_localidade_caracteristicas
WHERE (
	CASE 
		WHEN SUBSTRING(localidade FROM '[0-9]*') = '' THEN '0'
		ELSE SUBSTRING(localidade FROM '[0-9]*')
	END
)::INTEGER BETWEEN 10 AND 99

UNION

SELECT
	localidade,
	nr_quantidade_osc,
	RANK() over (ORDER BY nr_quantidade_osc DESC) as rank,
	'municipio' AS tipo_rank
FROM analysis.vw_perfil_localidade_caracteristicas
WHERE (
	CASE 
		WHEN SUBSTRING(localidade FROM '[0-9]*') = '' THEN '0'
		ELSE SUBSTRING(localidade FROM '[0-9]*')
	END
)::INTEGER > 99;

CREATE INDEX ix_localidade_vw_perfil_localidade_ranking_quantidade_osc
    ON analysis.vw_perfil_localidade_ranking_quantidade_osc USING btree
    (localidade ASC NULLS LAST)
    TABLESPACE pg_default;