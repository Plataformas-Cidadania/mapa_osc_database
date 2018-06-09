CREATE TABLE portal.tb_analise(
	id_analise INTEGER NOT NULL,
	configuracao TEXT[], 
	tipo_grafico TEXT, 
	titulo TEXT, 
	legenda TEXT,
	titulo_colunas TEXT[], 
	legenda_x TEXT, 
	legenda_y TEXT,  
	parametros JSONB[], 
	series JSONB, 
	fontes TEXT[], 
	CONSTRAINT pk_tb_analise PRIMARY KEY (id_analise)
);
