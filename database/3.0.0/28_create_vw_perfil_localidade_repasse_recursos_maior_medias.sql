drop view analysis.vw_perfil_localidade_repasse_recursos_maior_medias;
create view analysis.vw_perfil_localidade_repasse_recursos_maior_medias as
SELECT a.localidade,
       array_agg(a.fonte_recursos)                                             AS tipo_repasse,
       (SELECT CASE
                   WHEN sum(analysis.vw_perfil_localidade_repasse_recursos_por_ano.valor_recursos) > 0::double precision THEN
                           count(*)::double precision / sum(analysis.vw_perfil_localidade_repasse_recursos_por_ano.valor_recursos)
                   ELSE 0::double precision
                   END AS "case"
        FROM analysis.vw_perfil_localidade_repasse_recursos_por_ano
        WHERE analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade = a.localidade) AS media,
       CASE
           WHEN max(a.valor_recursos) > 0::double precision THEN
                       max(a.valor_recursos) / ((SELECT sum(analysis.vw_perfil_localidade_repasse_recursos_por_ano.valor_recursos) AS sum
                                                 FROM analysis.vw_perfil_localidade_repasse_recursos_por_ano
                                                 WHERE analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade = a.localidade)) *
                       100::double precision
           ELSE 0::double precision
           END                                                                 AS porcertagem_maior,
       replace(('{'::text || btrim(translate(array_agg(a.fontes::text)::text, '"\{}'::text, ''::text), ','::text)) ||
               '}'::text, ',,'::text, ','::text)::text[]                       AS fontes
FROM analysis.vw_perfil_localidade_repasse_recursos_por_ano a
         RIGHT JOIN (SELECT analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade,
                            max(analysis.vw_perfil_localidade_repasse_recursos_por_ano.valor_recursos) AS valor_recursos
                     FROM analysis.vw_perfil_localidade_repasse_recursos_por_ano
                     WHERE CASE
                               WHEN "substring"(analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text) = ''::text
                                   THEN '0'::text
                               ELSE "substring"(analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text)
                               END::integer >= 1
                       AND CASE
                               WHEN "substring"(analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text) = ''::text
                                   THEN '0'::text
                               ELSE "substring"(analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text)
                               END::integer <= 9
                     GROUP BY analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade) b
                    ON a.localidade = b.localidade AND a.valor_recursos = b.valor_recursos
GROUP BY a.localidade
UNION
SELECT a.localidade,
       array_agg(a.fonte_recursos)                                             AS tipo_repasse,
       (SELECT CASE
                   WHEN sum(analysis.vw_perfil_localidade_repasse_recursos_por_ano.valor_recursos) > 0::double precision THEN
                           count(*)::double precision / sum(analysis.vw_perfil_localidade_repasse_recursos_por_ano.valor_recursos)
                   ELSE 0::double precision
                   END AS "case"
        FROM analysis.vw_perfil_localidade_repasse_recursos_por_ano
        WHERE analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade = a.localidade) AS media,
       CASE
           WHEN max(a.valor_recursos) > 0::double precision THEN
                       max(a.valor_recursos) / ((SELECT sum(analysis.vw_perfil_localidade_repasse_recursos_por_ano.valor_recursos) AS sum
                                                 FROM analysis.vw_perfil_localidade_repasse_recursos_por_ano
                                                 WHERE analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade = a.localidade)) *
                       100::double precision
           ELSE 0::double precision
           END                                                                 AS porcertagem_maior,
       replace(('{'::text || btrim(translate(array_agg(a.fontes::text)::text, '"\{}'::text, ''::text), ','::text)) ||
               '}'::text, ',,'::text, ','::text)::text[]                       AS fontes
FROM analysis.vw_perfil_localidade_repasse_recursos_por_ano a
         RIGHT JOIN (SELECT analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade,
                            max(analysis.vw_perfil_localidade_repasse_recursos_por_ano.valor_recursos) AS valor_recursos
                     FROM analysis.vw_perfil_localidade_repasse_recursos_por_ano
                     WHERE CASE
                               WHEN "substring"(analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text) = ''::text
                                   THEN '0'::text
                               ELSE "substring"(analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text)
                               END::integer >= 10
                       AND CASE
                               WHEN "substring"(analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text) = ''::text
                                   THEN '0'::text
                               ELSE "substring"(analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text)
                               END::integer <= 99
                     GROUP BY analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade) b
                    ON a.localidade = b.localidade AND a.valor_recursos = b.valor_recursos
GROUP BY a.localidade
UNION
SELECT a.localidade,
       array_agg(a.fonte_recursos)                                             AS tipo_repasse,
       (SELECT CASE
                   WHEN sum(analysis.vw_perfil_localidade_repasse_recursos_por_ano.valor_recursos) > 0::double precision THEN
                           count(*)::double precision / sum(analysis.vw_perfil_localidade_repasse_recursos_por_ano.valor_recursos)
                   ELSE 0::double precision
                   END AS "case"
        FROM analysis.vw_perfil_localidade_repasse_recursos_por_ano
        WHERE analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade = a.localidade) AS media,
       CASE
           WHEN max(a.valor_recursos) > 0::double precision THEN
                       max(a.valor_recursos) / ((SELECT sum(analysis.vw_perfil_localidade_repasse_recursos_por_ano.valor_recursos) AS sum
                                                 FROM analysis.vw_perfil_localidade_repasse_recursos_por_ano
                                                 WHERE analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade = a.localidade)) *
                       100::double precision
           ELSE 0::double precision
           END                                                                 AS porcertagem_maior,
       replace(('{'::text || btrim(translate(array_agg(a.fontes::text)::text, '"\{}'::text, ''::text), ','::text)) ||
               '}'::text, ',,'::text, ','::text)::text[]                       AS fontes
FROM analysis.vw_perfil_localidade_repasse_recursos_por_ano a
         RIGHT JOIN (SELECT analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade,
                            max(analysis.vw_perfil_localidade_repasse_recursos_por_ano.valor_recursos) AS valor_recursos
                     FROM analysis.vw_perfil_localidade_repasse_recursos_por_ano
                     WHERE CASE
                               WHEN "substring"(analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text) = ''::text
                                   THEN '0'::text
                               ELSE "substring"(analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text)
                               END::integer > 99
                     GROUP BY analysis.vw_perfil_localidade_repasse_recursos_por_ano.localidade) b
                    ON a.localidade = b.localidade AND a.valor_recursos = b.valor_recursos
GROUP BY a.localidade;