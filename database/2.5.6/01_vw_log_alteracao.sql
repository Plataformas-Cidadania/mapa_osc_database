-- object: portal.vw_log_alteracao | type: MATERIALIZED VIEW --
DROP MATERIALIZED VIEW IF EXISTS portal.vw_log_alteracao CASCADE;
CREATE MATERIALIZED VIEW portal.vw_log_alteracao
AS

SELECT
	tb_osc.id_osc,
	tb_osc.tx_apelido_osc,
	tb_certificado.id_certificado,
	tb_certificado.cd_certificado,
	(SELECT tx_nome_certificado FROM syst.dc_certificado WHERE cd_certificado = tb_certificado.cd_certificado) AS tx_nome_certificado,
	TO_CHAR(tb_certificado.dt_inicio_certificado, 'DD-MM-YYYY') AS dt_inicio_certificado,
	TO_CHAR(tb_certificado.dt_fim_certificado, 'DD-MM-YYYY') AS dt_fim_certificado,
	tb_certificado.cd_municipio,
	(SELECT edmu_nm_municipio FROM spat.ed_municipio WHERE edmu_cd_municipio = tb_certificado.cd_municipio) AS tx_municipio,
	tb_certificado.ft_municipio,
	tb_certificado.cd_uf,
	(SELECT eduf_nm_uf FROM spat.ed_uf WHERE eduf_cd_uf = tb_certificado.cd_uf) AS tx_uf,
	tb_certificado.ft_uf,
	tb_certificado.ft_certificado,
	tb_certificado.bo_oficial
FROM osc.tb_osc
INNER JOIN osc.tb_certificado ON tb_osc.id_osc = tb_certificado.id_osc
WHERE tb_osc.bo_osc_ativa;
-- ddl-end --
ALTER MATERIALIZED VIEW portal.vw_osc_certificado OWNER TO postgres;
-- ddl-end --

CREATE UNIQUE INDEX ix_vw_osc_certificado
    ON portal.vw_osc_certificado USING btree
    (id_osc,id_certificado ASC NULLS LAST)
TABLESPACE pg_default;
