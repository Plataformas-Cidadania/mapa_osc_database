
CREATE TABLE ipeadata.tb_ipca
(
id_ipca serial NOT NULL,
nr_ipca_ano integer,
nr_ipca_mes integer,
cd_indice integer,
nr_ipca_valor double precision,
CONSTRAINT pk_tb_ipca PRIMARY KEY (id_ipca),
CONSTRAINT fk_cd_indice FOREIGN KEY (cd_indice)
      REFERENCES ipeadata.tb_indice (cd_indice) MATCH FULL
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

COMMENT ON TABLE ipeadata.tb_ipca IS 'Tabela dos valores do IPCA';

COMMENT ON COLUMN ipeadata.tb_ipca.id_ipca IS 'Identificador do valor do IPCA';
COMMENT ON COLUMN ipeadata.tb_ipca.nr_ipca_ano IS 'Ano em que o valor foi composto';
COMMENT ON COLUMN ipeadata.tb_ipca.nr_ipca_mes IS 'Mês em que o valor foi composto';
COMMENT ON COLUMN ipeadata.tb_ipca.nr_ipca_valor IS 'Valor do IPCA';

COMMENT ON CONSTRAINT pk_tb_ipca ON ipeadata.tb_ipca IS 'Chave primária da tabela do IPCA';

CREATE INDEX ix_tb_ipca ON ipeadata.tb_ipca(id_ipca,nr_ipca_valor);

