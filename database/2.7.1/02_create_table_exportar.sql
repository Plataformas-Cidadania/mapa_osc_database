CREATE TABLE cache.tb_exportar(
	id_exportar SERIAL NOT NULL,
	tx_dado TEXT NOT NULL,
    dt_data_expiracao TIMESTAMP,
	CONSTRAINT pk_tb_exportar PRIMARY KEY (id_exportar)
);