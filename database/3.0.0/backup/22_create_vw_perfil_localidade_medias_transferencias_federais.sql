drop view analysis.vw_perfil_localidade_medias_transferencias_federais;
create view analysis.vw_perfil_localidade_medias_transferencias_federais as
    SELECT 'Região'::text                                AS tipo_localidade,
       sum(a.empenhado) / count(*)::double precision AS media,
       count(*)                                      AS quantidade_localidades
FROM (SELECT sum(vw_perfil_localidade_orcamento.empenhado) AS empenhado,
             vw_perfil_localidade_orcamento.localidade
      FROM analysis.vw_perfil_localidade_orcamento
      WHERE vw_perfil_localidade_orcamento.localidade >= 0
        AND vw_perfil_localidade_orcamento.localidade <= 9
      GROUP BY vw_perfil_localidade_orcamento.localidade) a
UNION
SELECT 'Estado'::text                                AS tipo_localidade,
       sum(a.empenhado) / count(*)::double precision AS media,
       count(*)                                      AS quantidade_localidades
FROM (SELECT sum(vw_perfil_localidade_orcamento.empenhado) AS empenhado,
             vw_perfil_localidade_orcamento.localidade
      FROM analysis.vw_perfil_localidade_orcamento
      WHERE vw_perfil_localidade_orcamento.localidade >= 10
        AND vw_perfil_localidade_orcamento.localidade <= 99
      GROUP BY vw_perfil_localidade_orcamento.localidade) a
UNION
SELECT 'Município'::text                             AS tipo_localidade,
       sum(a.empenhado) / count(*)::double precision AS media,
       count(*)                                      AS quantidade_localidades
FROM (SELECT sum(vw_perfil_localidade_orcamento.empenhado) AS empenhado,
             vw_perfil_localidade_orcamento.localidade
      FROM analysis.vw_perfil_localidade_orcamento
      WHERE vw_perfil_localidade_orcamento.localidade > 99
      GROUP BY vw_perfil_localidade_orcamento.localidade) a;