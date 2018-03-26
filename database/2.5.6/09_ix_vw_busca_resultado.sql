CREATE UNIQUE INDEX ix_vw_busca_resultado
    ON osc.vw_busca_resultado USING btree
    (id_osc ASC NULLS LAST)
TABLESPACE pg_default;
