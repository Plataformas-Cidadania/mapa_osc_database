SELECT tb_osc.id_osc, tb_osc.cd_identificador_osc, tx_email FROM osc.tb_osc
LEFT JOIN osc.tb_contato ON tb_osc.id_osc = tb_contato.id_osc
WHERE bo_osc_ativa = TRUE;

SELECT * FROM portal.tb_usuario;