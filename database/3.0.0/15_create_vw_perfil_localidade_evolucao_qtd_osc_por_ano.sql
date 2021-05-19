drop view analysis.vw_perfil_localidade_evolucao_qtd_osc_por_ano;
create view analysis.vw_perfil_localidade_evolucao_qtd_osc_por_ano as
SELECT substr(tb_localizacao.cd_municipio::text, 1, 1)                   AS localidade,
       date_part('year'::text, tb_dados_gerais.dt_fundacao_osc)::integer AS ano_fundacao,
       count(DISTINCT tb_osc.id_osc)                                     AS quantidade_oscs,
       replace(('{'::text || btrim(translate(((SELECT array_agg(translate(a.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(array_cat(
                                                                                              array_agg(DISTINCT COALESCE(tb_osc.ft_osc_ativa, ''::text)),
                                                                                              array_agg(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''::text))),
                                                                                      array_agg(DISTINCT
                                                                                                COALESCE(tb_dados_gerais.ft_fundacao_osc, ''::text)))) AS unnest) a))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
               ','::text)::text[]                                        AS fontes
FROM osc.tb_osc
         LEFT JOIN osc.tb_dados_gerais ON tb_osc.id_osc = tb_dados_gerais.id_osc
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
  AND tb_osc.id_osc <> 789809
  AND tb_localizacao.cd_municipio IS NOT NULL
  AND tb_dados_gerais.dt_fundacao_osc > '1500-01-01'::date
GROUP BY (substr(tb_localizacao.cd_municipio::text, 1, 1)),
         (date_part('year'::text, tb_dados_gerais.dt_fundacao_osc)::integer)
UNION
SELECT substr(tb_localizacao.cd_municipio::text, 1, 2)                   AS localidade,
       date_part('year'::text, tb_dados_gerais.dt_fundacao_osc)::integer AS ano_fundacao,
       count(DISTINCT tb_osc.id_osc)                                     AS quantidade_oscs,
       replace(('{'::text || btrim(translate(((SELECT array_agg(translate(a.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(array_cat(
                                                                                              array_agg(DISTINCT COALESCE(tb_osc.ft_osc_ativa, ''::text)),
                                                                                              array_agg(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''::text))),
                                                                                      array_agg(DISTINCT
                                                                                                COALESCE(tb_dados_gerais.ft_fundacao_osc, ''::text)))) AS unnest) a))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
               ','::text)::text[]                                        AS fontes
FROM osc.tb_osc
         LEFT JOIN osc.tb_dados_gerais ON tb_osc.id_osc = tb_dados_gerais.id_osc
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
  AND tb_osc.id_osc <> 789809
  AND tb_localizacao.cd_municipio IS NOT NULL
  AND tb_dados_gerais.dt_fundacao_osc > '1500-01-01'::date
GROUP BY (substr(tb_localizacao.cd_municipio::text, 1, 2)),
         (date_part('year'::text, tb_dados_gerais.dt_fundacao_osc)::integer)
UNION
SELECT tb_localizacao.cd_municipio::text                                 AS localidade,
       date_part('year'::text, tb_dados_gerais.dt_fundacao_osc)::integer AS ano_fundacao,
       count(DISTINCT tb_osc.id_osc)                                     AS quantidade_oscs,
       replace(('{'::text || btrim(translate(((SELECT array_agg(translate(a.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(array_cat(
                                                                                              array_agg(DISTINCT COALESCE(tb_osc.ft_osc_ativa, ''::text)),
                                                                                              array_agg(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''::text))),
                                                                                      array_agg(DISTINCT
                                                                                                COALESCE(tb_dados_gerais.ft_fundacao_osc, ''::text)))) AS unnest) a))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
               ','::text)::text[]                                        AS fontes
FROM osc.tb_osc
         LEFT JOIN osc.tb_dados_gerais ON tb_osc.id_osc = tb_dados_gerais.id_osc
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
  AND tb_osc.id_osc <> 789809
  AND tb_localizacao.cd_municipio IS NOT NULL
  AND tb_dados_gerais.dt_fundacao_osc > '1500-01-01'::date
GROUP BY (tb_localizacao.cd_municipio::text), (date_part('year'::text, tb_dados_gerais.dt_fundacao_osc)::integer);