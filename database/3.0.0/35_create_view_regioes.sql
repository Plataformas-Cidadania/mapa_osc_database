drop view spat.vw_regiao;
create view spat.vw_regiao as
SELECT ed_regiao.edre_cd_regiao,
       ed_regiao.edre_nm_regiao,
       translate(lower(unaccent(ed_regiao.edre_nm_regiao::text)), ' _-'::text, ''::text) AS edre_nm_regiao_ajustado,
       setweight(
               to_tsvector('portuguese_unaccent'::regconfig, COALESCE(lower(ed_regiao.edre_nm_regiao::text), ''::text)),
               'A'::"char")                                                              AS document
FROM spat.ed_regiao;

