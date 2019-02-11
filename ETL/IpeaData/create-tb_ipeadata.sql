CREATE SCHEMA ipeadata;




CREATE TABLE ipeadata.tb_indice
(
cd_indice serial NOT NULL, -- Código do Indice do IPEAData
tx_nome_indice text NOT NULL, -- Nome do Indice do IPEAData
tx_sigla text NOT NULL, -- Sigla do Indice do IPEAData
CONSTRAINT pk_dc_indice PRIMARY KEY (cd_indice) -- Chave primária do Indice do IPEAData (dicionário)
);

COMMENT ON TABLE ipeadata.tb_indice IS 'Tabela dos indices do IpeaData';

COMMENT ON COLUMN ipeadata.tb_indice.cd_indice IS 'Código do indice do IpeaData no MapaOSC';
COMMENT ON COLUMN ipeadata.tb_indice.tx_nome_indice IS 'Nome do Indice do IPEAData';
COMMENT ON COLUMN ipeadata.tb_indice.tx_sigla IS 'Sigla do Indice do IPEAData';

COMMENT ON CONSTRAINT pk_dc_indice ON ipeadata.tb_indice IS 'Chave primária da tabela de dicionário de indices';
-- -- --

CREATE TABLE ipeadata.tb_ipeadata
(
 id_ipeadata serial NOT NULL,
 cd_municipio numeric(7,0) NOT NULL,
 nr_ano integer,
 cd_indice integer,
 nr_valor double precision,
 CONSTRAINT pk_tb_ipeadata PRIMARY KEY (id_ipeadata),
 CONSTRAINT fk_cd_municipio FOREIGN KEY (cd_municipio)
      REFERENCES spat.ed_municipio (edmu_cd_municipio) MATCH FULL
      ON UPDATE NO ACTION ON DELETE NO ACTION,
 CONSTRAINT fk_cd_indice FOREIGN KEY (cd_indice)
      REFERENCES ipeadata.tb_indice (cd_indice) MATCH FULL
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

COMMENT ON TABLE ipeadata.tb_ipeadata IS 'Tabela dos valores dos indices do IpeaData por municipio';

COMMENT ON COLUMN ipeadata.tb_ipeadata.id_ipeadata IS 'Identificador do valor por municipio';
COMMENT ON COLUMN ipeadata.tb_ipeadata.cd_municipio IS 'Código do municipio';
COMMENT ON COLUMN ipeadata.tb_ipeadata.nr_ano IS 'Ano em que o valor foi composto';
COMMENT ON COLUMN ipeadata.tb_ipeadata.cd_indice IS 'Código do indice';
COMMENT ON COLUMN ipeadata.tb_ipeadata.nr_valor IS 'Valor do indice';

COMMENT ON CONSTRAINT pk_tb_ipeadata ON ipeadata.tb_ipeadata IS 'Chave primária da tabela IpeaData';

CREATE INDEX ix_ipeadata ON ipeadata.tb_ipeadata(cd_municipio,cd_indice);

