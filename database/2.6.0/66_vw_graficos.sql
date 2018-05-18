-- object: portal.vw_graficos | type: MATERIALIZED VIEW --
DROP MATERIALIZED VIEW IF EXISTS portal.vw_graficos CASCADE;

CREATE MATERIALIZED VIEW portal.vw_graficos
AS

SELECT nome, dados::JSONB
FROM (
	SELECT 1 AS id, titulo, tipo, dados FROM (SELECT * FROM portal.obter_grafico_osc_natureza_juridica_regiao()) AS dados
	UNION 
	SELECT 2 AS id, titulo, dados FROM (SELECT * FROM portal.obter_grafico_distribuicao_osc_empregados_regiao()) AS dados
	UNION 
	SELECT 'osc_titulos_certificados'::TEXT AS nome, (SELECT to_json(dados)::TEXT AS dados FROM (SELECT * FROM portal.obter_grafico_osc_titulos_certificados()) AS dados)
) AS graficos;


-- ddl-end --
ALTER MATERIALIZED VIEW portal.vw_graficos OWNER TO postgres;
-- ddl-end --
