CREATE TABLE syst.tb_tipo_grafico(
	id_tipo_grafico SERIAL, 
	nome_tipo_grafico TEXT, 
	status INTEGER, 
	CONSTRAINT pk_tb_tipo_grafico PRIMARY KEY (id_tipo_grafico)
);
