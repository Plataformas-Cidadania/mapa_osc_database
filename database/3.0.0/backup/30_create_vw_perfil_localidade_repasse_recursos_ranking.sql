drop view analysis.vw_perfil_localidade_repasse_recursos_ranking;
create view analysis.vw_perfil_localidade_repasse_recursos_ranking as
    SELECT vw_perfil_localidade_repasse_recursos_por_ano.localidade,
       sum(vw_perfil_localidade_repasse_recursos_por_ano.valor_recursos)                               AS soma_valores,
       rank() OVER (ORDER BY (sum(vw_perfil_localidade_repasse_recursos_por_ano.valor_recursos)) DESC) AS rank,
       'regiao'::text                                                                          AS tipo_rank
FROM analysis.vw_perfil_localidade_repasse_recursos_por_ano
WHERE CASE
          WHEN "substring"(vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text) = ''::text THEN '0'::text
          ELSE "substring"(vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text)
          END::integer >= 1
  AND CASE
          WHEN "substring"(vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text) = ''::text THEN '0'::text
          ELSE "substring"(vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text)
          END::integer <= 9
GROUP BY vw_perfil_localidade_repasse_recursos_por_ano.localidade
UNION
SELECT vw_perfil_localidade_repasse_recursos_por_ano.localidade,
       sum(vw_perfil_localidade_repasse_recursos_por_ano.valor_recursos)                               AS soma_valores,
       rank() OVER (ORDER BY (sum(vw_perfil_localidade_repasse_recursos_por_ano.valor_recursos)) DESC) AS rank,
       'estado'::text                                                                          AS tipo_rank
FROM analysis.vw_perfil_localidade_repasse_recursos_por_ano
WHERE CASE
          WHEN "substring"(vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text) = ''::text THEN '0'::text
          ELSE "substring"(vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text)
          END::integer >= 10
  AND CASE
          WHEN "substring"(vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text) = ''::text THEN '0'::text
          ELSE "substring"(vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text)
          END::integer <= 99
GROUP BY vw_perfil_localidade_repasse_recursos_por_ano.localidade
UNION
SELECT vw_perfil_localidade_repasse_recursos_por_ano.localidade,
       sum(vw_perfil_localidade_repasse_recursos_por_ano.valor_recursos)                               AS soma_valores,
       rank() OVER (ORDER BY (sum(vw_perfil_localidade_repasse_recursos_por_ano.valor_recursos)) DESC) AS rank,
       'municipio'::text                                                                       AS tipo_rank
FROM analysis.vw_perfil_localidade_repasse_recursos_por_ano
WHERE CASE
          WHEN "substring"(vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text) = ''::text THEN '0'::text
          ELSE "substring"(vw_perfil_localidade_repasse_recursos_por_ano.localidade, '[0-9]*'::text)
          END::integer > 99
GROUP BY vw_perfil_localidade_repasse_recursos_por_ano.localidade;