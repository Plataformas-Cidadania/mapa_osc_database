SELECT
       tb_osc.id_osc AS id,
       eu.eduf_nm_uf AS estado,
       em.edmu_nm_municipio AS municipio,
       tb_osc.cd_identificador_osc AS cnpj,
       tx_email AS email
FROM osc.tb_osc
    LEFT JOIN osc.tb_contato ON tb_osc.id_osc = tb_contato.id_osc
    LEFT JOIN osc.tb_localizacao tl ON tb_osc.id_osc = tl.id_osc
    LEFT JOIN spat.ed_municipio em ON tl.cd_municipio = em.edmu_cd_municipio
    LEFT JOIN spat.ed_uf eu ON em.eduf_cd_uf = eu.eduf_cd_uf
WHERE bo_osc_ativa = TRUE
    AND eu.eduf_cd_uf = 26;