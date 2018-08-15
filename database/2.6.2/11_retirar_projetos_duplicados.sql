delete from osc.tb_projeto where id_projeto in 
(select id_projeto from (
select id_projeto, tx_nome_projeto, ft_nome_projeto, tx_identificador_projeto_externo,
row_number() over (partition by (string_to_array(ft_nome_projeto,' '))[1], tx_identificador_projeto_externo,id_osc) row_number
from osc.tb_projeto
where tx_identificador_projeto_externo <> ''
) as tb
where tb.row_number > 1)
