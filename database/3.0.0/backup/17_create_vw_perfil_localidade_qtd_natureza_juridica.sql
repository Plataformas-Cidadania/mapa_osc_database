drop view analysis.vw_perfil_localidade_qtd_natureza_juridica;
create view analysis.vw_perfil_localidade_qtd_natureza_juridica as
SELECT substr(tb_localizacao.cd_municipio::text, 1, 1)                                  AS localidade,
       COALESCE(dc_natureza_juridica.tx_nome_natureza_juridica, 'Sem informação'::text) AS natureza_juridica,
       count(DISTINCT tb_osc.id_osc)                                                    AS quantidade_oscs,
       replace(('{'::text || btrim(translate(((SELECT array_agg(translate(a.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(array_cat(
                                                                                              array_agg(DISTINCT COALESCE(tb_osc.ft_osc_ativa, ''::text)),
                                                                                              array_agg(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''::text))),
                                                                                      array_agg(DISTINCT
                                                                                                COALESCE(tb_dados_gerais.ft_natureza_juridica_osc, ''::text)))) AS unnest) a))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
               ','::text)::text[]                                                       AS fontes
FROM osc.tb_osc
         LEFT JOIN osc.tb_dados_gerais ON tb_osc.id_osc = tb_dados_gerais.id_osc
         LEFT JOIN syst.dc_natureza_juridica
                   ON tb_dados_gerais.cd_natureza_juridica_osc = dc_natureza_juridica.cd_natureza_juridica
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
  AND tb_osc.id_osc <> 789809
  AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY (substr(tb_localizacao.cd_municipio::text, 1, 1)),
         (COALESCE(dc_natureza_juridica.tx_nome_natureza_juridica, 'Sem informação'::text))
UNION
SELECT substr(tb_localizacao.cd_municipio::text, 1, 2)                                  AS localidade,
       COALESCE(dc_natureza_juridica.tx_nome_natureza_juridica, 'Sem informação'::text) AS natureza_juridica,
       count(DISTINCT tb_osc.id_osc)                                                    AS quantidade_oscs,
       replace(('{'::text || btrim(translate(((SELECT array_agg(translate(a.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(array_cat(
                                                                                              array_agg(DISTINCT COALESCE(tb_osc.ft_osc_ativa, ''::text)),
                                                                                              array_agg(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''::text))),
                                                                                      array_agg(DISTINCT
                                                                                                COALESCE(tb_dados_gerais.ft_natureza_juridica_osc, ''::text)))) AS unnest) a))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
               ','::text)::text[]                                                       AS fontes
FROM osc.tb_osc
         LEFT JOIN osc.tb_dados_gerais ON tb_osc.id_osc = tb_dados_gerais.id_osc
         LEFT JOIN syst.dc_natureza_juridica
                   ON tb_dados_gerais.cd_natureza_juridica_osc = dc_natureza_juridica.cd_natureza_juridica
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
  AND tb_osc.id_osc <> 789809
  AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY (substr(tb_localizacao.cd_municipio::text, 1, 2)),
         (COALESCE(dc_natureza_juridica.tx_nome_natureza_juridica, 'Sem informação'::text))
UNION
SELECT tb_localizacao.cd_municipio::text                                                AS localidade,
       COALESCE(dc_natureza_juridica.tx_nome_natureza_juridica, 'Sem informação'::text) AS natureza_juridica,
       count(DISTINCT tb_osc.id_osc)                                                    AS quantidade_oscs,
       replace(('{'::text || btrim(translate(((SELECT array_agg(translate(a.*::text, '()'::text, ''::text)) AS array_agg
                                               FROM (SELECT DISTINCT unnest(array_cat(array_cat(
                                                                                              array_agg(DISTINCT COALESCE(tb_osc.ft_osc_ativa, ''::text)),
                                                                                              array_agg(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''::text))),
                                                                                      array_agg(DISTINCT
                                                                                                COALESCE(tb_dados_gerais.ft_natureza_juridica_osc, ''::text)))) AS unnest) a))::text,
                                             '"\{}'::text, ''::text), ','::text)) || '}'::text, ',,'::text,
               ','::text)::text[]                                                       AS fontes
FROM osc.tb_osc
         LEFT JOIN osc.tb_dados_gerais ON tb_osc.id_osc = tb_dados_gerais.id_osc
         LEFT JOIN syst.dc_natureza_juridica
                   ON tb_dados_gerais.cd_natureza_juridica_osc = dc_natureza_juridica.cd_natureza_juridica
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
WHERE tb_osc.bo_osc_ativa
  AND tb_osc.id_osc <> 789809
  AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY (tb_localizacao.cd_municipio::text),
         (COALESCE(dc_natureza_juridica.tx_nome_natureza_juridica, 'Sem informação'::text));