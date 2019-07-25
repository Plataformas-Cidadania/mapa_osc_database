CREATE TABLE ipeadata.tb_ipeadata_uf
(
 id_ipeadata_uf serial NOT NULL,
 cd_uf numeric(2,0) NOT NULL,
 nr_ano integer,
 cd_indice integer,
 nr_valor double precision,
 CONSTRAINT pk_tb_ipeadata_uf PRIMARY KEY (id_ipeadata_uf),
 CONSTRAINT fk_cd_uf FOREIGN KEY (cd_uf)
      REFERENCES spat.ed_uf (eduf_cd_uf) MATCH FULL
      ON UPDATE NO ACTION ON DELETE NO ACTION,
 CONSTRAINT fk_cd_indice FOREIGN KEY (cd_indice)
      REFERENCES ipeadata.tb_indice (cd_indice) MATCH FULL
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

COMMENT ON TABLE ipeadata.tb_ipeadata_uf IS 'Tabela dos valores dos indices do IpeaData por estado';

COMMENT ON COLUMN ipeadata.tb_ipeadata_uf.id_ipeadata_uf IS 'Identificador do valor por estado';
COMMENT ON COLUMN ipeadata.tb_ipeadata_uf.cd_uf IS 'Código do estado';
COMMENT ON COLUMN ipeadata.tb_ipeadata_uf.nr_ano IS 'Ano em que o valor foi composto';
COMMENT ON COLUMN ipeadata.tb_ipeadata_uf.cd_indice IS 'Código do indice';
COMMENT ON COLUMN ipeadata.tb_ipeadata_uf.nr_valor IS 'Valor do indice';

COMMENT ON CONSTRAINT pk_tb_ipeadata_uf ON ipeadata.tb_ipeadata_uf IS 'Chave primária da tabela IpeaData UF';

CREATE INDEX ix_ipeadata_uf ON ipeadata.tb_ipeadata_uf(cd_uf,cd_indice);

