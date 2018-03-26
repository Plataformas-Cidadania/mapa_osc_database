-- object: portal.vw_log_alteracao | type: MATERIALIZED VIEW --
DROP MATERIALIZED VIEW IF EXISTS portal.vw_log_alteracao CASCADE;
CREATE MATERIALIZED VIEW portal.vw_log_alteracao
AS

SELECT DISTINCT tb_log_alteracao.id_osc, tb_log_alteracao.dt_alteracao, vw_osc_dados_gerais.tx_nome_osc 
FROM log.tb_log_alteracao 
LEFT JOIN portal.vw_osc_dados_gerais 
ON tb_log_alteracao.id_osc = vw_osc_dados_gerais.id_osc 
ORDER BY dt_alteracao DESC 
LIMIT 10;

-- ddl-end --
ALTER MATERIALIZED VIEW portal.vw_log_alteracao OWNER TO postgres;
-- ddl-end --

CREATE UNIQUE INDEX ix_vw_log_alteracao
    ON portal.vw_log_alteracao USING btree
    (id_osc, dt_alteracao ASC NULLS LAST)
TABLESPACE pg_default;
