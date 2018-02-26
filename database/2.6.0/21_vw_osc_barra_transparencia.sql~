-- Materialized View: portal.vw_osc_barra_transparencia 

DROP MATERIALIZED VIEW IF EXISTS portal.vw_osc_barra_transparencia;

CREATE MATERIALIZED VIEW portal.vw_osc_barra_transparencia  AS 
	SELECT 
		* 
	FROM 
		portal.obter_barra_transparencia_osc()
	WITH DATA;

ALTER TABLE portal.vw_osc_barra_transparencia OWNER TO postgres;
