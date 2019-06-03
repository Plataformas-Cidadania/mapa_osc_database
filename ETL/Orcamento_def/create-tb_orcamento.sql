
CREATE TABLE graph.tb_orcamento_def
(
id_orcamento_def serial NOT NULL,
nr_orcamento_cnpj numeric,
nr_orcamento_ano integer,
nr_vl_empenhado_def double precision, 
CONSTRAINT pk_tb_orcamento_def PRIMARY KEY (id_orcamento_def)
);

COMMENT ON TABLE graph.tb_orcamento_def IS 'Tabela dos orcamentos federais das OSCs';

COMMENT ON COLUMN graph.tb_orcamento_def.id_orcamento_def IS 'Identificador do orcamento';
COMMENT ON COLUMN graph.tb_orcamento_def.nr_orcamento_cnpj IS 'CNPJ da OSC';
COMMENT ON COLUMN graph.tb_orcamento_def.nr_orcamento_ano  IS 'Ano em que o orcamento foi repassado';
COMMENT ON COLUMN graph.tb_orcamento_def.nr_vl_empenhado_def IS 'Valor do orcamento';

COMMENT ON CONSTRAINT pk_tb_orcamento_def ON graph.tb_orcamento_def IS 'Chave primária da tabela de orcamento';

CREATE INDEX ix_tb_orcamento_def ON graph.tb_orcamento_def(id_orcamento_def);

