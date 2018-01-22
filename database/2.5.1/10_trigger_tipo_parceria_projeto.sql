CREATE UNIQUE INDEX ix_vw_osc_tipo_parceria_projeto
    ON portal.vw_osc_tipo_parceria_projeto USING btree
    (id_tipo_parceria_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

-- Function: public.tipo_parceria_projeto()
-- DROP FUNCTION public.tipo_parceria_projeto();
CREATE OR REPLACE FUNCTION public.tipo_parceria_projeto() RETURNS 
	trigger 
AS $$

BEGIN
	REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_tipo_parceria_projeto;
	RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';

-- Trigger: tipo parceria on osc.tb_financiador_projeto
-- DROP TRIGGER tipo_parceria_projeto ON osc.tb_financiador_projeto;
CREATE TRIGGER tipo_parceria_projeto
	AFTER INSERT OR UPDATE OR DELETE
	ON osc.tb_tipo_parceria_projeto
	FOR EACH ROW
	EXECUTE PROCEDURE public.tipo_parceria_projeto();