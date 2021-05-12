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
          3173939000146,
            4656212000182,
            5422040000145,
            6867330000165,
            7882768000185,
            7887773000180,
            8699099000173,
            8918162000115,
            10172307000123,
            12487918000196,
            17525179000101,
            21098928000120,
            26445973000128
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