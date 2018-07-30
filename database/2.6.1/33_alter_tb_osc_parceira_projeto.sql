ALTER TABLE osc.tb_osc_parceira_projeto ALTER bo_oficial DROP NOT NULL;
ALTER TABLE osc.tb_osc_parceira_projeto DROP CONSTRAINT pk_tb_osc_parceira_projeto;
ALTER TABLE osc.tb_osc_parceira_projeto ADD COLUMN id_osc_parceira_projeto SERIAL PRIMARY KEY;