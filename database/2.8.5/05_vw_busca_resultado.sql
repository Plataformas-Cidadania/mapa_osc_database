create materialized view osc.vw_busca_resultado as
SELECT tb_osc.id_osc,
       btrim(COALESCE(substring(tb_dados_gerais.tx_nome_fantasia_osc, '', NULL), tb_dados_gerais.tx_razao_social_osc))               AS tx_nome_osc,
       lpad((tb_osc.cd_identificador_osc)::text, 14, '0'::text)                                                 AS cd_identificador_osc,
       (SELECT dc_natureza_juridica.tx_nome_natureza_juridica
        FROM syst.dc_natureza_juridica
        WHERE (dc_natureza_juridica.cd_natureza_juridica =
               tb_dados_gerais.cd_natureza_juridica_osc))                                                       AS tx_natureza_juridica_osc,
       rtrim(replace(((((((((((((COALESCE(tb_localizacao.tx_endereco, '|'::text) || ', '::text) ||
                                COALESCE(tb_localizacao.nr_localizacao, '|'::text)) || ', '::text) ||
                              COALESCE(tb_localizacao.tx_endereco_complemento, '|'::text)) || ', '::text) ||
                            COALESCE(tb_localizacao.tx_bairro, '|'::text)) || ', '::text) ||
                          COALESCE(((SELECT ed_municipio.edmu_nm_municipio AS tx_municipio
                                     FROM spat.ed_municipio
                                     WHERE (ed_municipio.edmu_cd_municipio = tb_localizacao.cd_municipio)))::text,
                                   '|'::text)) || ', '::text) || COALESCE(((SELECT ed_uf.eduf_sg_uf AS tx_uf
                                                                            FROM spat.ed_uf
                                                                            WHERE (ed_uf.eduf_cd_uf =
                                                                                   (substr((tb_localizacao.cd_municipio)::text, 0, 2))::numeric)))::text,
                                                                          '|'::text)) || ', '::text) ||
                      COALESCE((tb_localizacao.nr_cep)::text, '|'::text)), '|, '::text, ''::text),
             ', |'::text)                                                                                       AS tx_endereco_osc,
       st_y(st_transform(tb_localizacao.geo_localizacao, 4674))                                                 AS geo_lat,
       st_x(st_transform(tb_localizacao.geo_localizacao, 4674))                                                 AS geo_lng,
       (SELECT dc_classe_atividade_economica.tx_nome_classe_atividade_economica
        FROM syst.dc_classe_atividade_economica
        WHERE ((dc_classe_atividade_economica.cd_classe_atividade_economica)::text =
               (tb_dados_gerais.cd_classe_atividade_economica_osc)::text))                                      AS tx_nome_atividade_economica,
       tb_dados_gerais.im_logo
FROM ((osc.tb_osc
    LEFT JOIN osc.tb_dados_gerais ON ((tb_osc.id_osc = tb_dados_gerais.id_osc)))
         LEFT JOIN osc.tb_localizacao ON ((tb_osc.id_osc = tb_localizacao.id_osc)))
WHERE (tb_osc.bo_osc_ativa = true);

alter materialized view vw_busca_resultado owner to postgres;

create unique index ix_vw_busca_resultado
    on vw_busca_resultado (id_osc);

