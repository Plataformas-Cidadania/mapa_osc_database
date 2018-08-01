ALTER TABLE osc.tb_osc_parceira_projeto ALTER bo_oficial DROP NOT NULL;
ALTER TABLE osc.tb_osc_parceira_projeto DROP CONSTRAINT pk_tb_osc_parceira_projeto;
ALTER TABLE osc.tb_osc_parceira_projeto ADD COLUMN id_osc_parceira_projeto SERIAL PRIMARY KEY;

DROP INDEX osc.ix_tb_osc_parceira_projeto;

CREATE UNIQUE INDEX ix_tb_osc_parceira_projeto
    ON osc.tb_osc_parceira_projeto USING btree
    (id_osc_parceira_projeto ASC NULLS LAST)
TABLESPACE pg_default;