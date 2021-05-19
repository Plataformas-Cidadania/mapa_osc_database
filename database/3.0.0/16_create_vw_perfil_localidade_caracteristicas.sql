drop view analysis.vw_perfil_localidade_caracteristicas_gerais;
create view analysis.vw_perfil_localidade_caracteristicas_gerais as
SELECT quantidade_osc.localidade,
       quantidade_osc.nome_localidade,
       'regiao'::text AS tipo_localidade,
       quantidade_osc.nr_quantidade_osc,
       quantidade_osc.ft_quantidade_osc,
       quantidade_trabalhadores.nr_quantidade_trabalhadores,
       quantidade_trabalhadores.ft_quantidade_trabalhadores,
       quantidade_recursos.nr_quantidade_recursos,
       quantidade_recursos.ft_quantidade_recursos,
       quantidade_projetos.nr_quantidade_projetos,
       quantidade_projetos.ft_quantidade_projetos,
       orcamento.nr_orcamento_empenhado,
       orcamento.ft_orcamento_empenhado
FROM (SELECT COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 1), 'Sem informação'::text) AS localidade,
             COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação'::character varying)::text     AS nome_localidade,
             count(DISTINCT tb_osc.id_osc)                                                     AS nr_quantidade_osc,
             replace(('{'::text ||
                      btrim(translate(((SELECT array_agg(translate(b.*::text, '()'::text, ''::text)) AS array_agg
                                        FROM (SELECT DISTINCT unnest(array_cat(
                                                array_agg(DISTINCT COALESCE(tb_osc.ft_osc_ativa, ''::text)),
                                                array_agg(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''::text)))) AS a) b))::text,
                                      '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
                     ','::text)::text[]                                                        AS ft_quantidade_osc
      FROM osc.tb_osc
               LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
               LEFT JOIN spat.ed_regiao ON ed_regiao.edre_cd_regiao = substr(tb_localizacao.cd_municipio::text, 1, 1)::numeric
      WHERE tb_osc.bo_osc_ativa
        AND tb_osc.id_osc <> 789809
        AND tb_localizacao.cd_municipio IS NOT NULL
      GROUP BY (COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 1), 'Sem informação'::text)),
               (COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação'::character varying)::text)) quantidade_osc
         LEFT JOIN (SELECT COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 1),
                                    'Sem informação'::text)                                    AS localidade,
                           sum(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) +
                               COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) +
                               COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)) AS nr_quantidade_trabalhadores,
                           replace(('{'::text || btrim(
                                   translate(((SELECT array_agg(translate(a.*::text, '()'::text, ''::text)) AS array_agg
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
                                   ','::text)::text[]                                          AS ft_quantidade_trabalhadores
                    FROM osc.tb_osc
                             LEFT JOIN osc.tb_relacoes_trabalho ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
                             LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
                    WHERE tb_osc.bo_osc_ativa
                      AND tb_osc.id_osc <> 789809
                      AND tb_localizacao.cd_municipio IS NOT NULL
                    GROUP BY (COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 1),
                                       'Sem informação'::text))) quantidade_trabalhadores
                   ON quantidade_osc.localidade = quantidade_trabalhadores.localidade
         LEFT JOIN (SELECT COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 1),
                                    'Sem informação'::text)                                  AS localidade,
                           COALESCE(sum(COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0::double precision) +
                                        COALESCE(tb_recursos_outro_osc.nr_valor_recursos_outro_osc,
                                                 0::double precision)), 0::double precision) AS nr_quantidade_recursos,
                           replace(('{'::text || btrim(
                                   translate(((SELECT array_agg(translate(b.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(array_agg(DISTINCT
                                                                                                COALESCE(tb_recursos_osc.ft_valor_recursos_osc, ''::text)),
                                                                                      array_agg(DISTINCT COALESCE(
                                                                                              tb_recursos_outro_osc.ft_valor_recursos_outro_osc,
                                                                                              ''::text)))) AS a) b))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
                                   ','::text)::text[]                                        AS ft_quantidade_recursos
                    FROM osc.tb_osc
                             LEFT JOIN osc.tb_recursos_osc ON tb_osc.id_osc = tb_recursos_osc.id_osc
                             LEFT JOIN osc.tb_recursos_outro_osc ON tb_osc.id_osc = tb_recursos_outro_osc.id_osc
                             LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
                    WHERE tb_osc.bo_osc_ativa
                      AND tb_osc.id_osc <> 789809
                      AND tb_localizacao.cd_municipio IS NOT NULL
                    GROUP BY (COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 1),
                                       'Sem informação'::text))) quantidade_recursos
                   ON quantidade_osc.localidade = quantidade_recursos.localidade
         LEFT JOIN (SELECT COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 1),
                                    'Sem informação'::text)      AS localidade,
                           count(DISTINCT tb_projeto.id_projeto) AS nr_quantidade_projetos,
                           replace(('{'::text || btrim(
                                   translate(((SELECT array_agg(translate(b.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(
                                                       array_agg(DISTINCT COALESCE(tb_projeto.ft_nome_projeto, ''::text)),
                                                       array_agg(DISTINCT
                                                                 COALESCE(tb_projeto.ft_identificador_projeto_externo, ''::text)))) AS a) b))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
                                   ','::text)::text[]            AS ft_quantidade_projetos
                    FROM osc.tb_osc
                             LEFT JOIN osc.tb_projeto ON tb_osc.id_osc = tb_projeto.id_osc
                             LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
                    WHERE tb_osc.bo_osc_ativa
                      AND tb_osc.id_osc <> 789809
                      AND tb_localizacao.cd_municipio IS NOT NULL
                    GROUP BY (COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 1),
                                       'Sem informação'::text))) quantidade_projetos
                   ON quantidade_osc.localidade = quantidade_projetos.localidade
         LEFT JOIN (SELECT COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 1),
                                    'Sem informação'::text)                                                         AS localidade,
                           sum(tb_orcamento_def.nr_vl_empenhado_def)                                                AS nr_orcamento_empenhado,
                           '{"SIGA Brasil 2010-2018, Valores deflacionados para dez/2018, IPCA IBGE 2018"}'::text[] AS ft_orcamento_empenhado
                    FROM osc.tb_osc
                             LEFT JOIN graph.tb_orcamento_def
                                       ON tb_osc.cd_identificador_osc = tb_orcamento_def.nr_orcamento_cnpj
                             LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
                             LEFT JOIN spat.ed_regiao
                                       ON ed_regiao.edre_cd_regiao = substr(tb_localizacao.cd_municipio::text, 1, 1)::numeric
                    WHERE tb_osc.bo_osc_ativa
                      AND tb_osc.id_osc <> 789809
                      AND tb_localizacao.cd_municipio IS NOT NULL
                    GROUP BY (COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 1),
                                       'Sem informação'::text))) orcamento
                   ON quantidade_osc.localidade = orcamento.localidade
