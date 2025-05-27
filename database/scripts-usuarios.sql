SELECT o.id_osc, o.cd_identificador_osc, tu.id_usuario, tu.tx_nome_usuario, tu.tx_email_usuario FROM osc.tb_osc o
    LEFT JOIN osc.tb_dados_gerais dg on o.id_osc = dg.id_osc
LEFT JOIN portal.tb_representacao tr on o.id_osc = tr.id_osc
LEFT JOIN portal.tb_usuario tu on tr.id_usuario = tu.id_usuario

-- Exclui primeiro as representações do usuário associadas à OSC
DELETE FROM portal.tb_representacao
WHERE id_osc IN (
    SELECT id_osc
    FROM osc.tb_osc
    WHERE cd_identificador_osc = 'VALOR_DO_CD_IDENTIFICADOR_OSC'
);

-- Em seguida, exclui os usuários que estavam associados através da representação
DELETE FROM portal.tb_usuario
WHERE id_usuario IN (
    SELECT tu.id_usuario
    FROM portal.tb_usuario tu
    JOIN portal.tb_representacao tr ON tu.id_usuario = tr.id_usuario
    JOIN osc.tb_osc o ON tr.id_osc = o.id_osc
    WHERE o.cd_identificador_osc = 'VALOR_DO_CD_IDENTIFICADOR_OSC'
);