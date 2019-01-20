DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_ranking_repasse_recursos CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_ranking_repasse_recursos AS 

SELECT 
	localidade,
	SUM(valor_recursos) AS soma_valores,
	RANK() over (ORDER BY SUM(valor_recursos) DESC) as rank,
	'regiao' AS tipo_rank
FROM analysis.vw_perfil_localidade_repasse_recursos
WHERE (
	CASE 
		WHEN SUBSTRING(localidade FROM '[0-9]*') = '' THEN '0'
		ELSE SUBSTRING(localidade FROM '[0-9]*')
	END
)::INTEGER BETWEEN 1 AND 9
GROUP BY localidade

UNION

SELECT 
	localidade,
	SUM(valor_recursos) AS soma_valores,
	RANK() over (ORDER BY SUM(valor_recursos) DESC) as rank,
	'estado' AS tipo_rank
FROM analysis.vw_perfil_localidade_repasse_recursos
WHERE (
	CASE 
		WHEN SUBSTRING(localidade FROM '[0-9]*') = '' THEN '0'
		ELSE SUBSTRING(localidade FROM '[0-9]*')
	END
)::INTEGER BETWEEN 10 AND 99
GROUP BY localidade

UNION

SELECT 
	localidade,
	SUM(valor_recursos) AS soma_valores,
	RANK() over (ORDER BY SUM(valor_recursos) DESC) as rank,
	'municipio' AS tipo_rank
FROM analysis.vw_perfil_localidade_repasse_recursos
WHERE (
	CASE 
		WHEN SUBSTRING(localidade FROM '[0-9]*') = '' THEN '0'
		ELSE SUBSTRING(localidade FROM '[0-9]*')
	END
)::INTEGER > 99
GROUP BY localidade;