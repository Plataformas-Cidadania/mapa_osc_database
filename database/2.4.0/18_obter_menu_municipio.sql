﻿DROP FUNCTION IF EXISTS portal.obter_menu_municipio(param TEXT, limit_result INTEGER, offset_result INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_menu_municipio(param TEXT, limit_result INTEGER, offset_result INTEGER) RETURNS TABLE(
	edmu_cd_municipio NUMERIC(7),
	edmu_nm_municipio CHARACTER VARYING(50),
	eduf_sg_uf CHARACTER VARYING(2)
) AS $$

DECLARE 
	query_limit TEXT; 

BEGIN	
	IF offset_result > 0 THEN 
		query_limit := 'LIMIT ' || limit_result || ' OFFSET ' || offset_result || ';'; 
	ELSIF limit_result > 0 THEN 
		query_limit := 'LIMIT ' || limit_result || ';'; 
	ELSE 
		query_limit := ';'; 
	END IF; 
	
	param := TRANSLATE(UNACCENT(LOWER(param::TEXT)), ' /_-', '');
	
	RETURN QUERY
		EXECUTE 
			'SELECT
				vw_spat_municipio.edmu_cd_municipio,
				vw_spat_municipio.edmu_nm_municipio,
				vw_spat_municipio.eduf_sg_uf
			FROM 
				spat.vw_spat_municipio
			WHERE 
				vw_spat_municipio.edmu_nm_municipio_ajustado ILIKE ''' || param::TEXT || '%'' 
			OR 
				vw_spat_municipio.edmu_nm_municipio_ajustado || vw_spat_municipio.eduf_sg_uf_ajustado ILIKE ''' || param::TEXT || '%'' 
			ORDER BY 
				similarity(vw_spat_municipio.edmu_nm_municipio_ajustado || vw_spat_municipio.eduf_sg_uf_ajustado, ''' || param::TEXT || ''') DESC ' || query_limit;
	
END;
$$ LANGUAGE 'plpgsql';
