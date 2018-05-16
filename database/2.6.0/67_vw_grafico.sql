-- object: portal.vw_grafico | type: MATERIALIZED VIEW --
DROP MATERIALIZED VIEW IF EXISTS portal.vw_grafico CASCADE;
CREATE MATERIALIZED VIEW portal.vw_grafico
AS

SELECT * FROM portal.obter_graficos();

-- ddl-end --
ALTER MATERIALIZED VIEW portal.vw_grafico OWNER TO postgres;
-- ddl-end --

