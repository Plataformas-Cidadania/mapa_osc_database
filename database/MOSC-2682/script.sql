SELECT *
FROM osc.tb_certificado oc
WHERE 1 = 1
  AND oc.ft_certificado IS NULL;
--              OR oc.ft_inicio_certificado IS NULL
--              OR oc.ft_fim_certificado IS NULL
--              OR oc.ft_municipio IS NULL
--              OR oc.ft_uf IS NULL

UPDATE osc.tb_certificado
SET ft_certificado = 'Representante de OSC'
    WHERE ft_certificado IS NULL;