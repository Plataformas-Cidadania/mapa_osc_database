create materialized view vw_perfil_localidade_repasse_recursos as
SELECT substr(tb_localizacao.cd_municipio::text, 1, 1)                           AS localidade,
       dc_origem_fonte_recursos_osc.tx_nome_origem_fonte_recursos_osc            AS fonte_recursos,
       date_part('year'::text, tb_recursos_osc.dt_ano_recursos_osc)::text        AS ano,
       sum(COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0::double precision)) AS valor_recursos,
       replace(('{'::text || btrim(translate(((SELECT array_agg(translate(a.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(array_cat(array_agg(DISTINCT
                                                                                                          COALESCE(tb_recursos_osc.ft_fonte_recursos_osc, ''::text)),
                                                                                                array_agg(DISTINCT
                                                                                                          COALESCE(tb_recursos_osc.ft_ano_recursos_osc, ''::text))),
                                                                                      array_agg(DISTINCT
                                                                                                COALESCE(tb_recursos_osc.ft_valor_recursos_osc, ''::text)))) AS unnest) a))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
               ','::text)::text[]                                                AS fontes
FROM osc.tb_osc
         LEFT JOIN osc.tb_dados_gerais ON tb_osc.id_osc = tb_dados_gerais.id_osc
         LEFT JOIN osc.tb_recursos_osc ON tb_osc.id_osc = tb_recursos_osc.id_osc
         LEFT JOIN syst.dc_fonte_recursos_osc
                   ON tb_recursos_osc.cd_fonte_recursos_osc = dc_fonte_recursos_osc.cd_fonte_recursos_osc
         LEFT JOIN syst.dc_origem_fonte_recursos_osc ON dc_fonte_recursos_osc.cd_origem_fonte_recursos_osc =
                                                        dc_origem_fonte_recursos_osc.cd_origem_fonte_recursos_osc
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
  AND tb_osc.id_osc <> 789809
  AND tb_localizacao.cd_municipio IS NOT NULL
  AND tb_recursos_osc.dt_ano_recursos_osc IS NOT NULL
GROUP BY (substr(tb_localizacao.cd_municipio::text, 1, 1)),
         (date_part('year'::text, tb_recursos_osc.dt_ano_recursos_osc)::text),
         dc_origem_fonte_recursos_osc.tx_nome_origem_fonte_recursos_osc
UNION
SELECT substr(tb_localizacao.cd_municipio::text, 1, 2)                           AS localidade,
       dc_origem_fonte_recursos_osc.tx_nome_origem_fonte_recursos_osc            AS fonte_recursos,
       date_part('year'::text, tb_recursos_osc.dt_ano_recursos_osc)::text        AS ano,
       sum(COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0::double precision)) AS valor_recursos,
       replace(('{'::text || btrim(translate(((SELECT array_agg(translate(a.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(array_cat(array_agg(DISTINCT
                                                                                                          COALESCE(tb_recursos_osc.ft_fonte_recursos_osc, ''::text)),
                                                                                                array_agg(DISTINCT
                                                                                                          COALESCE(tb_recursos_osc.ft_ano_recursos_osc, ''::text))),
                                                                                      array_agg(DISTINCT
                                                                                                COALESCE(tb_recursos_osc.ft_valor_recursos_osc, ''::text)))) AS unnest) a))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
               ','::text)::text[]                                                AS fontes
FROM osc.tb_osc
         LEFT JOIN osc.tb_dados_gerais ON tb_osc.id_osc = tb_dados_gerais.id_osc
         LEFT JOIN osc.tb_recursos_osc ON tb_osc.id_osc = tb_recursos_osc.id_osc
         LEFT JOIN syst.dc_fonte_recursos_osc
                   ON tb_recursos_osc.cd_fonte_recursos_osc = dc_fonte_recursos_osc.cd_fonte_recursos_osc
         LEFT JOIN syst.dc_origem_fonte_recursos_osc ON dc_fonte_recursos_osc.cd_origem_fonte_recursos_osc =
                                                        dc_origem_fonte_recursos_osc.cd_origem_fonte_recursos_osc
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
  AND tb_osc.id_osc <> 789809
  AND tb_localizacao.cd_municipio IS NOT NULL
  AND tb_recursos_osc.dt_ano_recursos_osc IS NOT NULL
GROUP BY (substr(tb_localizacao.cd_municipio::text, 1, 2)),
         (date_part('year'::text, tb_recursos_osc.dt_ano_recursos_osc)::text),
         dc_origem_fonte_recursos_osc.tx_nome_origem_fonte_recursos_osc
UNION
SELECT tb_localizacao.cd_municipio::text                                         AS localidade,
       dc_origem_fonte_recursos_osc.tx_nome_origem_fonte_recursos_osc            AS fonte_recursos,
       date_part('year'::text, tb_recursos_osc.dt_ano_recursos_osc)::text        AS ano,
       sum(COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0::double precision)) AS valor_recursos,
       replace(('{'::text || btrim(translate(((SELECT array_agg(translate(a.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(array_cat(array_agg(DISTINCT
                                                                                                          COALESCE(tb_recursos_osc.ft_fonte_recursos_osc, ''::text)),
                                                                                                array_agg(DISTINCT
                                                                                                          COALESCE(tb_recursos_osc.ft_ano_recursos_osc, ''::text))),
                                                                                      array_agg(DISTINCT
                                                                                                COALESCE(tb_recursos_osc.ft_valor_recursos_osc, ''::text)))) AS unnest) a))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
               ','::text)::text[]                                                AS fontes
FROM osc.tb_osc
         LEFT JOIN osc.tb_dados_gerais ON tb_osc.id_osc = tb_dados_gerais.id_osc
         LEFT JOIN osc.tb_recursos_osc ON tb_osc.id_osc = tb_recursos_osc.id_osc
         LEFT JOIN syst.dc_fonte_recursos_osc
                   ON tb_recursos_osc.cd_fonte_recursos_osc = dc_fonte_recursos_osc.cd_fonte_recursos_osc
         LEFT JOIN syst.dc_origem_fonte_recursos_osc ON dc_fonte_recursos_osc.cd_origem_fonte_recursos_osc =
                                                        dc_origem_fonte_recursos_osc.cd_origem_fonte_recursos_osc
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
  AND tb_osc.id_osc <> 789809
  AND tb_localizacao.cd_municipio IS NOT NULL
  AND tb_recursos_osc.dt_ano_recursos_osc IS NOT NULL
GROUP BY (tb_localizacao.cd_municipio::text), (date_part('year'::text, tb_recursos_osc.dt_ano_recursos_osc)::text),
         dc_origem_fonte_recursos_osc.tx_nome_origem_fonte_recursos_osc;
