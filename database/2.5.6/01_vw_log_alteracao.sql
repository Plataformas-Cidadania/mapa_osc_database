-- object: portal.vw_log_alteracao | type: MATERIALIZED VIEW --
DROP MATERIALIZED VIEW IF EXISTS portal.vw_log_alteracao CASCADE;
CREATE MATERIALIZED VIEW portal.vw_log_alteracao
AS

SELECT distinct y.dt_alteracao
     , y.id_osc
     , vw_osc_dados_gerais.tx_nome_osc
FROM log.tb_log_alteracao y
JOIN
    ( SELECT id_osc
           , MAX(dt_alteracao) AS currentTS
      FROM log.tb_log_alteracao
      GROUP BY id_osc
    ) AS grp
  ON grp.id_osc = y.id_osc
    AND grp.currentTS = y.dt_alteracao
join portal.vw_osc_dados_gerais ON y.id_osc = vw_osc_dados_gerais.id_osc
ORDER BY y.dt_alteracao DESC
limit 10;

-- ddl-end --
ALTER MATERIALIZED VIEW portal.vw_log_alteracao OWNER TO postgres;
-- ddl-end --

CREATE UNIQUE INDEX ix_vw_log_alteracao
    ON portal.vw_log_alteracao USING btree
    (id_osc, dt_alteracao ASC NULLS LAST)
TABLESPACE pg_default;
