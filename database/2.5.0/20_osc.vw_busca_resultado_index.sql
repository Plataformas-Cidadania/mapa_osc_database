--CREATE UNIQUE INDEX ix_vw_busca_resultado
--    ON osc.vw_busca_resultado USING btree
--    (id_osc ASC NULLS LAST)
--    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION vw_busca_resultado()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY osc.vw_busca_resultado;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;
