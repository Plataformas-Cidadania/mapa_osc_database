CREATE UNIQUE INDEX ix_vw_osc_barra_transparencia
    ON portal.vw_osc_barra_transparencia USING btree
    (id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_vw_busca_osc_geo
    ON osc.vw_busca_osc_geo USING btree
    (id_osc ASC NULLS LAST)
    TABLESPACE pg_default;
