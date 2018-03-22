-- object: portal.vw_log_alteracao | type: MATERIALIZED VIEW --
DROP MATERIALIZED VIEW IF EXISTS portal.vw_log_alteracao CASCADE;
CREATE MATERIALIZED VIEW portal.vw_log_alteracao
AS

SELECT 
	tb_log_alteracao.id_osc, 
	(SELECT tx_apelido_osc FROM portal.vw_osc_dados_gerais WHERE id_osc = tb_log_alteracao.id_osc) AS tx_apelido_osc, 
	(SELECT tx_nome_osc FROM portal.vw_osc_dados_gerais WHERE id_osc = tb_log_alteracao.id_osc) AS tx_nome_osc, 
	tb_log_alteracao.id_log_alteracao, 
	tb_log_alteracao.tx_nome_tabela, 
	tb_log_alteracao.tx_fonte_dados, 
	tb_log_alteracao.dt_alteracao, 
	tb_log_alteracao.tx_dado_anterior, 
	tb_log_alteracao.tx_dado_posterior, 
	tb_log_alteracao.id_carga 
FROM 
	log.tb_log_alteracao 
WHERE tb_log_alteracao.id_log_alteracao IN (
	SELECT MAX(id_log_alteracao) 
	FROM log.tb_log_alteracao 
	GROUP BY id_osc
)
ORDER BY tb_log_alteracao.id_log_alteracao DESC;

-- ddl-end --
ALTER MATERIALIZED VIEW portal.vw_log_alteracao OWNER TO postgres;
-- ddl-end --

CREATE UNIQUE INDEX ix_vw_log_alteracao
    ON portal.vw_log_alteracao USING btree
    (id_log_alteracao, id_osc, dt_alteracao ASC NULLS LAST)
TABLESPACE pg_default;
