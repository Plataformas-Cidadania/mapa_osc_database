DROP MATERIALIZED VIEW IF EXISTS ipeadata.vw_dados_geograficos_idh_municipio;
CREATE MATERIALIZED VIEW ipeadata.vw_dados_geograficos_idh_municipio AS

SELECT m.edmu_cd_municipio, m.edmu_nm_municipio, m.edmu_geometry, p.nr_valor
FROM spat.ed_municipio m,
     ipeadata.tb_ipeadata p
WHERE m.edmu_cd_municipio = p.cd_municipio
  AND p.cd_indice = 8;

CREATE INDEX ix_edmu_cd_municipio_vw_dados_geograficos_idh_municipio
    ON ipeadata.vw_dados_geograficos_idh_municipio USING btree
    (edmu_cd_municipio ASC NULLS LAST)
    TABLESPACE pg_default;