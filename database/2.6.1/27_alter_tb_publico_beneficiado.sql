ALTER TABLE osc.tb_publico_beneficiado ADD COLUMN id_publico_beneficiado_projeto INTEGER;

ALTER TABLE osc.tb_publico_beneficiado 
   ADD CONSTRAINT fk_id_publico_beneficiado_projeto
   FOREIGN KEY (id_publico_beneficiado_projeto) 
   REFERENCES osc.tb_publico_beneficiado_projeto (id_publico_beneficiado_projeto);