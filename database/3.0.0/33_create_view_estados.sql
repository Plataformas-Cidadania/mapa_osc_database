drop view spat.vw_estado;
create view spat.vw_estado as
SELECT ed_uf.eduf_cd_uf,
       ed_uf.eduf_nm_uf,
       ed_uf.eduf_sg_uf,
       translate(lower(unaccent(ed_uf.eduf_nm_uf::text)), ' _-'::text, ''::text) AS eduf_nm_uf_ajustado,
       translate(lower(ed_uf.eduf_sg_uf::text), ' _-'::text, ''::text)           AS eduf_sg_uf_ajustado,
       setweight(to_tsvector('portuguese_unaccent'::regconfig, COALESCE(lower(ed_uf.eduf_nm_uf::text), ''::text)),
                 'A'::"char") ||
       setweight(to_tsvector('portuguese_unaccent'::regconfig, COALESCE(lower(ed_uf.eduf_sg_uf::text), ''::text)),
                 'B'::"char")                                                    AS document
FROM spat.ed_uf;

