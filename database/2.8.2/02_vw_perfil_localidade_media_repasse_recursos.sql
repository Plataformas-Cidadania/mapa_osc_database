DROP materialized view IF EXISTS analysis.vw_perfil_localidade_media_repasse_recursos;

create materialized view analysis.vw_perfil_localidade_media_repasse_recursos as
SELECT a.localidade,
       count(*)                                               AS quantidade_repasses,
       sum(a.valor_recursos)                                  AS valor_repasses,
       (sum(a.valor_recursos) / COALESCE(1, count(*))::double precision) AS media
FROM analysis.vw_perfil_localidade_repasse_recursos a
    --WHERE a.localidade = 2925006::text
GROUP BY a.localidade;

alter materialized view analysis.vw_perfil_localidade_media_repasse_recursos owner to i3geo;

create index ix_localidade_vw_perfil_localidade_media_repasse_recursos
    on analysis.vw_perfil_localidade_media_repasse_recursos (localidade);