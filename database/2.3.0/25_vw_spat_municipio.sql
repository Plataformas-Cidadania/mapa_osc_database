DROP MATERIALIZED VIEW IF EXISTS spat.vw_spat_municipio CASCADE;

CREATE MATERIALIZED VIEW spat.vw_spat_municipio
AS

SELECT
	ed_municipio.edmu_cd_municipio,
	ed_municipio.edmu_nm_municipio,
	(SELECT eduf_sg_uf FROM spat.ed_uf WHERE eduf_cd_uf = ed_municipio.eduf_cd_uf) AS eduf_sg_uf,
	TRANSLATE(LOWER(UNACCENT(ed_municipio.edmu_nm_municipio)), ' _-', '') AS edmu_nm_municipio_ajustado,
	TRANSLATE(LOWER((SELECT eduf_sg_uf FROM spat.ed_uf WHERE eduf_cd_uf = ed_municipio.eduf_cd_uf)), ' _-', '') AS eduf_sg_uf_ajustado,
    setweight(to_tsvector('portuguese_unaccent', coalesce(LOWER(ed_municipio.edmu_nm_municipio), '')), 'A') AS document
FROM spat.ed_municipio;

ALTER MATERIALIZED VIEW spat.vw_spat_municipio OWNER TO postgres;
