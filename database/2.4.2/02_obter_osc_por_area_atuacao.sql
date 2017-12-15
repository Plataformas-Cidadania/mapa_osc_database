DROP FUNCTION IF EXISTS portal.obter_osc_por_area_atuacao(area_atuacao INTEGER, geolocalizacao DOUBLE PRECISION[], municipio INTEGER, quantidade_oscs INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_osc_por_area_atuacao(area_atuacao INTEGER, geolocalizacao DOUBLE PRECISION[], municipio INTEGER, quantidade_oscs INTEGER) RETURNS TABLE(
	id_osc INTEGER, 
	tx_nome_osc TEXT
)AS $$

DECLARE 
	query_join TEXT;
	query_order TEXT;
	where_municipio TEXT;
	query_group TEXT;
	query_limit TEXT;
	
BEGIN 
	query_join := ' ';
	query_order := ' RANDOM() ';
	where_municipio := ' ';
	query_limit := ';';
	query_group := ' ';
	
	IF array_length(geolocalizacao, 1) = 2 THEN 
		query_join := ' INNER JOIN osc.vw_geo_osc ON vw_geo_osc.id_osc = vw_osc_area_atuacao.id_osc ';
		query_order := ' ST_Distance(
			ST_GeomFromText(''POINT('' || vw_geo_osc.geo_lng || '' '' || vw_geo_osc.geo_lat || '')'', 4674),
			ST_GeomFromText(''POINT(' || geolocalizacao[2] || ' ' || geolocalizacao[1] || ')'', 4674)
		) '; 
		query_group := ', vw_busca_resultado.tx_nome_osc,  vw_geo_osc.geo_lng, vw_geo_osc.geo_lat ';
	END IF; 
	
	IF municipio > 0 THEN 
		query_join := ' INNER JOIN osc.vw_geo_osc ON vw_geo_osc.id_osc = vw_osc_area_atuacao.id_osc ';
		where_municipio := ' AND vw_geo_osc.cd_municipio = ' || municipio || ' '; 
	END IF; 
	
	IF quantidade_oscs > 0 THEN 
		query_limit := ' LIMIT ' || quantidade_oscs || ';'; 
	END IF; 
	
	RETURN QUERY 
		EXECUTE 
			'SELECT vw_osc_area_atuacao.id_osc, vw_busca_resultado.tx_nome_osc 
			FROM portal.vw_osc_area_atuacao 
			INNER JOIN osc.vw_busca_resultado ON vw_osc_area_atuacao.id_osc = vw_busca_resultado.id_osc' || 
			query_join || '
			AND vw_osc_area_atuacao.id_osc <> 789809 
			WHERE vw_osc_area_atuacao.cd_area_atuacao = ' || area_atuacao || where_municipio || '
			GROUP BY vw_osc_area_atuacao.id_osc, vw_busca_resultado.tx_nome_osc' || query_group || '
			ORDER BY' || query_order || query_limit;
	
END;
$$ LANGUAGE 'plpgsql';
