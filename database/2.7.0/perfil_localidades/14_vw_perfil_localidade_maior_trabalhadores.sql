DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_maior_trabalhadores CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_maior_trabalhadores AS 

SELECT
	a.localidade,
	(
		CASE
			WHEN a.vinculos = b.quantidade_trabalhadores AND a.deficiencia = b.quantidade_trabalhadores AND a.voluntarios = b.quantidade_trabalhadores THEN '{Trabalhadores com vínculos, Trabalhadores com deficiência, Trabalhadores voluntários}'
			WHEN a.vinculos = b.quantidade_trabalhadores AND a.deficiencia = b.quantidade_trabalhadores THEN '{Trabalhadores com vínculos, Trabalhadores com deficiência}'
			WHEN a.vinculos = b.quantidade_trabalhadores AND a.voluntarios = b.quantidade_trabalhadores THEN '{Trabalhadores com vínculos, Trabalhadores voluntários}'
			WHEN a.deficiencia = b.quantidade_trabalhadores AND a.voluntarios = b.quantidade_trabalhadores THEN '{Trabalhadores com deficiência, Trabalhadores voluntários}'
			WHEN a.vinculos = b.quantidade_trabalhadores THEN '{Trabalhadores com vínculos}'
			WHEN a.deficiencia = b.quantidade_trabalhadores THEN '{Trabalhadores com deficiência}'
			WHEN a.voluntarios = b.quantidade_trabalhadores THEN '{Trabalhadores voluntários}'
			ELSE '{}'
		END
	)::TEXT[] AS tipo_trabalhadores,
	CASE 
		WHEN b.quantidade_trabalhadores > 0 THEN (
			b.quantidade_trabalhadores::DOUBLE PRECISION
			/ a.total::DOUBLE PRECISION 
			* 100
		)::DOUBLE PRECISION
		ELSE (
			0::DOUBLE PRECISION
		)
	END AS porcertagem_maior,
	a.fontes::TEXT[]
FROM analysis.vw_perfil_localidade_trabalhadores AS a
LEFT JOIN (
	SELECT
		localidade,
		GREATEST(
			vinculos,
			deficiencia,
			voluntarios
		) AS quantidade_trabalhadores
	FROM analysis.vw_perfil_localidade_trabalhadores
) AS b
ON a.localidade = b.localidade;

CREATE INDEX ix_localidade_vw_perfil_localidade_maior_trabalhadores
    ON analysis.vw_perfil_localidade_maior_trabalhadores USING btree
    (localidade ASC NULLS LAST)
    TABLESPACE pg_default;