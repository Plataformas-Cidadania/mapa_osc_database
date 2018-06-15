DROP FUNCTION IF EXISTS portal.obter_atividade_economica(param TEXT, limit_result INTEGER, offset_result INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_atividade_economica(param TEXT, limit_result INTEGER, offset_result INTEGER) RETURNS TABLE(
	cd_classe_atividade_economica TEXT, 
	tx_atividade_economica TEXT
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
	
	param := TRANSLATE(UNACCENT(LOWER(param::TEXT)), '_', ' ');
	
	RETURN QUERY
		EXECUTE 
			'SELECT 
				cd_classe_atividade_economica::TEXT, 
				tx_nome_classe_atividade_economica
			FROM 
				syst.dc_classe_atividade_economica
			WHERE 
				UNACCENT(tx_nome_classe_atividade_economica) ILIKE ''' || param::TEXT || '%'' 
			ORDER BY 
				similarity(tx_nome_classe_atividade_economica, ''' || param::TEXT || ''') DESC ' || query_limit;
	
END;
$$ LANGUAGE 'plpgsql';
