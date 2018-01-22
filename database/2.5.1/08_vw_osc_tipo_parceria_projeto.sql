-- object: portal.vw_osc_tipo_parceria_projeto | type: MATERIALIZED VIEW --
DROP MATERIALIZED VIEW IF EXISTS portal.vw_osc_tipo_parceria_projeto CASCADE;
CREATE MATERIALIZED VIEW portal.vw_osc_tipo_parceria_projeto
AS

SELECT
	tb_tipo_parceria_projeto.id_projeto,
	tb_tipo_parceria_projeto.id_tipo_parceria_projeto,
	tb_tipo_parceria_projeto.cd_origem_fonte_recursos_projeto,
	(
		SELECT tx_nome_origem_fonte_recursos_projeto 
		FROM syst.dc_origem_fonte_recursos_projeto 
		WHERE cd_origem_fonte_recursos_projeto = tb_tipo_parceria_projeto.cd_origem_fonte_recursos_projeto
	) AS tx_nome_origem_fonte_recursos_projeto,
	tb_tipo_parceria_projeto.cd_tipo_parceria_projeto,
	(
		SELECT tx_nome_tipo_parceria 
		FROM syst.dc_tipo_parceria 
		WHERE cd_tipo_parceria = tb_tipo_parceria_projeto.cd_tipo_parceria_projeto
	) AS tx_nome_tipo_parceria,
	tb_tipo_parceria_projeto.ft_tipo_parceria_projeto
FROM osc.tb_osc
INNER JOIN osc.tb_projeto ON osc.tb_projeto.id_osc = osc.tb_osc.id_osc
INNER JOIN osc.tb_tipo_parceria_projeto ON tb_tipo_parceria_projeto.id_projeto = osc.tb_projeto.id_projeto
WHERE tb_osc.bo_osc_ativa;
-- ddl-end --
ALTER MATERIALIZED VIEW portal.vw_osc_tipo_parceria_projeto OWNER TO postgres;
-- ddl-end --