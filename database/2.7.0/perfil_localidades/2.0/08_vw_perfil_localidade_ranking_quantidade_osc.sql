DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_ranking_quantidade_osc CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_ranking_quantidade_osc AS 

SELECT 
	localidade,
	quantidade_oscs,
	RANK() over (ORDER BY quantidade_oscs DESC) as rank
FROM analysis.vw_perfil_localidade_caracteristicas;