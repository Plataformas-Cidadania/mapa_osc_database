ALTER TABLE osc.tb_publico_beneficiado_projeto DROP CONSTRAINT pk_id_publico_beneficiado_projeto;
ALTER TABLE osc.tb_publico_beneficiado_projeto ADD COLUMN id_publico_beneficiado_projeto SERIAL PRIMARY KEY;

ALTER TABLE osc.tb_publico_beneficiado_projeto ALTER COLUMN id_publico_beneficiado DROP NOT null;
