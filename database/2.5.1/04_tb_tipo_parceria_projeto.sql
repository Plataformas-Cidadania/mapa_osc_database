-- object: osc.tb_tipo_parceria_projeto | type: TABLE --
DROP TABLE IF EXISTS osc.tb_tipo_parceria_projeto CASCADE;
CREATE TABLE osc.tb_tipo_parceria_projeto(
	id_tipo_parceria_projeto serial NOT NULL,
	id_projeto INTEGER NOT NULL,
	cd_origem_fonte_recursos_projeto integer NOT NULL,
	cd_tipo_parceria_projeto integer NOT NULL,
	ft_tipo_parceria_projeto text,
	CONSTRAINT pk_tb_tipo_parceria_projeto PRIMARY KEY (id_tipo_parceria_projeto),
    CONSTRAINT fk_id_projeto FOREIGN KEY (id_projeto)
        REFERENCES osc.tb_projeto (id_projeto) MATCH FULL
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_cd_fonte_recursos_projeto FOREIGN KEY (cd_origem_fonte_recursos_projeto)
        REFERENCES syst.dc_origem_fonte_recursos_projeto (cd_origem_fonte_recursos_projeto) MATCH FULL
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_cd_tipo_parceria_projeto FOREIGN KEY (cd_tipo_parceria_projeto)
        REFERENCES syst.dc_tipo_parceria (cd_tipo_parceria) MATCH FULL
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
-- ddl-end --
COMMENT ON TABLE osc.tb_tipo_parceria_projeto IS 'Tipo de parcerias de projeto';
-- ddl-end --
COMMENT ON COLUMN osc.tb_tipo_parceria_projeto.id_tipo_parceria_projeto IS 'Identificador do tipo de parceria do projeto';
-- ddl-end --
COMMENT ON COLUMN osc.tb_tipo_parceria_projeto.id_projeto IS 'Identificador do projeto';
-- ddl-end --
COMMENT ON COLUMN osc.tb_tipo_parceria_projeto.cd_origem_fonte_recursos_projeto IS 'Código da origem da fonte de recursos do projeto';
-- ddl-end --
COMMENT ON COLUMN osc.tb_tipo_parceria_projeto.cd_tipo_parceria_projeto IS 'Código da tipo de parceria do projeto';
-- ddl-end --
COMMENT ON COLUMN osc.tb_tipo_parceria_projeto.ft_tipo_parceria_projeto IS 'Fonte do tipo de parceria do projeto';
-- ddl-end --
