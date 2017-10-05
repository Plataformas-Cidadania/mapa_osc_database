DROP FUNCTION IF EXISTS portal.buscar_nome_localidade(tipo_regio TEXT, latitude DOUBLE PRECISION, longitude DOUBLE PRECISION);

CREATE OR REPLACE FUNCTION portal.buscar_nome_localidade(tipo_regio TEXT, latitude DOUBLE PRECISION, longitude DOUBLE PRECISION) RETURNS TABLE(
	cd_localidade INTEGER, 
	tx_nome_localidade TEXT
) AS $$ 

DECLARE 
	query TEXT; 

BEGIN 
	IF tipo_regio = 'regiao' THEN 
		query := 'SELECT edre_cd_regiao::INTEGER, edre_nm_regiao::TEXT FROM spat.ed_regiao WHERE ST_Contains(edre_geometry, ST_GeometryFromText(''POINT(' || longitude::TEXT || ' ' || latitude::TEXT || ')'', 4674));'; 
	ELSIF tipo_regio = 'estado' THEN 
		query := 'SELECT eduf_cd_uf::INTEGER, eduf_nm_uf::TEXT FROM spat.ed_uf WHERE ST_Contains(eduf_geometry, ST_GeometryFromText(''POINT(' || longitude::TEXT || ' ' || latitude::TEXT || ')'', 4674));'; 
	ELSIF tipo_regio = 'municipio' THEN 
		query := 'SELECT edmu_cd_municipio::INTEGER, edmu_nm_municipio || '' - '' || eduf_sg_uf::TEXT FROM spat.ed_municipio INNER JOIN spat.ed_uf ON ed_municipio.eduf_cd_uf = ed_uf.eduf_cd_uf WHERE ST_Contains(edmu_geometry, ST_GeometryFromText(''POINT(' || longitude::TEXT || ' ' || latitude::TEXT || ')'', 4674));'; 
	END IF; 
	
	RAISE NOTICE '%', query;
	
	RETURN QUERY 
		EXECUTE query; 

END; 
$$ LANGUAGE 'plpgsql';
