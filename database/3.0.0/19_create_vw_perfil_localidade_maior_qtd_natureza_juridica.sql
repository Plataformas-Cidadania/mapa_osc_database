drop view analysis.vw_perfil_localidade_maior_qtd_natureza_juridica;
create view analysis.vw_perfil_localidade_maior_qtd_natureza_juridica as
    SELECT a.localidade,
       array_agg(a.natureza_juridica)                    AS natureza_juridica,
       max(a.quantidade_oscs)::double precision /
       ((SELECT sum(vw_perfil_localidade_natureza_juridica.quantidade_oscs) AS sum
         FROM analysis.vw_perfil_localidade_natureza_juridica
         WHERE vw_perfil_localidade_natureza_juridica.localidade = a.localidade))::double precision *
       100::double precision                             AS porcertagem_maior,
       replace(('{'::text || btrim(translate(array_agg(a.fontes::text)::text, '"\{}'::text, ''::text), ','::text)) ||
               '}'::text, ',,'::text, ','::text)::text[] AS fontes
FROM analysis.vw_perfil_localidade_natureza_juridica a
         RIGHT JOIN (SELECT vw_perfil_localidade_natureza_juridica.localidade,
                            max(vw_perfil_localidade_natureza_juridica.quantidade_oscs) AS quantidade_oscs
                     FROM analysis.vw_perfil_localidade_natureza_juridica
                     WHERE CASE
                               WHEN "substring"(vw_perfil_localidade_natureza_juridica.localidade, '[0-9]*'::text) = ''::text
                                   THEN '0'::text
                               ELSE "substring"(vw_perfil_localidade_natureza_juridica.localidade, '[0-9]*'::text)
                               END::integer >= 1
                       AND CASE
                               WHEN "substring"(vw_perfil_localidade_natureza_juridica.localidade, '[0-9]*'::text) = ''::text
                                   THEN '0'::text
                               ELSE "substring"(vw_perfil_localidade_natureza_juridica.localidade, '[0-9]*'::text)
                               END::integer <= 9
                     GROUP BY vw_perfil_localidade_natureza_juridica.localidade) b
                    ON a.localidade = b.localidade AND a.quantidade_oscs = b.quantidade_oscs
GROUP BY a.localidade
UNION
SELECT a.localidade,
       array_agg(a.natureza_juridica)                    AS natureza_juridica,
       max(a.quantidade_oscs)::double precision /
       ((SELECT sum(vw_perfil_localidade_natureza_juridica.quantidade_oscs) AS sum
         FROM analysis.vw_perfil_localidade_natureza_juridica
         WHERE vw_perfil_localidade_natureza_juridica.localidade = a.localidade))::double precision *
       100::double precision                             AS porcertagem_maior,
       replace(('{'::text || btrim(translate(array_agg(a.fontes::text)::text, '"\{}'::text, ''::text), ','::text)) ||
               '}'::text, ',,'::text, ','::text)::text[] AS fontes
FROM analysis.vw_perfil_localidade_natureza_juridica a
         RIGHT JOIN (SELECT vw_perfil_localidade_natureza_juridica.localidade,
                            max(vw_perfil_localidade_natureza_juridica.quantidade_oscs) AS quantidade_oscs
                     FROM analysis.vw_perfil_localidade_natureza_juridica
                     WHERE CASE
                               WHEN "substring"(vw_perfil_localidade_natureza_juridica.localidade, '[0-9]*'::text) = ''::text
                                   THEN '0'::text
                               ELSE "substring"(vw_perfil_localidade_natureza_juridica.localidade, '[0-9]*'::text)
                               END::integer >= 10
                       AND CASE
                               WHEN "substring"(vw_perfil_localidade_natureza_juridica.localidade, '[0-9]*'::text) = ''::text
                                   THEN '0'::text
                               ELSE "substring"(vw_perfil_localidade_natureza_juridica.localidade, '[0-9]*'::text)
                               END::integer <= 99
                     GROUP BY vw_perfil_localidade_natureza_juridica.localidade) b
                    ON a.localidade = b.localidade AND a.quantidade_oscs = b.quantidade_oscs
GROUP BY a.localidade
UNION
SELECT a.localidade,
       array_agg(a.natureza_juridica)                    AS natureza_juridica,
       max(a.quantidade_oscs)::double precision /
       ((SELECT sum(vw_perfil_localidade_natureza_juridica.quantidade_oscs) AS sum
         FROM analysis.vw_perfil_localidade_natureza_juridica
         WHERE vw_perfil_localidade_natureza_juridica.localidade = a.localidade))::double precision *
       100::double precision                             AS porcertagem_maior,
       replace(('{'::text || btrim(translate(array_agg(a.fontes::text)::text, '"\{}'::text, ''::text), ','::text)) ||
               '}'::text, ',,'::text, ','::text)::text[] AS fontes
FROM analysis.vw_perfil_localidade_natureza_juridica a
         RIGHT JOIN (SELECT vw_perfil_localidade_natureza_juridica.localidade,
                            max(vw_perfil_localidade_natureza_juridica.quantidade_oscs) AS quantidade_oscs
                     FROM analysis.vw_perfil_localidade_natureza_juridica
                     WHERE CASE
                               WHEN "substring"(vw_perfil_localidade_natureza_juridica.localidade, '[0-9]*'::text) = ''::text
                                   THEN '0'::text
                               ELSE "substring"(vw_perfil_localidade_natureza_juridica.localidade, '[0-9]*'::text)
                               END::integer > 99
                     GROUP BY vw_perfil_localidade_natureza_juridica.localidade) b
                    ON a.localidade = b.localidade AND a.quantidade_oscs = b.quantidade_oscs
GROUP BY a.localidade;
