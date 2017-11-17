-- Materialized View: osc.vw_busca_osc

DROP MATERIALIZED VIEW osc.vw_busca_osc;

CREATE MATERIALIZED VIEW osc.vw_busca_osc AS 
 SELECT tb_osc.id_osc,
    tb_osc.cd_identificador_osc,
    translate(btrim(tb_dados_gerais.tx_razao_social_osc), '.,/,\,|,:,#,@,$,&,!,?,(,),[,]'::text, ''::text) AS tx_razao_social_osc,
    NULLIF(translate(btrim(tb_dados_gerais.tx_nome_fantasia_osc), '.,/,\,|,:,#,@,$,&,!,?,(,),[,]'::text, ''::text), ''::text) AS tx_nome_fantasia_osc,
    setweight(to_tsvector('portuguese_unaccent'::regconfig, COALESCE(translate(btrim(tb_dados_gerais.tx_razao_social_osc), '.,/,\,|,:,#,@,$,&,!,?,(,),[,]'::text, ''::text), ''::text)), 'A'::"char") || setweight(to_tsvector('portuguese_unaccent'::regconfig, COALESCE(translate(btrim(tb_dados_gerais.tx_nome_fantasia_osc), '.,/,\,|,:,#,@,$,&,!,?,(,),[,]'::text, ''::text), ''::text)), 'B'::"char") AS document,
    ( SELECT dc_natureza_juridica.tx_nome_natureza_juridica
           FROM syst.dc_natureza_juridica
          WHERE dc_natureza_juridica.cd_natureza_juridica = tb_dados_gerais.cd_natureza_juridica_osc) AS tx_nome_natureza_juridica_osc,
    tb_dados_gerais.dt_fundacao_osc,
    tb_dados_gerais.cd_situacao_imovel_osc,
    ( SELECT ed_municipio.edmu_nm_municipio
           FROM spat.ed_municipio
          WHERE ed_municipio.edmu_cd_municipio = tb_localizacao.cd_municipio) AS tx_nome_municipio,
    ( SELECT ed_uf.eduf_sg_uf
           FROM spat.ed_uf
          WHERE ed_uf.eduf_cd_uf = substr(tb_localizacao.cd_municipio::text, 0, 3)::numeric(2,0)) AS tx_sigla_uf,
    ( SELECT ed_uf.eduf_nm_uf
           FROM spat.ed_uf
          WHERE ed_uf.eduf_cd_uf = substr(tb_localizacao.cd_municipio::text, 0, 3)::numeric(2,0)) AS tx_nome_uf,
    ( SELECT ed_regiao.edre_nm_regiao
           FROM spat.ed_regiao
          WHERE ed_regiao.edre_cd_regiao = (( SELECT ed_uf.edre_cd_regiao
                   FROM spat.ed_uf
                  WHERE ed_uf.eduf_cd_uf = substr(tb_localizacao.cd_municipio::text, 0, 3)::numeric(2,0)))::numeric) AS tx_nome_regiao,
    COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) + COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) + COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0) AS total_trabalhadores,
    tb_relacoes_trabalho.nr_trabalhadores_vinculo,
    tb_relacoes_trabalho.nr_trabalhadores_deficiencia,
    tb_relacoes_trabalho.nr_trabalhadores_voluntarios
   FROM osc.tb_osc
     LEFT JOIN osc.tb_dados_gerais ON tb_osc.id_osc = tb_dados_gerais.id_osc
     LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
     LEFT JOIN osc.tb_relacoes_trabalho ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
  WHERE tb_osc.bo_osc_ativa = true
WITH DATA;

ALTER TABLE osc.vw_busca_osc
  OWNER TO postgres;
