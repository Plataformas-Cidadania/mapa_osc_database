ALTER TABLE osc.tb_fonte_recursos_projeto ADD ft_tipo_parceria TEXT;
ALTER TABLE osc.tb_fonte_recursos_projeto ADD tx_orgao_concedente TEXT;
ALTER TABLE osc.tb_fonte_recursos_projeto ADD ft_orgao_concedente TEXT;

ALTER TABLE osc.tb_fonte_recursos_projeto 
ALTER COLUMN id_projeto SET NOT NULL;
