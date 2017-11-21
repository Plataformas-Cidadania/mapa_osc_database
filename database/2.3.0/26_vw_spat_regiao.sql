DROP MATERIALIZED VIEW IF EXISTS spat.vw_spat_regiao CASCADE;

CREATE MATERIALIZED VIEW spat.vw_spat_regiao
AS

SELECT
	ed_regiao.edre_cd_regiao,
	ed_regiao.edre_nm_regiao,
	TRANSLATE(LOWER(UNACCENT(ed_regiao.edre_nm_regiao)), ' _-', '') AS edre_nm_regiao_ajustado,
    setweight(to_tsvector('portuguese_unaccent', coalesce(LOWER(ed_regiao.edre_nm_regiao), '')), 'A') AS document
FROM spat.ed_regiao;

ALTER MATERIALIZED VIEW spat.vw_spat_regiao OWNER TO postgres;
