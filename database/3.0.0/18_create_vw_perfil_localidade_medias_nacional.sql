drop view analysis.vw_perfil_localidade_medias_nacional;
create view analysis.vw_perfil_localidade_medias_nacional as
SELECT 'maior_natureza_juridica'::text                                                                   AS tipo_dado,
       array_agg(a.natureza_juridica)                                                                    AS dado,
       max(a.quantidade_osc) / ((SELECT sum(c.quantidade_oscs) AS sum
                                 FROM analysis.vw_perfil_localidade_natureza_juridica c)) * 100::numeric AS valor
FROM (SELECT vw_perfil_localidade_natureza_juridica.natureza_juridica,
             sum(vw_perfil_localidade_natureza_juridica.quantidade_oscs) AS quantidade_osc
      FROM analysis.vw_perfil_localidade_natureza_juridica
      GROUP BY vw_perfil_localidade_natureza_juridica.natureza_juridica) a
         JOIN (SELECT sum(a_1.quantidade_oscs)::double precision AS quantidade_osc
               FROM analysis.vw_perfil_localidade_natureza_juridica a_1
               GROUP BY a_1.natureza_juridica
               ORDER BY (sum(a_1.quantidade_oscs)::double precision) DESC
               LIMIT 1) b ON a.quantidade_osc::double precision = b.quantidade_osc
UNION
SELECT 'maior_repasse_recursos'::text AS tipo_dado,
       array_agg(a.fonte_recursos)    AS dado,
       max(a.valor_recursos) / ((SELECT sum(c.valor_recursos) AS sum
                                 FROM analysis.vw_perfil_localidade_repasse_recursos c)) *
       100::double precision          AS valor
FROM (SELECT vw_perfil_localidade_repasse_recursos.fonte_recursos,
             sum(vw_perfil_localidade_repasse_recursos.valor_recursos) AS valor_recursos
      FROM analysis.vw_perfil_localidade_repasse_recursos
      GROUP BY vw_perfil_localidade_repasse_recursos.fonte_recursos) a
         JOIN (SELECT sum(a_1.valor_recursos) AS valor_recursos
               FROM analysis.vw_perfil_localidade_repasse_recursos a_1
               GROUP BY a_1.fonte_recursos
               ORDER BY (sum(a_1.valor_recursos)) DESC
               LIMIT 1) b ON a.valor_recursos = b.valor_recursos
UNION
SELECT 'media_repasse_recursos'::text                     AS tipo_dado,
       NULL::text[]                                       AS dado,
       sum(a.valor) / sum(a.quantidade)::double precision AS valor
FROM (SELECT count(*)                                                  AS quantidade,
             sum(vw_perfil_localidade_repasse_recursos.valor_recursos) AS valor
      FROM analysis.vw_perfil_localidade_repasse_recursos
      GROUP BY vw_perfil_localidade_repasse_recursos.fonte_recursos) a
UNION
SELECT 'maior_area_atuacao'::text                                                                   AS tipo_dado,
       array_agg(a.area_atuacao)                                                                    AS dado,
       max(a.quantidade_osc) / ((SELECT sum(c.quantidade_oscs) AS sum
                                 FROM analysis.vw_perfil_localidade_area_atuacao c)) * 100::numeric AS valor
FROM (SELECT vw_perfil_localidade_area_atuacao.area_atuacao,
             sum(vw_perfil_localidade_area_atuacao.quantidade_oscs) AS quantidade_osc
      FROM analysis.vw_perfil_localidade_area_atuacao
      GROUP BY vw_perfil_localidade_area_atuacao.area_atuacao) a
         JOIN (SELECT sum(a_1.quantidade_oscs)::double precision AS quantidade_osc
               FROM analysis.vw_perfil_localidade_area_atuacao a_1
               GROUP BY a_1.area_atuacao
               ORDER BY (sum(a_1.quantidade_oscs)::double precision) DESC
               LIMIT 1) b ON a.quantidade_osc::double precision = b.quantidade_osc
UNION
SELECT 'maior_trabalhadores'::text                                                              AS tipo_dado,
       array_agg(a.tipo_trabalhadores)                                                          AS dado,
       max(a.quantidade_trabalhadores) / max(a.total)::double precision * 100::double precision AS valor
FROM (SELECT 'Trabalhadores formais com vínculos'::text                         AS tipo_trabalhadores,
             sum(vw_perfil_localidade_trabalhadores.total)                      AS total,
             sum(vw_perfil_localidade_trabalhadores.vinculos)::double precision AS quantidade_trabalhadores
      FROM analysis.vw_perfil_localidade_trabalhadores
      UNION
      SELECT 'Trabalhadores com deficiência'::text                                 AS tipo_trabalhadores,
             sum(vw_perfil_localidade_trabalhadores.total)                         AS total,
             sum(vw_perfil_localidade_trabalhadores.deficiencia)::double precision AS quantidade_trabalhadores
      FROM analysis.vw_perfil_localidade_trabalhadores
      UNION
      SELECT 'Trabalhadores voluntários'::text                                     AS tipo_trabalhadores,
             sum(vw_perfil_localidade_trabalhadores.total)                         AS total,
             sum(vw_perfil_localidade_trabalhadores.voluntarios)::double precision AS quantidade_trabalhadores
      FROM analysis.vw_perfil_localidade_trabalhadores) a
WHERE (a.quantidade_trabalhadores IN
       (SELECT sum(vw_perfil_localidade_trabalhadores.vinculos)::double precision AS porcentagem_maior_trabalhadores
        FROM analysis.vw_perfil_localidade_trabalhadores
        UNION
        SELECT sum(vw_perfil_localidade_trabalhadores.deficiencia)::double precision AS porcentagem_maior_trabalhadores
        FROM analysis.vw_perfil_localidade_trabalhadores
        UNION
        SELECT sum(vw_perfil_localidade_trabalhadores.voluntarios)::double precision AS porcentagem_maior_trabalhadores
        FROM analysis.vw_perfil_localidade_trabalhadores
        ORDER BY 1 DESC
        LIMIT 1));