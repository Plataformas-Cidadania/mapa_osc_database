DROP FUNCTION IF EXISTS portal.obter_osc_certificado(param TEXT);

CREATE OR REPLACE FUNCTION portal.obter_osc_certificado(param TEXT) RETURNS TABLE (
	resultado JSONB,
	mensagem TEXT,
	flag BOOLEAN
) AS $$ 

DECLARE
	linha RECORD;
	osc RECORD;

BEGIN 
	resultado := null;

	SELECT INTO osc * FROM osc.tb_osc WHERE (id_osc = param::INTEGER OR tx_apelido_osc = param) AND bo_osc_ativa;
	
	IF osc.id_osc IS NOT null THEN 		
		SELECT INTO linha
			array_agg(a) AS array 
		FROM (
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
			FROM osc.tb_certificado 
			LEFT JOIN syst.dc_certificado 
			ON tb_certificado.cd_certificado = dc_certificado.cd_certificado
			WHERE tb_certificado.id_osc = osc.id_osc
		) a;
		
		IF ARRAY_LENGTH(linha.array, 1) > 0 THEN 
			resultado := to_jsonb(linha.array);
		END IF;

		flag := true;
		mensagem := 'Certificado(s) retornado(s).';

	ELSE 
		flag := false;
		mensagem := 'OSC não encontrada.';
	END IF;

	RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
