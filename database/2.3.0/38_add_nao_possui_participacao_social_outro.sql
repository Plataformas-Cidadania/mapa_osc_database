ALTER TABLE osc.tb_participacao_social_outra ALTER tx_nome_participacao_social_outra DROP NOT NULL;

ALTER TABLE osc.tb_participacao_social_outra ADD bo_nao_possui BOOLEAN;
