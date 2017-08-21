ALTER TABLE osc.tb_recursos_osc ALTER nr_valor_recursos_osc DROP NOT NULL;

ALTER TABLE osc.tb_recursos_osc ADD bo_nao_possui BOOLEAN;
ALTER TABLE osc.tb_recursos_osc ADD ft_nao_possui TEXT;
