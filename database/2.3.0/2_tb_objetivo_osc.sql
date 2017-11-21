-- object: osc.tb_objetivo_osc | type: TABLE --
DROP TABLE IF EXISTS osc.tb_objetivo_osc CASCADE;

CREATE TABLE osc.tb_objetivo_osc(
	id_objetivo_osc serial NOT NULL,
	id_osc integer NOT NULL,
	cd_meta_osc integer NOT NULL,
	ft_objetivo_osc text,
	bo_oficial boolean NOT NULL,
	CONSTRAINT pk_objetivo_osc PRIMARY KEY (id_objetivo_osc),
	CONSTRAINT fk_cd_meta_osc FOREIGN KEY (cd_meta_osc)
		REFERENCES syst.dc_meta_projeto (cd_meta_projeto) MATCH FULL
		ON UPDATE NO ACTION ON DELETE NO ACTION,
	CONSTRAINT fk_id_osc FOREIGN KEY (id_osc)
		REFERENCES osc.tb_osc (id_osc) MATCH FULL
		ON UPDATE NO ACTION ON DELETE NO ACTION
);
-- ddl-end --
COMMENT ON TABLE osc.tb_objetivo_osc IS 'Tabela com o objetivo do OSC';
-- ddl-end --
COMMENT ON COLUMN osc.tb_objetivo_osc.id_objetivo_osc IS 'Identificador do objetivo do OSC';
-- ddl-end --
COMMENT ON COLUMN osc.tb_objetivo_osc.id_osc IS 'Identificador do OSC';
-- ddl-end --
COMMENT ON COLUMN osc.tb_objetivo_osc.cd_meta_osc IS 'Código da meta do OSC';
-- ddl-end --
COMMENT ON COLUMN osc.tb_objetivo_osc.ft_objetivo_osc IS 'Fonte do objetivo do OSC';
-- ddl-end --
COMMENT ON COLUMN osc.tb_objetivo_osc.bo_oficial IS 'Registro vindo de base oficial';
-- ddl-end --
COMMENT ON CONSTRAINT pk_objetivo_osc ON osc.tb_objetivo_osc IS 'Chave primária do objetivo do OSC';
-- ddl-end --
ALTER TABLE osc.tb_objetivo_osc OWNER TO postgres;
-- ddl-end --
