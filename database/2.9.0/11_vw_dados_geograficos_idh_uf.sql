DROP MATERIALIZED VIEW IF EXISTS ipeadata.vw_dados_geograficos_idh_uf;
CREATE MATERIALIZED VIEW ipeadata.vw_dados_geograficos_idh_uf AS

SELECT u.eduf_cd_uf, u.eduf_nm_uf, u.eduf_geometry, p.nr_valor
FROM spat.ed_uf u,
     ipeadata.tb_ipeadata_uf p
WHERE u.eduf_cd_uf = p.cd_uf
  AND p.cd_indice = 8;

CREATE INDEX ix_edmu_cd_uf_vw_dados_geograficos_idh_uf
    ON ipeadata.vw_dados_geograficos_idh_uf USING btree
    (eduf_cd_uf ASC NULLS LAST)
    TABLESPACE pg_default;