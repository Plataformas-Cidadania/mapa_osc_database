drop view analysis.vw_perfil_localidade_qtd_trabalhadores;
create view analysis.vw_perfil_localidade_qtd_trabalhadores as
    SELECT substr(tb_localizacao.cd_municipio::text, 1, 1)                     AS localidade,
       sum(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0))     AS vinculos,
       sum(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0)) AS deficiencia,
       sum(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)) AS voluntarios,
       sum(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) +
           COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) +
           COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)) AS total,
       replace(('{'::text || btrim(translate(((SELECT array_agg(translate(a.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(array_cat(array_cat(array_cat(
                                                                                                                  array_agg(DISTINCT COALESCE(tb_osc.ft_osc_ativa, ''::text)),
                                                                                                                  array_agg(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''::text))),
                                                                                                          array_agg(
                                                                                                                  DISTINCT
                                                                                                                  COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, ''::text))),
                                                                                                array_agg(DISTINCT
                                                                                                          COALESCE(
                                                                                                                  tb_relacoes_trabalho.ft_trabalhadores_deficiencia,
                                                                                                                  ''::text))),
                                                                                      array_agg(DISTINCT COALESCE(
                                                                                              tb_relacoes_trabalho.ft_trabalhadores_voluntarios,
                                                                                              ''::text)))) AS unnest) a))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
               ','::text)::text[]                                          AS fontes
FROM osc.tb_osc
         LEFT JOIN osc.tb_relacoes_trabalho ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
  AND tb_osc.id_osc <> 789809
  AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY (substr(tb_localizacao.cd_municipio::text, 1, 1))
UNION
SELECT COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 2), 'Sem informação'::text) AS localidade,
       sum(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0))                   AS vinculos,
       sum(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0))               AS deficiencia,
       sum(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0))               AS voluntarios,
       sum(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) +
           COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) +
           COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0))               AS total,
       replace(('{'::text || btrim(translate(((SELECT array_agg(translate(a.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(array_cat(array_cat(array_cat(
                                                                                                                  array_agg(DISTINCT COALESCE(tb_osc.ft_osc_ativa, ''::text)),
                                                                                                                  array_agg(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''::text))),
                                                                                                          array_agg(
                                                                                                                  DISTINCT
                                                                                                                  COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, ''::text))),
                                                                                                array_agg(DISTINCT
                                                                                                          COALESCE(
                                                                                                                  tb_relacoes_trabalho.ft_trabalhadores_deficiencia,
                                                                                                                  ''::text))),
                                                                                      array_agg(DISTINCT COALESCE(
                                                                                              tb_relacoes_trabalho.ft_trabalhadores_voluntarios,
                                                                                              ''::text)))) AS unnest) a))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
               ','::text)::text[]                                                        AS fontes
FROM osc.tb_osc
         LEFT JOIN osc.tb_relacoes_trabalho ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
  AND tb_osc.id_osc <> 789809
  AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY (COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 2), 'Sem informação'::text))
UNION
SELECT COALESCE(tb_localizacao.cd_municipio::text, 'Sem informação'::text) AS localidade,
       sum(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0))     AS vinculos,
       sum(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0)) AS deficiencia,
       sum(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)) AS voluntarios,
       sum(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) +
           COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) +
           COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)) AS total,
       replace(('{'::text || btrim(translate(((SELECT array_agg(translate(a.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(array_cat(array_cat(array_cat(
                                                                                                                  array_agg(DISTINCT COALESCE(tb_osc.ft_osc_ativa, ''::text)),
                                                                                                                  array_agg(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''::text))),
                                                                                                          array_agg(
                                                                                                                  DISTINCT
                                                                                                                  COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, ''::text))),
                                                                                                array_agg(DISTINCT
                                                                                                          COALESCE(
                                                                                                                  tb_relacoes_trabalho.ft_trabalhadores_deficiencia,
                                                                                                                  ''::text))),
                                                                                      array_agg(DISTINCT COALESCE(
                                                                                              tb_relacoes_trabalho.ft_trabalhadores_voluntarios,
                                                                                              ''::text)))) AS unnest) a))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
               ','::text)::text[]                                          AS fontes
FROM osc.tb_osc
         LEFT JOIN osc.tb_relacoes_trabalho ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
  AND tb_osc.id_osc <> 789809
  AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY (COALESCE(tb_localizacao.cd_municipio::text, 'Sem informação'::text));