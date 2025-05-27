alter table osc.tb_relacoes_trabalho
                 add nr_trabalhadores_vinculo_osc integer
comment on column osc.tb_relacoes_trabalho.nr_trabalhadores_vinculo_osc is 'Número de trabalhadores com vínculo editado pela OSC'

alter table osc.tb_relacoes_trabalho
                 add nr_trabalhadores_deficiencia_osc integer
comment on column osc.tb_relacoes_trabalho.nr_trabalhadores_deficiencia_osc is 'Número de trabalhadores portadores de deficiência editado pela OSC'