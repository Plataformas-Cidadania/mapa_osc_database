SELECT
       osc.id_osc AS id,
       tdg.tx_razao_social_osc AS razao_social,
        CASE
           WHEN tc.tx_telefone='NA' THEN '(NO)'
           WHEN tc.tx_telefone IS NULL THEN '(NO)'
            ELSE 'Yes'
           END AS telefone,
       CASE
           WHEN tc.tx_email='NA' THEN '(NO)'
           WHEN tc.tx_email IS NULL THEN '(NO)'
            ELSE 'Yes'
           END AS email,
        CASE
           WHEN tc.tx_facebook IS NULL THEN '(NO)'
           WHEN tc.tx_facebook='NA' THEN '(NO)'
            ELSE 'Yes'
           END AS facebook,
        CASE
           WHEN tc.tx_site IS NULL THEN '(NO)'
           WHEN tc.tx_site='NA' THEN '(NO)'
            ELSE 'Yes'
           END AS site,
        CASE
           WHEN tc.tx_linkedin IS NULL THEN '(NO)'
           WHEN tc.tx_linkedin='NA' THEN '(NO)'
            ELSE 'Yes'
           END AS linkedin,
        CASE
           WHEN tc.tx_google IS NULL THEN '(NO)'
           WHEN tc.tx_google='NA' THEN '(NO)'
            ELSE 'Yes'
           END AS google,
        CASE
           WHEN tc.tx_twitter IS NULL THEN '(NO)'
           WHEN tc.tx_twitter='NA' THEN '(NO)'
            ELSE 'Yes'
           END AS twitter
FROM osc.tb_osc osc
    LEFT JOIN osc.tb_dados_gerais tdg on osc.id_osc = tdg.id_osc
    LEFT JOIN osc.tb_contato tc ON osc.id_osc = tc.id_osc
WHERE bo_osc_ativa = TRUE
ORDER BY id;