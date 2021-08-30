SELECT
    os.id_osc,
    --dg.tx_razao_social_osc,
    --dg.tx_nome_fantasia_osc,
    os.cd_identificador_osc,
    tb_cert.cd_certificado,
    tb_cert.dt_inicio_certificado,
    tb_cert.dt_fim_certificado
FROM osc.tb_osc os,
    osc.tb_dados_gerais dg,
    osc.tb_certificado tb_cert
WHERE os.id_osc = dg.id_osc
  AND os.id_osc = tb_cert.id_osc
  AND os.cd_identificador_osc IN
      (
            185146000159,
            2362784000123,
            4903674000157,
            4917891000104,
            5372804000135,
            5882078000109,
            6072239000153,
            8777009000115,
            10263156000119,
            10398480000144,
            11235616000168,
            11481643000110,
            13824704000120
       )
    AND tb_cert.cd_certificado = 4
GROUP BY os.id_osc,
    dg.tx_razao_social_osc,
    dg.tx_nome_fantasia_osc,
    os.cd_identificador_osc,
    tb_cert.cd_certificado,
    tb_cert.dt_inicio_certificado,
    tb_cert.dt_fim_certificado
ORDER BY cd_identificador_osc;