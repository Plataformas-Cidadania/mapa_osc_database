SELECT * FROM osc.tb_osc o WHERE o.cd_identificador_osc = '036685970000115';
SELECT tdg.tx_razao_social_osc FROM osc.tb_osc o
    LEFT JOIN osc.tb_dados_gerais tdg on o.id_osc = tdg.id_osc
WHERE tdg.tx_razao_social_osc LIKE 'Associação%Amigos%';