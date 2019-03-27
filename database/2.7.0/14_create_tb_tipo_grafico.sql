DROP TABLE IF EXISTS syst.tb_tipo_grafico CASCADE;

CREATE TABLE syst.tb_tipo_grafico(
	id_grafico SERIAL, 
	nome_tipo_grafico TEXT, 
	status INTEGER, 
	CONSTRAINT pk_tb_tipo_grafico PRIMARY KEY (id_grafico)
);
