DROP MATERIALIZED VIEW portal.vw_osc_tipo_parceria_projeto;

ALTER TABLE osc.tb_tipo_parceria_projeto DROP CONSTRAINT fk_cd_fonte_recursos_projeto;
ALTER TABLE osc.tb_tipo_parceria_projeto DROP COLUMN cd_origem_fonte_recursos_projeto;

ALTER TABLE osc.tb_tipo_parceria_projeto ADD COLUMN id_fonte_recursos_projeto INTEGER;
ALTER TABLE osc.tb_tipo_parceria_projeto 
	ADD CONSTRAINT fk_id_fonte_recursos_projeto 
	FOREIGN KEY (id_fonte_recursos_projeto) 
	REFERENCES osc.tb_fonte_recursos_projeto(id_fonte_recursos_projeto);
