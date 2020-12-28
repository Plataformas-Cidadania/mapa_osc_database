SELECT os.id_osc AS ID,
       loc.cd_municipio AS MUNICIPIO,
       uf.eduf_nm_uf AS UF,
       nj.cd_natureza_juridica AS CODIGO_NATUREZA_JURIDICA,
       nj.tx_nome_natureza_juridica AS NATUREZA_JURIDICA,
       dg.tx_razao_social_osc AS RAZAO_SOCIAL,
       COALESCE(dg.tx_nome_fantasia_osc, 'Não informado') AS NOME_FANTASIA,
       SUM(COALESCE(rt.nr_trabalhadores_vinculo, 0) + COALESCE(rt.nr_trabalhadores_voluntarios, 0) + COALESCE(rt.nr_trabalhadores_deficiencia, 0)) AS TRABALHADORES_ATIVOS,
       rt.nr_trabalhadores_vinculo AS TRABALHADORES_COM_VINCULO,
       --loc.tx_endereco,   --NÃO AUTO
       --loc.nr_localizacao,    --NÃO AUTO
       --loc.tx_bairro, --NÃO AUTO
       --loc.nr_cep --NÃO AUTO
       dg.dt_fundacao_osc AS DATA_FUNDACAO,
       --dt_encerramentos NÃO EXISTE
       --CNPJ (ID OSC) --NÃO AUTO
       atec.cd_classe_atividade_economica AS COD_ATIV_ECONOMICA,
       atec.tx_nome_classe_atividade_economica AS ATIVIDADE_ECONOMICA,
       arat.tx_nome_area_atuacao AS AREA_ATUACAO
FROM osc.tb_osc os,
     osc.tb_dados_gerais dg,
     syst.dc_natureza_juridica nj,
     osc.tb_localizacao loc,
     spat.ed_municipio mun,
     spat.ed_uf uf,
     osc.tb_relacoes_trabalho rt,
     osc.tb_area_atuacao tbarea,
     syst.dc_area_atuacao arat,
     syst.dc_classe_atividade_economica atec
WHERE os.id_osc = dg.id_osc
  AND os.id_osc = loc.id_osc
  AND dg.cd_natureza_juridica_osc = nj.cd_natureza_juridica
  AND loc.cd_municipio = mun.edmu_cd_municipio
  AND mun.eduf_cd_uf = uf.eduf_cd_uf
  AND os.id_osc = rt.id_osc
  AND os.id_osc = tbarea.id_osc
  AND tbarea.cd_area_atuacao = arat.cd_area_atuacao
  AND dg.cd_classe_atividade_economica_osc = atec.cd_classe_atividade_economica
  --AND arat.cd_area_atuacao = 9
GROUP BY os.id_osc, loc.cd_municipio,
         uf.eduf_nm_uf,
         nj.cd_natureza_juridica,
         nj.tx_nome_natureza_juridica,
         dg.tx_nome_fantasia_osc,
         dg.tx_razao_social_osc,
         rt.nr_trabalhadores_vinculo,
         --loc.tx_endereco,   --NÃO AUTO
         --loc.nr_localizacao,   --NÃO AUTO
         --loc.tx_bairro,   --NÃO AUTO
         --loc.nr_cep   --NÃO AUTO
         dg.dt_fundacao_osc,
         atec.cd_classe_atividade_economica,
         atec.tx_nome_classe_atividade_economica,
         arat.tx_nome_area_atuacao;