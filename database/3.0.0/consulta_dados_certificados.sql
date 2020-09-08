SELECT
    os.id_osc,
    dg.tx_razao_social_osc,
    dg.tx_nome_fantasia_osc,
    os.cd_identificador_osc,

    tb_cert.dt_inicio_certificado,
    tb_cert.dt_fim_certificado
FROM osc.tb_osc os,
    osc.tb_dados_gerais dg,
    osc.tb_certificado tb_cert
WHERE os.id_osc = dg.id_osc
  AND os.id_osc = tb_cert.id_osc
  AND os.cd_identificador_osc IN
      (
    05256669000162,
    15725224000138,
    07769909000158
       )
GROUP BY os.id_osc,
    dg.tx_razao_social_osc,
    dg.tx_nome_fantasia_osc,
    os.cd_identificador_osc,
    tb_cert.dt_inicio_certificado,
    tb_cert.dt_fim_certificado
ORDER BY id_osc;