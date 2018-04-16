DROP FUNCTION IF EXISTS portal.obter_osc_certificado(param TEXT);

CREATE OR REPLACE FUNCTION portal.obter_osc_certificado(param TEXT) RETURNS TABLE (
	id_certificado INTEGER, 
	cd_certificado INTEGER, 
	tx_nome_certificado TEXT, 
	dt_inicio_certificado TEXT, 
	dt_fim_certificado TEXT, 
	cd_municipio INTEGER, 
	tx_municipio TEXT, 
	ft_municipio TEXT, 
	cd_uf INTEGER, 
	tx_uf TEXT, 
	ft_uf TEXT, 
	ft_certificado TEXT, 
	bo_oficial BOOLEAN
) AS $$ 
BEGIN 
	RETURN QUERY 
		SELECT
			tb_certificado.id_certificado,
			tb_certificado.cd_certificado::INTEGER,
			dc_certificado.tx_nome_certificado,
			TO_CHAR(tb_certificado.dt_inicio_certificado, 'DD-MM-YYYY') AS dt_inicio_certificado,
			TO_CHAR(tb_certificado.dt_fim_certificado, 'DD-MM-YYYY') AS dt_fim_certificado,
			tb_certificado.cd_municipio::INTEGER,
			(SELECT ed_municipio.edmu_nm_municipio || ' - ' || ed_uf.eduf_sg_uf FROM spat.ed_municipio LEFT JOIN spat.ed_uf ON ed_municipio.eduf_cd_uf = ed_uf.eduf_cd_uf WHERE edmu_cd_municipio = tb_certificado.cd_municipio) AS tx_municipio,
			tb_certificado.ft_municipio,
			tb_certificado.cd_uf::INTEGER,
			(SELECT eduf_nm_uf FROM spat.ed_uf WHERE eduf_cd_uf = tb_certificado.cd_uf)::TEXT AS tx_uf,
			tb_certificado.ft_uf,
			tb_certificado.ft_certificado,
			tb_certificado.bo_oficial
		FROM osc.tb_osc
		LEFT JOIN osc.tb_certificado ON tb_osc.id_osc = tb_certificado.id_osc
		LEFT JOIN syst.dc_certificado ON tb_certificado.cd_certificado = dc_certificado.cd_certificado
		WHERE tb_osc.bo_osc_ativa
		AND (
			tb_osc.id_osc = param::INTEGER
			OR tb_osc.tx_apelido_osc = param
		);
		
END;
$$ LANGUAGE 'plpgsql';
