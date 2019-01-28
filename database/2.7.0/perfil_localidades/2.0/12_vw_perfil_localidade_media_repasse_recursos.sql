DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_media_repasse_recursos CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_media_repasse_recursos AS 

SELECT
	a.localidade,
	COUNT(*) AS quantidade_repasses,
	SUM(valor_recursos) AS valor_repasses,
	SUM(valor_recursos) / COUNT(*) AS media
FROM analysis.vw_perfil_localidade_repasse_recursos AS a
GROUP BY a.localidade
ORDER BY valor_repasses DESC;

CREATE INDEX ix_localidade_vw_perfil_localidade_media_repasse_recursos
    ON analysis.vw_perfil_localidade_media_repasse_recursos USING btree
    (localidade ASC NULLS LAST)
    TABLESPACE pg_default;