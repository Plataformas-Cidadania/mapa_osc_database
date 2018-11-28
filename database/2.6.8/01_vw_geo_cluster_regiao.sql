DROP MATERIALIZED VIEW IF EXISTS spat.vw_geo_cluster_regiao CASCADE;

CREATE MATERIALIZED VIEW spat.vw_geo_cluster_regiao
AS

SELECT ed_regiao.edre_cd_regiao AS id_regiao,
    1 AS cd_tipo_regiao,
    'Região'::text AS tx_tipo_regiao,
    ed_regiao.edre_nm_regiao AS tx_nome_regiao,
    ed_regiao.edre_sg_regiao AS tx_sigla_regiao,
    round(st_y(ed_regiao.edre_centroid)::numeric, 6)::double precision AS geo_lat_centroid_regiao,
    round(st_x(ed_regiao.edre_centroid)::numeric, 6)::double precision AS geo_lng_centroid_regiao,
    (( SELECT count(*) AS count
           FROM osc.tb_localizacao
      	   JOIN osc.tb_osc on osc.tb_localizacao.id_osc = osc.tb_osc.id_osc and bo_osc_ativa is true
          WHERE "substring"(tb_localizacao.cd_municipio::text, 1, 1)::numeric(1,0) = ed_regiao.edre_cd_regiao))::integer AS nr_quantidade_osc_regiao
   FROM spat.ed_regiao
UNION
 SELECT ed_uf.eduf_cd_uf AS id_regiao,
    2 AS cd_tipo_regiao,
    'Estado'::text AS tx_tipo_regiao,
    ed_uf.eduf_nm_uf AS tx_nome_regiao,
    ed_uf.eduf_sg_uf AS tx_sigla_regiao,
    round(st_y(ed_uf.eduf_centroid)::numeric, 6)::double precision AS geo_lat_centroid_regiao,
    round(st_x(ed_uf.eduf_centroid)::numeric, 6)::double precision AS geo_lng_centroid_regiao,
    (( SELECT count(*) AS count
           FROM osc.tb_localizacao
      	   JOIN osc.tb_osc on osc.tb_localizacao.id_osc = osc.tb_osc.id_osc and bo_osc_ativa is true
          WHERE "substring"(tb_localizacao.cd_municipio::text, 1, 2)::numeric(2,0) = ed_uf.eduf_cd_uf))::integer AS nr_quantidade_osc_regiao
   FROM spat.ed_uf
UNION
 SELECT ed_municipio.edmu_cd_municipio AS id_regiao,
    3 AS cd_tipo_regiao,
    'Município'::text AS tx_tipo_regiao,
    ed_municipio.edmu_nm_municipio AS tx_nome_regiao,
    NULL::character varying AS tx_sigla_regiao,
    round(st_y(ed_municipio.edmu_centroid)::numeric, 6)::double precision AS geo_lat_centroid_regiao,
    round(st_x(ed_municipio.edmu_centroid)::numeric, 6)::double precision AS geo_lng_centroid_regiao,
    (( SELECT count(*) AS count
           FROM osc.tb_localizacao
           JOIN osc.tb_osc on osc.tb_localizacao.id_osc = osc.tb_osc.id_osc and bo_osc_ativa is true
          WHERE tb_localizacao.cd_municipio = ed_municipio.edmu_cd_municipio))::integer AS nr_quantidade_osc_regiao
   FROM spat.ed_municipio;

ALTER MATERIALIZED VIEW spat.vw_geo_cluster_regiao OWNER TO postgres;
