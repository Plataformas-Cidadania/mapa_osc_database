CREATE UNIQUE INDEX ix_vw_osc_fonte_recursos_projeto
    ON portal.vw_osc_fonte_recursos_projeto USING btree
    (id_projeto,id_fonte_recursos_projeto ASC NULLS LAST)
    TABLESPACE pg_default;
