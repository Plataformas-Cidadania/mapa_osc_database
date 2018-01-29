UPDATE syst.dc_status_projeto 
SET tx_nome_status_projeto = 'Proposta' 
WHERE tx_nome_status_projeto = 'Planejado';

UPDATE syst.dc_status_projeto 
SET tx_nome_status_projeto = 'Projeto em andamento' 
WHERE tx_nome_status_projeto = 'Em Execução';

INSERT INTO syst.dc_status_projeto (cd_status_projeto, tx_nome_status_projeto)
VALUES (5, 'Arquivado, cancelado ou indeferido');

UPDATE osc.tb_projeto 
SET cd_status_projeto = (SELECT cd_status_projeto FROM syst.dc_status_projeto WHERE tx_nome_status_projeto = 'Projeto em andamento') 
WHERE cd_status_projeto = (SELECT cd_status_projeto FROM syst.dc_status_projeto WHERE tx_nome_status_projeto = 'Proposta');
