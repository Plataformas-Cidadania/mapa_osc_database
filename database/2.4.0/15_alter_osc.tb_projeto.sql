ALTER TABLE osc.tb_projeto ADD tx_status_projeto_outro TEXT;
ALTER TABLE osc.tb_projeto ADD cd_municipio INTEGER;
ALTER TABLE osc.tb_projeto ADD ft_municipio TEXT;
ALTER TABLE osc.tb_projeto ADD cd_uf INTEGER;
ALTER TABLE osc.tb_projeto ADD ft_uf TEXT;

ALTER TABLE osc.tb_projeto 
ADD CONSTRAINT fk_cd_municipio FOREIGN KEY (cd_municipio) 
REFERENCES spat.ed_municipio (edmu_cd_municipio);

ALTER TABLE osc.tb_projeto 
ADD CONSTRAINT fk_cd_uf FOREIGN KEY (cd_uf) 
REFERENCES spat.ed_uf (eduf_cd_uf);

ALTER TABLE osc.tb_projeto 
ADD CONSTRAINT unique_projeto_municipio UNIQUE (tx_identificador_projeto_externo, cd_municipio);

ALTER TABLE osc.tb_projeto 
ADD CONSTRAINT unique_projeto_uf UNIQUE (tx_identificador_projeto_externo, cd_uf);
