UPDATE graph.tb_cnes
SET ds_gestao = 'SEM GESTÃO' 
WHERE ds_gestao LIKE 'SEM GESTÃ%';

UPDATE graph.tb_cnes
SET st_registro_ativo = 'NÃO' 
WHERE st_registro_ativo LIKE 'NÃ%';