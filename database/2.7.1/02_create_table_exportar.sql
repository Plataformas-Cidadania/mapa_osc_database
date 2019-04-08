CREATE TABLE cache.tb_exportar(
	id_exportar SERIAL NOT NULL,
	tx_chave TEXT UNIQUE NOT NULL,
	tx_valor TEXT NOT NULL,
	CONSTRAINT pk_tb_exportar PRIMARY KEY (id_exportar)
);