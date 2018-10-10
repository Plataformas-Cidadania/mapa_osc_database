select c.tx_nome_conferencia, b.ft_conferencia, b.dt_ano_realizacao, d.tx_nome_forma_participacao_conferencia,
f.tx_nome_conselho, f.tx_nome_orgao_vinculado, e.dt_data_inicio_conselho, e.dt_data_fim_conselho,
g.tx_nome_periodicidade_reuniao_conselho
from osc.tb_osc a 
join osc.tb_participacao_social_conferencia b on a.id_osc = b.id_osc
left join syst.dc_conferencia c on b.cd_conferencia = c.cd_conferencia
left join syst.dc_forma_participacao_conferencia d on b.cd_forma_participacao_conferencia = d.cd_forma_participacao_conferencia
left join osc.tb_participacao_social_conselho e on a.id_osc = e.id_osc
left join syst.dc_conselho f on e.cd_conselho = f.cd_conselho
left join syst.dc_periodicidade_reuniao_conselho g on e.cd_periodicidade_reuniao_conselho = g.cd_periodicidade_reuniao_conselho
where a.bo_osc_ativa
and a.id_osc not in (789809,987654)