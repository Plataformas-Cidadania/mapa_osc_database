drop view spat.vw_municipios_estados;
create view spat.vw_municipios_estados as
    SELECT ed_municipio.edmu_cd_municipio,
       ed_municipio.edmu_nm_municipio,
       (SELECT ed_uf.eduf_sg_uf
        FROM spat.ed_uf
        WHERE ed_uf.eduf_cd_uf = ed_municipio.eduf_cd_uf::numeric) AS eduf_sg_uf,
       translate(lower(unaccent(ed_municipio.edmu_nm_municipio::text)), ' _-'::text,
                 ''::text)                                         AS edmu_nm_municipio_ajustado,
       translate(lower(((SELECT ed_uf.eduf_sg_uf
                         FROM spat.ed_uf
                         WHERE ed_uf.eduf_cd_uf = ed_municipio.eduf_cd_uf::numeric))::text), ' _-'::text,
                 ''::text)                                         AS eduf_sg_uf_ajustado,
       setweight(to_tsvector('portuguese_unaccent'::regconfig,
                             COALESCE(lower(ed_municipio.edmu_nm_municipio::text), ''::text)),
                 'A'::"char")                                      AS document
FROM spat.ed_municipio;