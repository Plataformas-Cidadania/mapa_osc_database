SELECT
    os.id_osc,
    --dg.tx_razao_social_osc,
    --dg.tx_nome_fantasia_osc,
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
        6078447000160,
        6102038000151,
        6148939000184,
        3851523000130,
        7077557000170,
        11375647000114,
        6105884000125,
        6264861000163,
        3667683000123,
        7297923000104,
        11489174000186,
        7467183000107,
        6761798000170,
        9274637000140,
        5379495000125
       )
GROUP BY os.id_osc,
    dg.tx_razao_social_osc,
    dg.tx_nome_fantasia_osc,
    os.cd_identificador_osc,
    tb_cert.dt_inicio_certificado,
    tb_cert.dt_fim_certificado
ORDER BY cd_identificador_osc;