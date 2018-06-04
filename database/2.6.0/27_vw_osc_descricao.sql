-- object: portal.vw_osc_descricao | type: MATERIALIZED VIEW --
DROP MATERIALIZED VIEW IF EXISTS portal.vw_osc_descricao CASCADE;
CREATE MATERIALIZED VIEW portal.vw_osc_descricao
AS

SELECT
	tb_osc.id_osc,
	tb_osc.tx_apelido_osc,
	tb_dados_gerais.tx_historico,
	tb_dados_gerais.ft_historico,
	tb_dados_gerais.tx_missao_osc,
	tb_dados_gerais.ft_missao_osc,
	tb_dados_gerais.tx_visao_osc,
	tb_dados_gerais.ft_visao_osc,
	tb_dados_gerais.tx_finalidades_estatutarias,
	tb_dados_gerais.ft_finalidades_estatutarias,
	tb_dados_gerais.tx_link_estatuto_osc,
	tb_dados_gerais.bo_nao_possui_link_estatuto_osc,
	tb_dados_gerais.ft_link_estatuto_osc
FROM osc.tb_osc
INNER JOIN osc.tb_dados_gerais ON tb_osc.id_osc = tb_dados_gerais.id_osc
WHERE tb_osc.bo_osc_ativa;
-- ddl-end --
ALTER MATERIALIZED VIEW portal.vw_osc_descricao OWNER TO postgres;
-- ddl-end --

CREATE UNIQUE INDEX ix_vw_osc_descricao
	ON portal.vw_osc_descricao USING btree
    	(id_osc ASC NULLS LAST)
	TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION dados_gerais()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_dados_gerais;
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_descricao;
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_recursos_projeto;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;
