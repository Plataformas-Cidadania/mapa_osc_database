create materialized view analysis.vw_perfil_localidade_maior_area_atuacao as
    SELECT a.localidade,
           array_agg(a.area_atuacao)                             AS area_atuacao,
           (((max(a.quantidade_oscs))::double precision /
             ((SELECT sum(vw_perfil_localidade_area_atuacao.quantidade_oscs) AS sum
               FROM analysis.vw_perfil_localidade_area_atuacao
               WHERE (vw_perfil_localidade_area_atuacao.localidade = a.localidade)))::double precision) *
            (100)::double precision)                             AS porcertagem_maior,
           (replace((('{'::text ||
                      btrim(translate((array_agg((a.fontes)::text))::text, '"\{}'::text, ''::text), ','::text)) ||
                     '}'::text), ',,'::text, ','::text))::text[] AS fontes
    FROM (analysis.vw_perfil_localidade_area_atuacao a
             RIGHT JOIN (SELECT vw_perfil_localidade_area_atuacao.localidade,
                                max(vw_perfil_localidade_area_atuacao.quantidade_oscs) AS quantidade_oscs
                         FROM analysis.vw_perfil_localidade_area_atuacao
                         WHERE (((
                                     CASE
                                         WHEN ("substring"(vw_perfil_localidade_area_atuacao.localidade,
                                                           '[0-9]*'::text) = ''::text) THEN '0'::text
                                         ELSE "substring"(vw_perfil_localidade_area_atuacao.localidade, '[0-9]*'::text)
                                         END)::integer >= 1) AND ((
                                                                      CASE
                                                                          WHEN ("substring"(
                                                                                        vw_perfil_localidade_area_atuacao.localidade,
                                                                                        '[0-9]*'::text) = ''::text)
                                                                              THEN '0'::text
                                                                          ELSE "substring"(
                                                                                  vw_perfil_localidade_area_atuacao.localidade,
                                                                                  '[0-9]*'::text)
                                                                          END)::integer <= 9))
                         GROUP BY vw_perfil_localidade_area_atuacao.localidade) b
                        ON (((a.localidade = b.localidade) AND (a.quantidade_oscs = b.quantidade_oscs))))
    GROUP BY a.localidade
    UNION
    SELECT a.localidade,
           array_agg(a.area_atuacao)                             AS area_atuacao,
           (((max(a.quantidade_oscs))::double precision /
             ((SELECT sum(vw_perfil_localidade_area_atuacao.quantidade_oscs) AS sum
               FROM analysis.vw_perfil_localidade_area_atuacao
               WHERE (vw_perfil_localidade_area_atuacao.localidade = a.localidade)))::double precision) *
            (100)::double precision)                             AS porcertagem_maior,
           (replace((('{'::text ||
                      btrim(translate((array_agg((a.fontes)::text))::text, '"\{}'::text, ''::text), ','::text)) ||
                     '}'::text), ',,'::text, ','::text))::text[] AS fontes
    FROM (analysis.vw_perfil_localidade_area_atuacao a
             RIGHT JOIN (SELECT vw_perfil_localidade_area_atuacao.localidade,
                                max(vw_perfil_localidade_area_atuacao.quantidade_oscs) AS quantidade_oscs
                         FROM analysis.vw_perfil_localidade_area_atuacao
                         WHERE (((
                                     CASE
                                         WHEN ("substring"(vw_perfil_localidade_area_atuacao.localidade,
                                                           '[0-9]*'::text) = ''::text) THEN '0'::text
                                         ELSE "substring"(vw_perfil_localidade_area_atuacao.localidade, '[0-9]*'::text)
                                         END)::integer >= 10) AND ((
                                                                       CASE
                                                                           WHEN ("substring"(
                                                                                         vw_perfil_localidade_area_atuacao.localidade,
                                                                                         '[0-9]*'::text) = ''::text)
                                                                               THEN '0'::text
                                                                           ELSE "substring"(
                                                                                   vw_perfil_localidade_area_atuacao.localidade,
                                                                                   '[0-9]*'::text)
                                                                           END)::integer <= 99))
                         GROUP BY vw_perfil_localidade_area_atuacao.localidade) b
                        ON (((a.localidade = b.localidade) AND (a.quantidade_oscs = b.quantidade_oscs))))
    GROUP BY a.localidade
    UNION
    SELECT a.localidade,
           array_agg(a.area_atuacao)                             AS area_atuacao,
           (((max(a.quantidade_oscs))::double precision /
             ((SELECT sum(vw_perfil_localidade_area_atuacao.quantidade_oscs) AS sum
               FROM analysis.vw_perfil_localidade_area_atuacao
               WHERE (vw_perfil_localidade_area_atuacao.localidade = a.localidade)))::double precision) *
            (100)::double precision)                             AS porcertagem_maior,
           (replace((('{'::text ||
                      btrim(translate((array_agg((a.fontes)::text))::text, '"\{}'::text, ''::text), ','::text)) ||
                     '}'::text), ',,'::text, ','::text))::text[] AS fontes
    FROM (analysis.vw_perfil_localidade_area_atuacao a
             RIGHT JOIN (SELECT vw_perfil_localidade_area_atuacao.localidade,
                                max(vw_perfil_localidade_area_atuacao.quantidade_oscs) AS quantidade_oscs
                         FROM analysis.vw_perfil_localidade_area_atuacao
                         WHERE ((
                                    CASE
                                        WHEN ("substring"(vw_perfil_localidade_area_atuacao.localidade,
                                                          '[0-9]*'::text) = ''::text) THEN '0'::text
                                        ELSE "substring"(vw_perfil_localidade_area_atuacao.localidade, '[0-9]*'::text)
                                        END)::integer > 99)
                         GROUP BY vw_perfil_localidade_area_atuacao.localidade) b
                        ON (((a.localidade = b.localidade) AND (a.quantidade_oscs = b.quantidade_oscs))))
    GROUP BY a.localidade;

alter materialized view analysis.vw_perfil_localidade_maior_area_atuacao owner to i3geo;

create index ix_localidade_vw_perfil_localidade_maior_area_atuacao
    on analysis.vw_perfil_localidade_maior_area_atuacao (localidade);