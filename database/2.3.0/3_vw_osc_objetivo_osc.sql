-- object: portal.vw_osc_objetivo_osc | type: MATERIALIZED VIEW --
DROP MATERIALIZED VIEW IF EXISTS portal.vw_osc_objetivo_osc CASCADE;
CREATE MATERIALIZED VIEW portal.vw_osc_objetivo_osc
AS

SELECT
	tb_objetivo_osc.id_osc,
	tb_objetivo_osc.id_objetivo_osc,
	(SELECT cd_objetivo_projeto FROM syst.dc_objetivo_projeto WHERE cd_objetivo_projeto = (SELECT cd_objetivo_projeto FROM syst.dc_meta_projeto WHERE cd_meta_projeto = tb_objetivo_osc.cd_meta_osc)) AS cd_objetivo_osc,
	(SELECT tx_codigo_objetivo_projeto || '. ' || tx_nome_objetivo_projeto FROM syst.dc_objetivo_projeto WHERE cd_objetivo_projeto = (SELECT cd_objetivo_projeto FROM syst.dc_meta_projeto WHERE cd_meta_projeto = tb_objetivo_osc.cd_meta_osc)) AS tx_nome_objetivo_osc,
	tb_objetivo_osc.cd_meta_osc,
	(SELECT tx_codigo_meta_projeto || ' ' || tx_nome_meta_projeto FROM syst.dc_meta_projeto WHERE cd_meta_projeto = tb_objetivo_osc.cd_meta_osc) AS tx_nome_meta_osc,
	tb_objetivo_osc.ft_objetivo_osc 
FROM osc.tb_osc 
INNER JOIN osc.tb_objetivo_osc ON tb_objetivo_osc.id_osc = osc.tb_osc.id_osc 
WHERE tb_osc.bo_osc_ativa;
-- ddl-end --
ALTER MATERIALIZED VIEW portal.vw_osc_objetivo_osc OWNER TO postgres;
-- ddl-end --