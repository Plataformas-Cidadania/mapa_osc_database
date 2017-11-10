-- Function: portal.obter_atividade_economica(text, integer, integer)

DROP FUNCTION portal.obter_atividade_economica(text, integer, integer);

CREATE OR REPLACE FUNCTION portal.obter_atividade_economica(IN param text, IN limit_result integer, IN offset_result integer)
  RETURNS TABLE(tx_atividade_economica text ) AS
$BODY$

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
	
	param := TRANSLATE(UNACCENT(param::TEXT), ' /_-', '');
	
	RETURN QUERY
		EXECUTE 
			'SELECT
				tx_nome_subclasse_atividade_economica
			FROM 
				syst.dc_subclasse_atividade_economica
			WHERE 
				UNACCENT(tx_nome_subclasse_atividade_economica) ILIKE ''' || param::TEXT || '%'' 
			ORDER BY 
				similarity(tx_nome_subclasse_atividade_economica, ''' || param::TEXT || ''') DESC ' || query_limit;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION portal.obter_atividade_economica(text, integer, integer)
  OWNER TO postgres;
