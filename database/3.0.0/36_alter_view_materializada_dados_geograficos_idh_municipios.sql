DROP MATERIALIZED VIEW ipeadata.vw_dados_geograficos_idh_municipio;

--CRIAR VIEW PRINCIPAL
CREATE MATERIALIZED VIEW ipeadata.vw_dados_geograficos_idh_municipio AS
SELECT m.edmu_cd_municipio,
       m.edmu_nm_municipio,
       m.eduf_cd_uf,
       m.edmu_geometry,
       m.edmu_centroid,
       m.edmu_bounding_box,
       p.nr_valor
FROM spat.ed_municipio m,
     ipeadata.tb_ipeadata p
WHERE m.edmu_cd_municipio = p.cd_municipio
  AND p.cd_indice = 8;

create index ix_edmu_cd_municipio_vw_dados_geograficos_idh_municipio
    on ipeadata.vw_dados_geograficos_idh_municipio (edmu_cd_municipio);