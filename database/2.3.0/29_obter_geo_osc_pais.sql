DROP FUNCTION IF EXISTS portal.obter_geolocalizacao_oscs();

CREATE OR REPLACE FUNCTION portal.obter_geolocalizacao_oscs() RETURNS TABLE (
	id_osc INTEGER,
	geo_lat DOUBLE PRECISION,
	geo_lng DOUBLE PRECISION
) AS $$

BEGIN
	RETURN QUERY
		SELECT
			vw_geo_osc.id_osc,
			vw_geo_osc.geo_lat,
			vw_geo_osc.geo_lng
		FROM 
			osc.vw_geo_osc
		WHERE 
			vw_geo_osc.geo_lat IS NOT NULL AND 
			vw_geo_osc.geo_lng IS NOT NULL;
	
END;
$$ LANGUAGE 'plpgsql';
