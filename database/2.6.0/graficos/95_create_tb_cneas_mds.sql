CREATE TABLE graph.tb_cneas_mds(
	id_cneas_mds serial NOT NULL, 
	cnpj TEXT, 
	ibge TEXT, 
	uf TEXT, 
	municipio TEXT, 
	nome_fantasia TEXT, 
	razao_Social TEXT, 
	logradouro TEXT, 
	numero TEXT, 
	complemento TEXT, 
	bairro TEXT, 
	cep TEXT, 
	email TEXT, 
	telefone TEXT, 
	bloco_servico TEXT, 
	atividade TEXT, 
	CONSTRAINT pk_tb_cneas_mds PRIMARY KEY (id_cneas_mds)
);
