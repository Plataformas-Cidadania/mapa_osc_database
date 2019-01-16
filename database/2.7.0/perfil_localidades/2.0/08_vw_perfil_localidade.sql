DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade AS 

SELECT
	a.localidade,
	--(SELECT b.natureza_juridica FROM analysis.vw_perfil_localidade_natureza_juridica AS b WHERE b.quantidade_oscs = MAX(a.quantidade_oscs)) AS natureza_juridica,
	MAX(a.quantidade_oscs) / (SELECT SUM(quantidade_oscs) FROM analysis.vw_perfil_localidade_natureza_juridica AS b WHERE b.localidade = a.localidade) * 100 AS media
FROM analysis.vw_perfil_localidade_natureza_juridica AS a
--WHERE a.localidade = '1'
GROUP BY a.localidade;