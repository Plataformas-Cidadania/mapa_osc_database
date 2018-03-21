-- object: portal.vw_log_alteracao | type: MATERIALIZED VIEW --
DROP MATERIALIZED VIEW IF EXISTS portal.vw_log_alteracao CASCADE;
CREATE MATERIALIZED VIEW portal.vw_log_alteracao
AS

SELECT 
	b.id_osc, 
	b.tx_apelido_osc, 
	b.tx_nome_osc, 
	a.id_log_alteracao, 
	a.tx_nome_tabela, 
	a.tx_fonte_dados, 
	a.dt_alteracao, 
	a.tx_dado_anterior, 
	a.tx_dado_posterior, 
	a.id_carga 
FROM 
	log.tb_log_alteracao AS a 
INNER JOIN 
	portal.vw_osc_dados_gerais AS b 
ON 
	a.id_osc = b.id_osc 
WHERE a.id_log_alteracao IN (
	SELECT MAX(id_log_alteracao) 
	FROM log.tb_log_alteracao 
	GROUP BY id_osc
)
ORDER BY a.id_log_alteracao DESC;

-- ddl-end --
ALTER MATERIALIZED VIEW portal.vw_log_alteracao OWNER TO postgres;
-- ddl-end --

CREATE UNIQUE INDEX ix_vw_log_alteracao
    ON portal.vw_log_alteracao USING btree
    (id_log_alteracao, id_osc, dt_alteracao ASC NULLS LAST)
TABLESPACE pg_default;
