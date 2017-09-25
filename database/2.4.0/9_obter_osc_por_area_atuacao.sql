DROP FUNCTION IF EXISTS portal.obter_osc_por_area_atuacao(area_atuacao INTEGER, geolocalizacao DOUBLE PRECISION[], municipio INTEGER, quantidade_oscs INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_osc_por_area_atuacao(area_atuacao INTEGER, geolocalizacao DOUBLE PRECISION[], municipio INTEGER, quantidade_oscs INTEGER) RETURNS TABLE(
	id_osc INTEGER, 
	tx_nome_osc TEXT
)AS $$

DECLARE 
	join_municipio TEXT;
	query_order TEXT;
	where_municipio TEXT;
	query_limit TEXT;
	
BEGIN
	RAISE NOTICE 'Geolocalização: %', geolocalizacao[1];
	RAISE NOTICE 'Município: %', municipio;
	RAISE NOTICE 'Quantidade de OSCs: %', quantidade_oscs;
	
	IF array_length(geolocalizacao, 1) = 2 THEN 
		join_municipio := ' INNER JOIN osc.vw_geo_osc ON vw_geo_osc.id_osc = vw_osc_area_atuacao.id_osc ';
		query_order := ' ST_Distance(
			ST_GeomFromText(''POINT(vw_geo_osc.geo_lng vw_geo_osc.geo_lat)'', 4326),
			ST_GeomFromText(''POINT(' || geolocalizacao[2] || ' ' || geolocalizacao[1] || ')'', 4326)
		) '; 
	ELSE 
		join_municipio := ' '; 
		query_order := ' RANDOM() '; 
	END IF; 
	
	IF municipio > 0 THEN 
		join_municipio := ' INNER JOIN osc.vw_geo_osc ON vw_geo_osc.id_osc = vw_osc_area_atuacao.id_osc ';
		where_municipio := ' AND vw_geo_osc.cd_municipio = ' || municipio || ' '; 
	ELSE 
		join_municipio := ' '; 
		where_municipio := ' '; 
	END IF; 
	
	IF quantidade_oscs > 0 THEN 
		query_limit := ' LIMIT ' || quantidade_oscs || ';'; 
	ELSE 
		query_limit := ';'; 
	END IF; 
	
	RETURN QUERY 
		EXECUTE 
			'SELECT vw_osc_area_atuacao.id_osc, vw_busca_resultado.tx_nome_osc 
			FROM portal.vw_osc_area_atuacao 
			INNER JOIN osc.vw_busca_resultado ON vw_osc_area_atuacao.id_osc = vw_busca_resultado.id_osc' || 
			join_municipio || '
			WHERE vw_osc_area_atuacao.cd_area_atuacao = ' || area_atuacao || where_municipio || '
			GROUP BY vw_osc_area_atuacao.id_osc, vw_busca_resultado.tx_nome_osc 
			ORDER BY' || query_order || query_limit;
	
END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_osc_por_area_atuacao(2, '{123456.5, 987654.1}', 0, 5);
