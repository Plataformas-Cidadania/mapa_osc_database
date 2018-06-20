-- object: portal.vw_log_alteracao | type: MATERIALIZED VIEW --
CREATE INDEX ix_tb_log_alteracao_2
  ON log.tb_log_alteracao
  USING btree
  (id_carga);

DROP MATERIALIZED VIEW IF EXISTS portal.vw_log_alteracao CASCADE;
CREATE MATERIALIZED VIEW portal.vw_log_alteracao
AS
SELECT DISTINCT y.dt_alteracao,
    y.id_osc,
    COALESCE(NULLIF(btrim(tb_dados_gerais.tx_nome_fantasia_osc), ''::text), tb_dados_gerais.tx_razao_social_osc) AS tx_nome_osc
   FROM log.tb_log_alteracao y
     JOIN ( SELECT tb_log_alteracao.id_osc,
            max(tb_log_alteracao.dt_alteracao) AS currentts
           FROM log.tb_log_alteracao
          WHERE tb_log_alteracao.id_osc <> 789809
          GROUP BY tb_log_alteracao.id_osc) grp ON grp.id_osc = y.id_osc AND grp.currentts = y.dt_alteracao
     JOIN osc.tb_dados_gerais ON y.id_osc = tb_dados_gerais.id_osc
  WHERE y.id_carga is null
  ORDER BY y.dt_alteracao DESC
 LIMIT 10;

CREATE UNIQUE INDEX ix_vw_log_alteracao
    ON portal.vw_log_alteracao USING btree
    (id_osc, dt_alteracao ASC NULLS LAST)
TABLESPACE pg_default;
