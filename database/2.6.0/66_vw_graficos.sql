-- object: portal.vw_graficos | type: MATERIALIZED VIEW --
DROP MATERIALIZED VIEW IF EXISTS portal.vw_graficos CASCADE;

CREATE MATERIALIZED VIEW portal.vw_graficos
AS

SELECT id, titulo, tipo, dados::JSONB
FROM (
	SELECT 1 AS id, titulo, tipo, dados::TEXT, NOW() AS data_atualizacao FROM (SELECT * FROM portal.obter_grafico_distribuicao_osc_empregados_regiao()) AS dados 
	UNION /*
	SELECT 2 AS id, titulo, tipo, dados::TEXT, NOW() AS data_atualizacao FROM (SELECT * FROM portal.obter_grafico_empregos_formais_oscs_regiao()) AS dados 
	UNION 
	SELECT 3 AS id, titulo, tipo, dados::TEXT, NOW() AS data_atualizacao FROM (SELECT * FROM portal.obter_grafico_oscs_area_atuacao()) AS dados 
	UNION 
	SELECT 4 AS id, titulo, tipo, dados::TEXT, NOW() AS data_atualizacao FROM (SELECT * FROM portal.obter_oscs_assistencia_social_tipo_servico()) AS dados 
	UNION 
	SELECT 5 AS id, titulo, tipo, dados::TEXT, NOW() AS data_atualizacao FROM (SELECT * FROM portal.obter_oscs_saude_tipo_estabelecimento()) AS dados 
	UNION 
	SELECT 6 AS id, titulo, tipo, dados::TEXT, NOW() AS data_atualizacao FROM (SELECT * FROM portal.obter_grafico_oscs_saude_regiao_tipo_gestao()) AS dados 
	UNION 
	SELECT 10 AS id, titulo, tipo, dados::TEXT, NOW() AS data_atualizacao FROM (SELECT * FROM portal.obter_grafico_osc_natureza_juridica_regiao()) AS dados 
	UNION */
	SELECT 11 AS id, titulo, tipo, dados::TEXT, NOW() AS data_atualizacao FROM (SELECT * FROM portal.obter_grafico_osc_titulos_certificados()) AS dados 
) AS graficos;


-- ddl-end --
ALTER MATERIALIZED VIEW portal.vw_graficos OWNER TO postgres;
-- ddl-end --
