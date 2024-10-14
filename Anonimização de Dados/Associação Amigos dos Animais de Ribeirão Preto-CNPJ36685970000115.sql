SELECT * FROM osc.tb_osc o WHERE o.cd_identificador_osc = '036685970000115';
SELECT tdg.* FROM osc.tb_dados_gerais tdg WHERE id_osc = 1323505;
SELECT tdg.* FROM osc.tb_localizacao tdg WHERE id_osc = 1323505;
SELECT tdg.* FROM osc.tb_contato tdg WHERE id_osc = 1323505;

-- id 1323505
UPDATE osc.tb_localizacao
SET tx_endereco           = 'xxxxxxxxxxxx',
    nr_localizacao        = 'xxxxxxxxxxxx',
    tx_bairro             = 'xxxxxxxxxxxx',
    cd_municipio          = 0,
    nr_cep                = 0,
    tx_endereco_corrigido = 'xxxxxxxxxxxx',
    tx_bairro_encontrado  = 'xxxxxxxxxxxx'
WHERE id_osc = 1323505;

UPDATE osc.tb_contato
SET tx_telefone = 'xxxxxxxxxxxx'
WHERE id_osc = 1323505;