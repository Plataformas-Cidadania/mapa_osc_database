-- object: portal.vw_log_alteracao | type: MATERIALIZED VIEW --
DROP MATERIALIZED VIEW IF EXISTS portal.vw_log_alteracao CASCADE;
CREATE MATERIALIZED VIEW portal.vw_log_alteracao
AS

SELECT
	id_log_alteracao, 
	tx_nome_tabela, 
	id_osc, 
	tx_fonte_dados, 
	dt_alteracao, 
	tx_dado_anterior, 
	tx_dado_posterior, 
	id_carga 
FROM log.tb_log_alteracao;
-- ddl-end --
ALTER MATERIALIZED VIEW portal.vw_log_alteracao OWNER TO postgres;
-- ddl-end --

CREATE UNIQUE INDEX ix_vw_log_alteracao
    ON portal.vw_log_alteracao USING btree
    (id_log_alteracao, id_osc, dt_alteracao ASC NULLS LAST)
TABLESPACE pg_default;
