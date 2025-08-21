create materialized view vw_busca_osc as
SELECT tb_osc.id_osc,
       tb_osc.cd_identificador_osc,
       tb_osc.cd_situacao_cadastral,
       COALESCE(NULLIF(btrim(tb_dados_gerais.tx_nome_fantasia_osc), ''::text),
                tb_dados_gerais.tx_razao_social_osc)                                                     AS tx_nome_osc,
       btrim(translate(
               translate(translate(tb_dados_gerais.tx_razao_social_osc, '/,\,|,:,#,@,$,&,!,?,(,),[,]'::text, ''::text),
                         '.'::text, ','::text), '_'::text,
               ' '::text))                                                                               AS tx_razao_social_osc,
       NULLIF(btrim(translate(
               translate(translate(tb_dados_gerais.tx_nome_fantasia_osc, '/,\,|,:,#,@,$,&,!,?,(,),[,]'::text, ''::text),
                         '.'::text, ','::text), '_'::text, ' '::text)),
              ''::text)                                                                                  AS tx_nome_fantasia_osc,
       setweight(to_tsvector('portuguese_unaccent'::regconfig, COALESCE(btrim(translate(
               translate(translate(tb_dados_gerais.tx_razao_social_osc, '/,\,|,:,#,@,$,&,!,?,(,),[,]'::text, ''::text),
                         '.'::text, ','::text), '_'::text, ' '::text)), ''::text)), 'A'::"char") || setweight(
               to_tsvector('portuguese_unaccent'::regconfig, COALESCE(btrim(translate(translate(translate(
                                                                                                        tb_dados_gerais.tx_nome_fantasia_osc,
                                                                                                        '/,\,|,:,#,@,$,&,!,?,(,),[,]'::text,
                                                                                                        ''::text),
                                                                                                '.'::text, ','::text),
                                                                                      '_'::text, ' '::text)),
                                                                      ''::text)), 'B'::"char")           AS document,
       (SELECT dc_natureza_juridica.tx_nome_natureza_juridica
        FROM syst.dc_natureza_juridica
        WHERE dc_natureza_juridica.cd_natureza_juridica =
              tb_dados_gerais.cd_natureza_juridica_osc)                                                  AS tx_nome_natureza_juridica_osc,
       tb_dados_gerais.dt_fundacao_osc,
       tb_dados_gerais.cd_situacao_imovel_osc,
       tb_localizacao.cd_municipio,
       (SELECT ed_municipio.edmu_nm_municipio
        FROM spat.ed_municipio
        WHERE ed_municipio.edmu_cd_municipio = tb_localizacao.cd_municipio)                              AS tx_nome_municipio,
       substr(tb_localizacao.cd_municipio::text, 0, 3)::numeric(2, 0)                                    AS cd_uf,
       (SELECT ed_uf.eduf_sg_uf
        FROM spat.ed_uf
        WHERE ed_uf.eduf_cd_uf = substr(tb_localizacao.cd_municipio::text, 0, 3)::numeric(2, 0))         AS tx_sigla_uf,
       (SELECT ed_uf.eduf_nm_uf
        FROM spat.ed_uf
        WHERE ed_uf.eduf_cd_uf = substr(tb_localizacao.cd_municipio::text, 0, 3)::numeric(2, 0))         AS tx_nome_uf,
       substr(tb_localizacao.cd_municipio::text, 0, 2)::numeric(1, 0)                                    AS cd_regiao,
       (SELECT ed_regiao.edre_nm_regiao
        FROM spat.ed_regiao
        WHERE ed_regiao.edre_cd_regiao =
              substr(tb_localizacao.cd_municipio::text, 0, 2)::numeric(1, 0))                            AS tx_nome_regiao,
       COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) +
       COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) +
       COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)                                    AS total_trabalhadores,
       tb_relacoes_trabalho.nr_trabalhadores_vinculo,
       tb_relacoes_trabalho.nr_trabalhadores_deficiencia,
       tb_relacoes_trabalho.nr_trabalhadores_voluntarios
FROM osc.tb_osc
         LEFT JOIN osc.tb_dados_gerais ON tb_osc.id_osc = tb_dados_gerais.id_osc
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
         LEFT JOIN osc.tb_relacoes_trabalho ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
WHERE tb_osc.bo_osc_ativa = true;

comment on column vw_busca_osc.id_osc is 'Identificador da OSC';

comment on column vw_busca_osc.cd_identificador_osc is 'Número de identificação da OSC - CNPJ ou CEI';

comment on column vw_busca_osc.dt_fundacao_osc is 'Data de Fundação da OSC';

comment on column vw_busca_osc.cd_situacao_imovel_osc is 'Situação do Imóvel da OSC';

comment on column vw_busca_osc.cd_municipio is 'Chave estrangeira do município';

comment on column vw_busca_osc.nr_trabalhadores_vinculo is 'Número de trabalhadores com vínculo';

comment on column vw_busca_osc.nr_trabalhadores_deficiencia is 'Número de trabalhadores portadores de deficiência';

comment on column vw_busca_osc.nr_trabalhadores_voluntarios is 'Número de trabalhadores voluntários';

alter materialized view vw_busca_osc owner to postgres;

create unique index ix_vw_busca_osc
    on vw_busca_osc (id_osc, cd_identificador_osc);

