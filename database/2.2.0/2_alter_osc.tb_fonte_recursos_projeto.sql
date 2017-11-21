ALTER TABLE osc.tb_fonte_recursos_projeto ADD cd_tipo_parceria INTEGER;

ALTER TABLE osc.tb_fonte_recursos_projeto 
ADD CONSTRAINT fk_cd_parceira_projeto FOREIGN KEY (cd_tipo_parceria) 
REFERENCES syst.dc_tipo_parceria (cd_tipo_parceria);
