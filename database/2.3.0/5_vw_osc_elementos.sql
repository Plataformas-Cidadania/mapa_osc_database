-- object: portal.vw_osc_elementos | type: MATERIALIZED VIEW --
DROP MATERIALIZED VIEW IF EXISTS portal.vw_osc_elementos CASCADE;
CREATE MATERIALIZED VIEW portal.vw_osc_elementos
AS

SELECT
	tb_osc.id_osc,
	tb_osc.tx_apelido_osc,
	tb_elementos.bo_participacao_social_conselho,
	tb_elementos.ft_participacao_social_conselho,
	tb_elementos.bo_participacao_social_conferencia,
	tb_elementos.ft_participacao_social_conferencia,
	tb_elementos.bo_participacao_social_outro,
	tb_elementos.ft_participacao_social_outro,
	tb_elementos.bo_recurso,
	tb_elementos.ft_recurso,
	tb_elementos.bo_certificado,
	tb_elementos.ft_certificado
FROM osc.tb_osc
INNER JOIN osc.tb_elementos
ON tb_osc.id_osc = tb_elementos.id_osc
WHERE tb_osc.bo_osc_ativa;
-- ddl-end --
ALTER MATERIALIZED VIEW portal.vw_osc_elementos OWNER TO postgres;
-- ddl-end --
