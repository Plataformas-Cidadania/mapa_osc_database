DROP MATERIALIZED VIEW IF EXISTS spat.vw_spat_estado CASCADE;

CREATE MATERIALIZED VIEW spat.vw_spat_estado
AS

SELECT
	ed_uf.eduf_cd_uf,
	ed_uf.eduf_nm_uf,
	ed_uf.eduf_sg_uf,
	TRANSLATE(LOWER(UNACCENT(ed_uf.eduf_nm_uf)), ' _-', '') AS eduf_nm_uf_ajustado,
	TRANSLATE(LOWER(ed_uf.eduf_sg_uf), ' _-', '') AS eduf_sg_uf_ajustado,
    setweight(to_tsvector('portuguese_unaccent', coalesce(LOWER(ed_uf.eduf_nm_uf), '')), 'A') ||
	setweight(to_tsvector('portuguese_unaccent', coalesce(LOWER(ed_uf.eduf_sg_uf), '')), 'B')
	AS document
FROM spat.ed_uf;

ALTER MATERIALIZED VIEW spat.vw_spat_estado OWNER TO postgres;