UNION
SELECT quantidade_osc.localidade,
       quantidade_osc.nome_localidade,
       'estado'::text AS tipo_localidade,
       quantidade_osc.nr_quantidade_osc,
       quantidade_osc.ft_quantidade_osc,
       quantidade_trabalhadores.nr_quantidade_trabalhadores,
       quantidade_trabalhadores.ft_quantidade_trabalhadores,
       quantidade_recursos.nr_quantidade_recursos,
       quantidade_recursos.ft_quantidade_recursos,
       quantidade_projetos.nr_quantidade_projetos,
       quantidade_projetos.ft_quantidade_projetos,
       orcamento.nr_orcamento_empenhado,
       orcamento.ft_orcamento_empenhado
FROM (SELECT COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 2), 'Sem informação'::text) AS localidade,
             COALESCE(ed_uf.eduf_nm_uf, 'Sem informação'::character varying)::text             AS nome_localidade,
             count(DISTINCT tb_osc.id_osc)                                                     AS nr_quantidade_osc,
             replace(('{'::text ||
                      btrim(translate(((SELECT array_agg(translate(b.*::text, '()'::text, ''::text)) AS array_agg
                                        FROM (SELECT DISTINCT unnest(array_cat(
                                                array_agg(DISTINCT COALESCE(tb_osc.ft_osc_ativa, ''::text)),
                                                array_agg(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''::text)))) AS a) b))::text,
                                      '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
                     ','::text)::text[]                                                        AS ft_quantidade_osc
      FROM osc.tb_osc
               LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
               LEFT JOIN spat.ed_uf ON ed_uf.eduf_cd_uf = substr(tb_localizacao.cd_municipio::text, 1, 2)::numeric
      WHERE tb_osc.bo_osc_ativa
        AND tb_osc.id_osc <> 789809
        AND tb_localizacao.cd_municipio IS NOT NULL
      GROUP BY (COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 2), 'Sem informação'::text)),
               (COALESCE(ed_uf.eduf_nm_uf, 'Sem informação'::character varying)::text)) quantidade_osc
         LEFT JOIN (SELECT COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 2),
                                    'Sem informação'::text)                                    AS localidade,
                           sum(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) +
                               COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) +
                               COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)) AS nr_quantidade_trabalhadores,
                           replace(('{'::text || btrim(
                                   translate(((SELECT array_agg(translate(a.*::text, '()'::text, ''::text)) AS array_agg
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
                                   ','::text)::text[]                                          AS ft_quantidade_trabalhadores
                    FROM osc.tb_osc
                             LEFT JOIN osc.tb_relacoes_trabalho ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
                             LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
                    WHERE tb_osc.bo_osc_ativa
                      AND tb_osc.id_osc <> 789809
                      AND tb_localizacao.cd_municipio IS NOT NULL
                    GROUP BY (COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 2),
                                       'Sem informação'::text))) quantidade_trabalhadores
                   ON quantidade_osc.localidade = quantidade_trabalhadores.localidade
         LEFT JOIN (SELECT COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 2),
                                    'Sem informação'::text)                                  AS localidade,
                           COALESCE(sum(COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0::double precision) +
                                        COALESCE(tb_recursos_outro_osc.nr_valor_recursos_outro_osc,
                                                 0::double precision)), 0::double precision) AS nr_quantidade_recursos,
                           replace(('{'::text || btrim(
                                   translate(((SELECT array_agg(translate(b.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(array_agg(DISTINCT
                                                                                                COALESCE(tb_recursos_osc.ft_valor_recursos_osc, ''::text)),
                                                                                      array_agg(DISTINCT COALESCE(
                                                                                              tb_recursos_outro_osc.ft_valor_recursos_outro_osc,
                                                                                              ''::text)))) AS a) b))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
                                   ','::text)::text[]                                        AS ft_quantidade_recursos
                    FROM osc.tb_osc
                             LEFT JOIN osc.tb_recursos_osc ON tb_osc.id_osc = tb_recursos_osc.id_osc
                             LEFT JOIN osc.tb_recursos_outro_osc ON tb_osc.id_osc = tb_recursos_outro_osc.id_osc
                             LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
                    WHERE tb_osc.bo_osc_ativa
                      AND tb_osc.id_osc <> 789809
                      AND tb_localizacao.cd_municipio IS NOT NULL
                    GROUP BY (COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 2),
                                       'Sem informação'::text))) quantidade_recursos
                   ON quantidade_osc.localidade = quantidade_recursos.localidade
         LEFT JOIN (SELECT COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 2),
                                    'Sem informação'::text)      AS localidade,
                           count(DISTINCT tb_projeto.id_projeto) AS nr_quantidade_projetos,
                           replace(('{'::text || btrim(
                                   translate(((SELECT array_agg(translate(b.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(
                                                       array_agg(DISTINCT COALESCE(tb_projeto.ft_nome_projeto, ''::text)),
                                                       array_agg(DISTINCT
                                                                 COALESCE(tb_projeto.ft_identificador_projeto_externo, ''::text)))) AS a) b))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
                                   ','::text)::text[]            AS ft_quantidade_projetos
                    FROM osc.tb_osc
                             LEFT JOIN osc.tb_projeto ON tb_osc.id_osc = tb_projeto.id_osc
                             LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
                    WHERE tb_osc.bo_osc_ativa
                      AND tb_osc.id_osc <> 789809
                      AND tb_localizacao.cd_municipio IS NOT NULL
                    GROUP BY (COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 2),
                                       'Sem informação'::text))) quantidade_projetos
                   ON quantidade_osc.localidade = quantidade_projetos.localidade
         LEFT JOIN (SELECT COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 2),
                                    'Sem informação'::text)                                                         AS localidade,
                           sum(tb_orcamento_def.nr_vl_empenhado_def)                                                AS nr_orcamento_empenhado,
                           '{"SIGA Brasil 2010-2018, Valores deflacionados para dez/2018, IPCA IBGE 2018"}'::text[] AS ft_orcamento_empenhado
                    FROM osc.tb_osc
                             LEFT JOIN graph.tb_orcamento_def
                                       ON tb_osc.cd_identificador_osc = tb_orcamento_def.nr_orcamento_cnpj
                             LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
                             LEFT JOIN spat.ed_regiao
                                       ON ed_regiao.edre_cd_regiao = substr(tb_localizacao.cd_municipio::text, 1, 2)::numeric
                    WHERE tb_osc.bo_osc_ativa
                      AND tb_osc.id_osc <> 789809
                      AND tb_localizacao.cd_municipio IS NOT NULL
                    GROUP BY (COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 2),
                                       'Sem informação'::text))) orcamento
                   ON quantidade_osc.localidade = orcamento.localidade
