DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_area_atuacao_nacional CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_area_atuacao_nacional AS 

SELECT 
	area_atuacao,
	SUM(quantidade_oscs) AS quantidade_osc
FROM analysis.vw_perfil_localidade_area_atuacao
GROUP BY area_atuacao;

CREATE INDEX ix_area_atuacao_vw_perfil_area_atuacao_nacional
    ON analysis.vw_perfil_area_atuacao_nacional USING btree
    (area_atuacao ASC NULLS LAST)
    TABLESPACE pg_default;