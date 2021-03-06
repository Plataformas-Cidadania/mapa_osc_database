﻿DROP FUNCTION IF EXISTS portal.buscar_osc_regiao_lista(param NUMERIC, limit_result INTEGER, offset_result INTEGER);

CREATE OR REPLACE FUNCTION portal.buscar_osc_regiao_lista(param NUMERIC, limit_result INTEGER, offset_result INTEGER) RETURNS TABLE(
	id_osc INTEGER,
	tx_nome_osc TEXT,
	cd_identificador_osc NUMERIC(14, 0),
	tx_natureza_juridica_osc TEXT,
	tx_endereco_osc TEXT,
	geo_lat DOUBLE PRECISION,
	geo_lng DOUBLE PRECISION,
	tx_nome_atividade_economica TEXT
) AS $$

DECLARE
	id_osc_search INTEGER;

BEGIN
	RETURN QUERY
		SELECT
			vw_busca_resultado.id_osc,
			vw_busca_resultado.tx_nome_osc,
			vw_busca_resultado.cd_identificador_osc,
			vw_busca_resultado.tx_natureza_juridica_osc,
			vw_busca_resultado.tx_endereco_osc,
			vw_busca_resultado.geo_lat,
			vw_busca_resultado.geo_lng,
			vw_busca_resultado.tx_nome_atividade_economica
		FROM osc.vw_busca_resultado
		WHERE vw_busca_resultado.id_osc IN (
			SELECT a.id_osc FROM portal.buscar_osc_regiao(param, limit_result, offset_result) a
		);
END;
$$ LANGUAGE 'plpgsql';