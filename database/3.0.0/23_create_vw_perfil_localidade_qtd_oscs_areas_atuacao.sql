drop view analysis.vw_perfil_localidade_qtd_oscs_areas_atuacao;
create view analysis.vw_perfil_localidade_qtd_oscs_areas_atuacao as
    SELECT substr(tb_localizacao.cd_municipio::text, 1, 1)                        AS localidade,
       COALESCE(dc_area_atuacao.tx_nome_area_atuacao, 'Sem informação'::text) AS area_atuacao,
       count(DISTINCT tb_osc.id_osc)                                          AS quantidade_oscs,
       replace(('{'::text || btrim(translate(((SELECT array_agg(translate(a.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(array_cat(
                                                                                              array_agg(DISTINCT COALESCE(tb_osc.ft_osc_ativa, ''::text)),
                                                                                              array_agg(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''::text))),
                                                                                      array_agg(DISTINCT
                                                                                                COALESCE(tb_area_atuacao.ft_area_atuacao, ''::text)))) AS unnest) a))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
               ','::text)::text[]                                             AS fontes
FROM osc.tb_osc
         LEFT JOIN osc.tb_area_atuacao ON tb_osc.id_osc = tb_area_atuacao.id_osc
         LEFT JOIN syst.dc_area_atuacao ON tb_area_atuacao.cd_area_atuacao = dc_area_atuacao.cd_area_atuacao
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
  AND tb_osc.id_osc <> 789809
  AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY (substr(tb_localizacao.cd_municipio::text, 1, 1)),
         (COALESCE(dc_area_atuacao.tx_nome_area_atuacao, 'Sem informação'::text))
UNION
SELECT substr(tb_localizacao.cd_municipio::text, 1, 2)                        AS localidade,
       COALESCE(dc_area_atuacao.tx_nome_area_atuacao, 'Sem informação'::text) AS area_atuacao,
       count(DISTINCT tb_osc.id_osc)                                          AS quantidade_oscs,
       replace(('{'::text || btrim(translate(((SELECT array_agg(translate(a.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(array_cat(
                                                                                              array_agg(DISTINCT COALESCE(tb_osc.ft_osc_ativa, ''::text)),
                                                                                              array_agg(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''::text))),
                                                                                      array_agg(DISTINCT
                                                                                                COALESCE(tb_area_atuacao.ft_area_atuacao, ''::text)))) AS unnest) a))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
               ','::text)::text[]                                             AS fontes
FROM osc.tb_osc
         LEFT JOIN osc.tb_area_atuacao ON tb_osc.id_osc = tb_area_atuacao.id_osc
         LEFT JOIN syst.dc_area_atuacao ON tb_area_atuacao.cd_area_atuacao = dc_area_atuacao.cd_area_atuacao
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
  AND tb_osc.id_osc <> 789809
  AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY (substr(tb_localizacao.cd_municipio::text, 1, 2)),
         (COALESCE(dc_area_atuacao.tx_nome_area_atuacao, 'Sem informação'::text))
UNION
SELECT tb_localizacao.cd_municipio::text                                      AS localidade,
       COALESCE(dc_area_atuacao.tx_nome_area_atuacao, 'Sem informação'::text) AS area_atuacao,
       count(DISTINCT tb_osc.id_osc)                                          AS quantidade_oscs,
       replace(('{'::text || btrim(translate(((SELECT array_agg(translate(a.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(array_cat(
                                                                                              array_agg(DISTINCT COALESCE(tb_osc.ft_osc_ativa, ''::text)),
                                                                                              array_agg(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''::text))),
                                                                                      array_agg(DISTINCT
                                                                                                COALESCE(tb_area_atuacao.ft_area_atuacao, ''::text)))) AS unnest) a))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
               ','::text)::text[]                                             AS fontes
FROM osc.tb_osc
         LEFT JOIN osc.tb_area_atuacao ON tb_osc.id_osc = tb_area_atuacao.id_osc
         LEFT JOIN syst.dc_area_atuacao ON tb_area_atuacao.cd_area_atuacao = dc_area_atuacao.cd_area_atuacao
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
  AND tb_osc.id_osc <> 789809
  AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY (tb_localizacao.cd_municipio::text), (COALESCE(dc_area_atuacao.tx_nome_area_atuacao, 'Sem informação'::text));