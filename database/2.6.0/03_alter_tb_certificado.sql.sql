ALTER TABLE osc.tb_certificado ADD cd_municipio NUMERIC DEFAULT null;
ALTER TABLE osc.tb_certificado ADD cd_uf NUMERIC DEFAULT null;

ALTER TABLE osc.tb_certificado 
ADD CONSTRAINT fk_cd_municipio 
FOREIGN KEY (cd_municipio) 
REFERENCES spat.ed_municipio(edmu_cd_municipio);

ALTER TABLE osc.tb_certificado 
ADD CONSTRAINT fk_cd_uf 
FOREIGN KEY (cd_uf) 
REFERENCES spat.ed_uf(eduf_cd_uf);

ALTER TABLE osc.tb_certificado ADD ft_municipio TEXT DEFAULT null;
ALTER TABLE osc.tb_certificado ADD ft_estado TEXT DEFAULT null;