alter table osc.tb_relacoes_trabalho DISABLE TRIGGER ALL;

update osc.tb_relacoes_trabalho set ft_trabalhadores_vinculo = 'RAIS/MTE 2015' where ft_trabalhadores_vinculo = 'RAIS/MTE';

alter table osc.tb_relacoes_trabalho ENABLE TRIGGER ALL;