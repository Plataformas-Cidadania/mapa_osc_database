ALTER TABLE portal.tb_usuario ADD tx_telefone_1 TEXT DEFAULT null;
ALTER TABLE portal.tb_usuario ADD tx_telefone_2 TEXT DEFAULT null;
ALTER TABLE portal.tb_usuario ADD tx_orgao_trabalha TEXT DEFAULT null;
ALTER TABLE portal.tb_usuario ADD tx_dado_institucional TEXT DEFAULT null;
ALTER TABLE portal.tb_usuario ADD tx_email_confirmacao TEXT DEFAULT null;
ALTER TABLE portal.tb_usuario ADD bo_lista_atualizacao_anual BOOLEAN DEFAULT false;
ALTER TABLE portal.tb_usuario ADD bo_lista_atualizacao_trimestral BOOLEAN DEFAULT false;
