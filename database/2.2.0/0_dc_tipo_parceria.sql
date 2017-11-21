-- object: syst.dc_tipo_parceria | type: TABLE --
-- DROP TABLE IF EXISTS syst.dc_tipo_parceria CASCADE;
CREATE TABLE syst.dc_tipo_parceria(
	cd_tipo_parceria serial NOT NULL,
	tx_nome_tipo_parceria text NOT NULL,
	CONSTRAINT pk_tipo_parceria PRIMARY KEY (cd_tipo_parceria)
);
-- ddl-end --
COMMENT ON TABLE syst.dc_tipo_parceria IS 'Tipo de parceria';
-- ddl-end --
COMMENT ON COLUMN syst.dc_tipo_parceria.cd_tipo_parceria IS 'Código do tipo de parceria';
-- ddl-end --
COMMENT ON COLUMN syst.dc_tipo_parceria.tx_nome_tipo_parceria IS 'Nome do tipo de parceria';
-- ddl-end --
COMMENT ON CONSTRAINT pk_tipo_parceria ON syst.dc_tipo_parceria  IS 'Chave primária';
-- ddl-end --
ALTER TABLE syst.dc_tipo_parceria OWNER TO postgres;
-- ddl-end --