UNION
SELECT quantidade_osc.localidade,
       quantidade_osc.nome_localidade,
       'municipio'::text AS tipo_localidade,
       quantidade_osc.nr_quantidade_osc,
       quantidade_osc.ft_quantidade_osc,
       quantidade_trabalhadores.nr_quantidade_trabalhadores,
       quantidade_trabalhadores.ft_quantidade_trabalhadores,
       quantidade_recursos.nr_quantidade_recursos,
       quantidade_recursos.ft_quantidade_recursos,
       quantidade_projetos.nr_quantidade_projetos,
       quantidade_projetos.ft_quantidade_projetos,
       orcamento.nr_orcamento_empenhado,
       orcamento.ft_orcamento_empenhado
FROM (SELECT COALESCE(tb_localizacao.cd_municipio::text, 'Sem informação'::text) AS localidade,
             COALESCE((ed_municipio.edmu_nm_municipio::text || ' - '::text) || ed_uf.eduf_sg_uf::text,
                      'Sem informação'::text)                                    AS nome_localidade,
             count(DISTINCT tb_osc.id_osc)                                       AS nr_quantidade_osc,
             replace(('{'::text ||
                      btrim(translate(((SELECT array_agg(translate(b.*::text, '()'::text, ''::text)) AS array_agg
                                        FROM (SELECT DISTINCT unnest(array_cat(
                                                array_agg(DISTINCT COALESCE(tb_osc.ft_osc_ativa, ''::text)),
                                                array_agg(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''::text)))) AS a) b))::text,
                                      '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
                     ','::text)::text[]                                          AS ft_quantidade_osc
      FROM osc.tb_osc
               LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
               LEFT JOIN spat.ed_municipio ON ed_municipio.edmu_cd_municipio = tb_localizacao.cd_municipio
               LEFT JOIN spat.ed_uf ON ed_uf.eduf_cd_uf = ed_municipio.eduf_cd_uf::numeric
      WHERE tb_osc.bo_osc_ativa
        AND tb_osc.id_osc <> 789809
        AND tb_localizacao.cd_municipio IS NOT NULL
      GROUP BY (COALESCE(tb_localizacao.cd_municipio::text, 'Sem informação'::text)),
               (COALESCE((ed_municipio.edmu_nm_municipio::text || ' - '::text) || ed_uf.eduf_sg_uf::text,
                         'Sem informação'::text))) quantidade_osc
         LEFT JOIN (SELECT COALESCE(tb_localizacao.cd_municipio::text, 'Sem informação'::text) AS localidade,
                           sum(COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) +
                               COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) +
                               COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0)) AS nr_quantidade_trabalhadores,
                           replace(('{'::text || btrim(
                                   translate(((SELECT array_agg(translate(a.*::text, '()'::text, ''::text)) AS array_agg
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
                                   ','::text)::text[]                                          AS ft_quantidade_trabalhadores
                    FROM osc.tb_osc
                             LEFT JOIN osc.tb_relacoes_trabalho ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc
                             LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
                    WHERE tb_osc.bo_osc_ativa
                      AND tb_osc.id_osc <> 789809
                      AND tb_localizacao.cd_municipio IS NOT NULL
                    GROUP BY (COALESCE(tb_localizacao.cd_municipio::text, 'Sem informação'::text))) quantidade_trabalhadores
                   ON quantidade_osc.localidade = quantidade_trabalhadores.localidade
         LEFT JOIN (SELECT COALESCE(tb_localizacao.cd_municipio::text, 'Sem informação'::text) AS localidade,
                           COALESCE(sum(COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0::double precision) +
                                        COALESCE(tb_recursos_outro_osc.nr_valor_recursos_outro_osc,
                                                 0::double precision)),
                                    0::double precision)                                       AS nr_quantidade_recursos,
                           replace(('{'::text || btrim(
                                   translate(((SELECT array_agg(translate(b.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(array_agg(DISTINCT
                                                                                                COALESCE(tb_recursos_osc.ft_valor_recursos_osc, ''::text)),
                                                                                      array_agg(DISTINCT COALESCE(
                                                                                              tb_recursos_outro_osc.ft_valor_recursos_outro_osc,
                                                                                              ''::text)))) AS a) b))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
                                   ','::text)::text[]                                          AS ft_quantidade_recursos
                    FROM osc.tb_osc
                             LEFT JOIN osc.tb_recursos_osc ON tb_osc.id_osc = tb_recursos_osc.id_osc
                             LEFT JOIN osc.tb_recursos_outro_osc ON tb_osc.id_osc = tb_recursos_outro_osc.id_osc
                             LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
                    WHERE tb_osc.bo_osc_ativa
                      AND tb_osc.id_osc <> 789809
                      AND tb_localizacao.cd_municipio IS NOT NULL
                    GROUP BY (COALESCE(tb_localizacao.cd_municipio::text, 'Sem informação'::text))) quantidade_recursos
                   ON quantidade_osc.localidade = quantidade_recursos.localidade
         LEFT JOIN (SELECT COALESCE(tb_localizacao.cd_municipio::text, 'Sem informação'::text) AS localidade,
                           count(DISTINCT tb_projeto.id_projeto)                               AS nr_quantidade_projetos,
                           replace(('{'::text || btrim(
                                   translate(((SELECT array_agg(translate(b.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(
                                                       array_agg(DISTINCT COALESCE(tb_projeto.ft_nome_projeto, ''::text)),
                                                       array_agg(DISTINCT
                                                                 COALESCE(tb_projeto.ft_identificador_projeto_externo, ''::text)))) AS a) b))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
                                   ','::text)::text[]                                          AS ft_quantidade_projetos
                    FROM osc.tb_osc
                             LEFT JOIN osc.tb_projeto ON tb_osc.id_osc = tb_projeto.id_osc
                             LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
                    WHERE tb_osc.bo_osc_ativa
                      AND tb_osc.id_osc <> 789809
                      AND tb_localizacao.cd_municipio IS NOT NULL
                    GROUP BY (COALESCE(tb_localizacao.cd_municipio::text, 'Sem informação'::text))) quantidade_projetos
                   ON quantidade_osc.localidade = quantidade_projetos.localidade
         LEFT JOIN (SELECT COALESCE(tb_localizacao.cd_municipio::text, 'Sem informação'::text)                      AS localidade,
                           sum(tb_orcamento_def.nr_vl_empenhado_def)                                                AS nr_orcamento_empenhado,
                           '{"SIGA Brasil 2010-2018, Valores deflacionados para dez/2018, IPCA IBGE 2018"}'::text[] AS ft_orcamento_empenhado
                    FROM osc.tb_osc
                             LEFT JOIN graph.tb_orcamento_def
                                       ON tb_osc.cd_identificador_osc = tb_orcamento_def.nr_orcamento_cnpj
                             LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
                             LEFT JOIN spat.ed_regiao
                                       ON ed_regiao.edre_cd_regiao = substr(tb_localizacao.cd_municipio::text, 1, 2)::numeric
                    WHERE tb_osc.bo_osc_ativa
                      AND tb_osc.id_osc <> 789809
                      AND tb_localizacao.cd_municipio IS NOT NULL
                    GROUP BY (COALESCE(tb_localizacao.cd_municipio::text, 'Sem informação'::text))) orcamento
                   ON quantidade_osc.localidade = orcamento.localidade;