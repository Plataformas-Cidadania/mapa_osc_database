DROP materialized view IF EXISTS analysis.vw_perfil_localidade_area_atuacao_nacional;
DROP materialized view IF EXISTS analysis.vw_perfil_localidade_media_nacional;
DROP materialized view IF EXISTS analysis.vw_perfil_localidade_maior_area_atuacao;

DROP materialized view IF EXISTS analysis.vw_perfil_localidade_area_atuacao;
create materialized view analysis.vw_perfil_localidade_area_atuacao as
    SELECT substr((tb_localizacao.cd_municipio)::text, 1, 1)                      AS localidade,
           COALESCE(dc_area_atuacao.tx_nome_area_atuacao, 'Sem informação'::text) AS area_atuacao,
           count(DISTINCT tb_osc.id_osc)                                          AS quantidade_oscs,
           (replace((('{'::text ||
                      btrim(translate(((SELECT array_agg(translate((a.*)::text, '()'::text, ''::text)) AS array_agg
                                        FROM (SELECT DISTINCT unnest(array_cat(
                                                array_cat(array_agg(DISTINCT COALESCE(regexp_replace(
                                                                                              regexp_replace(tb_osc.ft_osc_ativa, '([012]\d|3[01])/\d{4}$', ''),
                                                                                              '(\d{4}$)', ''),
                                                                                      ''::text)),
                                                          array_agg(DISTINCT COALESCE(regexp_replace(regexp_replace(
                                                                                                             tb_localizacao.ft_municipio,
                                                                                                             '([012]\d|3[01])/\d{4}$',
                                                                                                             ''),
                                                                                                     '(\d{4}$)', ''),
                                                                                      ''::text))),
                                                array_agg(DISTINCT
                                                          COALESCE(regexp_replace(regexp_replace(
                                                                                          tb_area_atuacao.ft_area_atuacao,
                                                                                          '([012]\d|3[01])/\d{4}$', ''),
                                                                                  '(\d{4}$)', ''),
                                                                   ''::text)))) AS unnest) a))::text,
                                      '"\{}'::text, ''::text), ','::text)) || '}'::text), ',,'::text,
                    ','::text))::text[]                                           AS fontes
    FROM (((osc.tb_osc
        LEFT JOIN osc.tb_area_atuacao ON ((tb_osc.id_osc = tb_area_atuacao.id_osc)))
        LEFT JOIN syst.dc_area_atuacao ON ((tb_area_atuacao.cd_area_atuacao = dc_area_atuacao.cd_area_atuacao)))
             LEFT JOIN osc.tb_localizacao ON ((tb_osc.id_osc = tb_localizacao.id_osc)))
    WHERE (tb_osc.bo_osc_ativa AND (tb_osc.id_osc <> 789809) AND (tb_localizacao.cd_municipio IS NOT NULL))
    GROUP BY (substr((tb_localizacao.cd_municipio)::text, 1, 1)),
             COALESCE(dc_area_atuacao.tx_nome_area_atuacao, 'Sem informação'::text)
    UNION
    SELECT substr((tb_localizacao.cd_municipio)::text, 1, 2)                      AS localidade,
           COALESCE(dc_area_atuacao.tx_nome_area_atuacao, 'Sem informação'::text) AS area_atuacao,
           count(DISTINCT tb_osc.id_osc)                                          AS quantidade_oscs,

           (replace((('{'::text ||
                      btrim(translate(((SELECT array_agg(translate((a.*)::text, '()'::text, ''::text)) AS array_agg
                                        FROM (SELECT DISTINCT unnest(array_cat(
                                                array_cat(array_agg(DISTINCT COALESCE(regexp_replace(
                                                                                              regexp_replace(tb_osc.ft_osc_ativa, '([012]\d|3[01])/\d{4}$', ''),
                                                                                              '(\d{4}$)', ''),
                                                                                      ''::text)),
                                                          array_agg(DISTINCT COALESCE(regexp_replace(regexp_replace(
                                                                                                             tb_localizacao.ft_municipio,
                                                                                                             '([012]\d|3[01])/\d{4}$',
                                                                                                             ''),
                                                                                                     '(\d{4}$)', ''),
                                                                                      ''::text))),
                                                array_agg(DISTINCT
                                                          COALESCE(regexp_replace(regexp_replace(
                                                                                          tb_area_atuacao.ft_area_atuacao,
                                                                                          '([012]\d|3[01])/\d{4}$', ''),
                                                                                  '(\d{4}$)', ''),
                                                                   ''::text)))) AS unnest) a))::text,
                                      '"\{}'::text, ''::text), ','::text)) || '}'::text), ',,'::text,
                    ','::text))::text[]                                           AS fontes
    FROM (((osc.tb_osc
        LEFT JOIN osc.tb_area_atuacao ON ((tb_osc.id_osc = tb_area_atuacao.id_osc)))
        LEFT JOIN syst.dc_area_atuacao ON ((tb_area_atuacao.cd_area_atuacao = dc_area_atuacao.cd_area_atuacao)))
             LEFT JOIN osc.tb_localizacao ON ((tb_osc.id_osc = tb_localizacao.id_osc)))
    WHERE (tb_osc.bo_osc_ativa AND (tb_osc.id_osc <> 789809) AND (tb_localizacao.cd_municipio IS NOT NULL))
    GROUP BY (substr((tb_localizacao.cd_municipio)::text, 1, 2)),
             COALESCE(dc_area_atuacao.tx_nome_area_atuacao, 'Sem informação'::text)
    UNION
    SELECT (tb_localizacao.cd_municipio)::text                                    AS localidade,
           COALESCE(dc_area_atuacao.tx_nome_area_atuacao, 'Sem informação'::text) AS area_atuacao,
           count(DISTINCT tb_osc.id_osc)                                          AS quantidade_oscs,

           (replace((('{'::text ||
                      btrim(translate(((SELECT array_agg(translate((a.*)::text, '()'::text, ''::text)) AS array_agg
                                        FROM (SELECT DISTINCT unnest(array_cat(
                                                array_cat(array_agg(DISTINCT COALESCE(regexp_replace(
                                                                                              regexp_replace(tb_osc.ft_osc_ativa, '([012]\d|3[01])/\d{4}$', ''),
                                                                                              '(\d{4}$)', ''),
                                                                                      ''::text)),
                                                          array_agg(DISTINCT COALESCE(regexp_replace(regexp_replace(
                                                                                                             tb_localizacao.ft_municipio,
                                                                                                             '([012]\d|3[01])/\d{4}$',
                                                                                                             ''),
                                                                                                     '(\d{4}$)', ''),
                                                                                      ''::text))),
                                                array_agg(DISTINCT
                                                          COALESCE(regexp_replace(regexp_replace(
                                                                                          tb_area_atuacao.ft_area_atuacao,
                                                                                          '([012]\d|3[01])/\d{4}$', ''),
                                                                                  '(\d{4}$)', ''),
                                                                   ''::text)))) AS unnest) a))::text,
                                      '"\{}'::text, ''::text), ','::text)) || '}'::text), ',,'::text,
                    ','::text))::text[]                                           AS fontes
    FROM (((osc.tb_osc
        LEFT JOIN osc.tb_area_atuacao ON ((tb_osc.id_osc = tb_area_atuacao.id_osc)))
        LEFT JOIN syst.dc_area_atuacao ON ((tb_area_atuacao.cd_area_atuacao = dc_area_atuacao.cd_area_atuacao)))
             LEFT JOIN osc.tb_localizacao ON ((tb_osc.id_osc = tb_localizacao.id_osc)))
    WHERE (tb_osc.bo_osc_ativa AND (tb_osc.id_osc <> 789809) AND (tb_localizacao.cd_municipio IS NOT NULL))
    GROUP BY (tb_localizacao.cd_municipio)::text,
             COALESCE(dc_area_atuacao.tx_nome_area_atuacao, 'Sem informação'::text);

alter materialized view analysis.vw_perfil_localidade_area_atuacao owner to i3geo;

create index ix_area_atuacao_vw_perfil_localidade_area_atuacao
    on analysis.vw_perfil_localidade_area_atuacao (area_atuacao);

create index ix_localidade_vw_perfil_localidade_area_atuacao
    on analysis.vw_perfil_localidade_area_atuacao (localidade);


--analysis.vw_perfil_localidade_area_atuacao_nacional
--analysis.vw_perfil_localidade_media_nacional
--analysis.vw_perfil_localidade_maior_area_atuacao