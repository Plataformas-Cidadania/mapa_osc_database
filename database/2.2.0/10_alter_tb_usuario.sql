ALTER TABLE portal.tb_usuario ADD cd_municipio INTEGER;
ALTER TABLE portal.tb_usuario ADD cd_uf INTEGER;

ALTER TABLE portal.tb_usuario 
ADD CONSTRAINT fk_cd_municipio FOREIGN KEY (cd_municipio) 
REFERENCES spat.ed_municipio (edmu_cd_municipio);

ALTER TABLE portal.tb_usuario 
ADD CONSTRAINT fk_cd_uf FOREIGN KEY (cd_uf) 
REFERENCES spat.ed_uf (eduf_cd_uf);
