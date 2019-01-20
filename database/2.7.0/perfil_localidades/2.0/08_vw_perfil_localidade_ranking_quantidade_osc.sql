DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_ranking_quantidade_osc CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_ranking_quantidade_osc AS 

SELECT 
	localidade,
	nr_quantidade_oscs,
	RANK() over (ORDER BY nr_quantidade_oscs DESC) as rank
FROM analysis.vw_perfil_localidade_caracteristicas;