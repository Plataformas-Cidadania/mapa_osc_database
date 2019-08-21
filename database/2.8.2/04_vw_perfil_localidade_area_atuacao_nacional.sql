create materialized view analysis.vw_perfil_localidade_area_atuacao_nacional as
SELECT a.area_atuacao,
       sum(a.quantidade_oscs)                                                                          AS quantidade_osc,
       ((sum(a.quantidade_oscs) / (SELECT sum(vw_perfil_localidade_area_atuacao.quantidade_oscs) AS sum
                                   FROM analysis.vw_perfil_localidade_area_atuacao)) * (100)::numeric) AS valor
FROM analysis.vw_perfil_localidade_area_atuacao a
GROUP BY a.area_atuacao;

alter materialized view analysis.vw_perfil_localidade_area_atuacao_nacional owner to b116908948;

create index ix_area_atuacao_vw_perfil_localidade_area_atuacao_nacional
    on analysis.vw_perfil_localidade_area_atuacao_nacional (area_atuacao);