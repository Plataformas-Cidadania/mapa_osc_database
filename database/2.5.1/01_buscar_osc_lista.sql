DROP FUNCTION IF EXISTS portal.buscar_osc_lista(param TEXT, limit_result INTEGER, offset_result INTEGER, similarity_result INTEGER);

CREATE OR REPLACE FUNCTION portal.buscar_osc_lista(param TEXT, limit_result INTEGER, offset_result INTEGER, similarity_result INTEGER) RETURNS TABLE(
	id_osc INTEGER,
	tx_nome_osc TEXT,
	cd_identificador_osc TEXT,
	tx_natureza_juridica_osc TEXT,
	tx_endereco_osc TEXT,
	tx_nome_atividade_economica TEXT,
	im_logo TEXT
) AS $$

BEGIN
	RETURN QUERY
		SELECT
			vw_busca_resultado.id_osc,
			vw_busca_resultado.tx_nome_osc,
			vw_busca_resultado.cd_identificador_osc,
			vw_busca_resultado.tx_natureza_juridica_osc,
			vw_busca_resultado.tx_endereco_osc,
			vw_busca_resultado.tx_nome_atividade_economica,
			vw_busca_resultado.im_logo
		FROM
			osc.vw_busca_resultado
		WHERE 
			vw_busca_resultado.id_osc IN (SELECT portal.buscar_osc(param, limit_result, offset_result, similarity_result));
			
END;
$$ LANGUAGE 'plpgsql';
