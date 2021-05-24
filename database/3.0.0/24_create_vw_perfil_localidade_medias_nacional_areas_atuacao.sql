drop view analysis.vw_perfil_localidade_medias_nacional_areas_atuacao;
create view analysis.vw_perfil_localidade_medias_nacional_areas_atuacao as
    SELECT a.area_atuacao,
       sum(a.quantidade_oscs)                                                                      AS quantidade_osc,
       sum(a.quantidade_oscs) / ((SELECT sum(vw_perfil_localidade_area_atuacao.quantidade_oscs) AS sum
                                  FROM analysis.vw_perfil_localidade_area_atuacao)) * 100::numeric AS valor
FROM analysis.vw_perfil_localidade_qtd_oscs_areas_atuacao a
GROUP BY a.area_atuacao;