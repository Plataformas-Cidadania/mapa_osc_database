DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade AS 

SELECT TO_JSONB(
    SELECT *
    FROM analysis.vw_perfil_localidade_caracteristicas
);