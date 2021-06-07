drop view analysis.vw_perfil_localidade_transferencias_federais;
create view analysis.vw_perfil_localidade_transferencias_federais as
    SELECT COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 1), 'Sem informação'::text)::integer AS localidade,
       COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação'::character varying)::text              AS nome_localidade,
       tb_orcamento_def.nr_orcamento_ano                                                          AS ano,
       sum(tb_orcamento_def.nr_vl_empenhado_def)                                                  AS empenhado,
       '{"SIGA Brasil 2010-2018, Valores deflacionados para dez/2018, IPCA IBGE 2018"}'::text[]   AS fontes
FROM graph.tb_orcamento_def
         LEFT JOIN osc.tb_osc ON tb_orcamento_def.nr_orcamento_cnpj = tb_osc.cd_identificador_osc
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
         LEFT JOIN spat.ed_regiao ON ed_regiao.edre_cd_regiao = substr(tb_localizacao.cd_municipio::text, 1, 1)::numeric
WHERE tb_osc.bo_osc_ativa
  AND tb_osc.id_osc <> 789809
  AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY (COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 1), 'Sem informação'::text)::integer),
         (COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação'::character varying)::text),
         tb_orcamento_def.nr_orcamento_ano
UNION
SELECT COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 2), 'Sem informação'::text)::integer AS localidade,
       COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação'::character varying)::text              AS nome_localidade,
       tb_orcamento_def.nr_orcamento_ano                                                          AS ano,
       sum(tb_orcamento_def.nr_vl_empenhado_def)                                                  AS empenhado,
       '{"SIGA Brasil 2010-2018, Valores deflacionados para dez/2018, IPCA IBGE 2018"}'::text[]   AS fontes
FROM graph.tb_orcamento_def
         LEFT JOIN osc.tb_osc ON tb_orcamento_def.nr_orcamento_cnpj = tb_osc.cd_identificador_osc
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
         LEFT JOIN spat.ed_regiao ON ed_regiao.edre_cd_regiao = substr(tb_localizacao.cd_municipio::text, 1, 1)::numeric
WHERE tb_osc.bo_osc_ativa
  AND tb_osc.id_osc <> 789809
  AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY (COALESCE(substr(tb_localizacao.cd_municipio::text, 1, 2), 'Sem informação'::text)::integer),
         (COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação'::character varying)::text),
         tb_orcamento_def.nr_orcamento_ano
UNION
SELECT COALESCE(tb_localizacao.cd_municipio::text, 'Sem informação'::text)::integer             AS localidade,
       COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação'::character varying)::text            AS nome_localidade,
       tb_orcamento_def.nr_orcamento_ano                                                        AS ano,
       sum(tb_orcamento_def.nr_vl_empenhado_def)                                                AS empenhado,
       '{"SIGA Brasil 2010-2018, Valores deflacionados para dez/2018, IPCA IBGE 2018"}'::text[] AS fontes
FROM graph.tb_orcamento_def
         LEFT JOIN osc.tb_osc ON tb_orcamento_def.nr_orcamento_cnpj = tb_osc.cd_identificador_osc
         LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
         LEFT JOIN spat.ed_regiao ON ed_regiao.edre_cd_regiao = substr(tb_localizacao.cd_municipio::text, 1, 1)::numeric
WHERE tb_osc.bo_osc_ativa
  AND tb_osc.id_osc <> 789809
  AND tb_localizacao.cd_municipio IS NOT NULL
GROUP BY (COALESCE(tb_localizacao.cd_municipio::text, 'Sem informação'::text)::integer),
         (COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação'::character varying)::text),
         tb_orcamento_def.nr_orcamento_ano;