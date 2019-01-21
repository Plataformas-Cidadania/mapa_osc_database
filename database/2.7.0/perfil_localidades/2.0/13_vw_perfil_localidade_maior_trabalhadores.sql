DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_maior_trabalhadores CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_maior_trabalhadores AS 

SELECT
	a.localidade,
	(
		CASE
			WHEN a.vinculos = b.quantidade_trabalhadores AND a.deficiencia = b.quantidade_trabalhadores AND a.voluntarios = b.quantidade_trabalhadores THEN '{vinculos, deficiencia, voluntarios}'
			WHEN a.vinculos = b.quantidade_trabalhadores AND a.deficiencia = b.quantidade_trabalhadores THEN '{vinculos, deficiencia}'
			WHEN a.vinculos = b.quantidade_trabalhadores AND a.voluntarios = b.quantidade_trabalhadores THEN '{vinculos, voluntarios}'
			WHEN a.deficiencia = b.quantidade_trabalhadores AND a.voluntarios = b.quantidade_trabalhadores THEN '{deficiencia, voluntarios}'
			WHEN a.vinculos = b.quantidade_trabalhadores THEN '{vinculos}'
			WHEN a.deficiencia = b.quantidade_trabalhadores THEN '{deficiencia}'
			WHEN a.voluntarios = b.quantidade_trabalhadores THEN '{voluntarios}'
			ELSE '{}'
		END
	)::TEXT[] AS tipo_trabalhadores,
	CASE 
		WHEN b.quantidade_trabalhadores > 0 THEN (
			b.quantidade_trabalhadores::DOUBLE PRECISION / 
			a.total::DOUBLE PRECISION 
			* 100
		)::DOUBLE PRECISION
		ELSE (
			0::DOUBLE PRECISION
		)
	END AS porcertagem_maior,
	a.fontes_caracteristicas::TEXT
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