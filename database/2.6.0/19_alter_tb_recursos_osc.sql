ALTER TABLE osc.tb_recursos_osc ALTER COLUMN cd_fonte_recursos_osc DROP NOT NULL;

ALTER TABLE osc.tb_recursos_osc DROP CONSTRAINT IF EXISTS un_recursos_osc;
ALTER TABLE osc.tb_recursos_osc ADD CONSTRAINT un_recursos_osc UNIQUE (id_osc, cd_origem_fonte_recursos_osc, cd_fonte_recursos_osc, dt_ano_recursos_osc);