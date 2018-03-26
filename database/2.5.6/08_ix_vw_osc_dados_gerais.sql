CREATE UNIQUE INDEX ix_vw_osc_dados_gerais
    ON portal.vw_osc_dados_gerais USING btree
    (id_osc ASC NULLS LAST)
TABLESPACE pg_default;
