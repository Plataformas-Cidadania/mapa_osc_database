DROP FUNCTION IF EXISTS portal.buscar_osc(param TEXT, limit_result INTEGER, offset_result INTEGER, tipo_busca INTEGER);

CREATE OR REPLACE FUNCTION portal.buscar_osc(param TEXT, limit_result INTEGER, offset_result INTEGER, tipo_busca INTEGER) RETURNS TABLE(
	id_osc INTEGER 
) AS $$ 

DECLARE 
	query_limit TEXT; 
	query_where TEXT;

BEGIN 
	param := LOWER(param);
	
	IF offset_result > 0 THEN 
		query_limit := 'LIMIT ' || limit_result || ' OFFSET ' || offset_result || ';'; 
	ELSIF limit_result > 0 THEN 
		query_limit := 'LIMIT ' || limit_result || ';'; 
	ELSE 
		query_limit := ';'; 
	END IF; 
	
	/* BUSCA POR SIMILARIDADE */
	IF tipo_busca = 0 THEN 
		query_where := 'vw_busca_osc.cd_identificador_osc::TEXT ILIKE ''%'' || LTRIM(''' || param::TEXT || ''', ''0'') || ''%'' 
						OR 
						(
							document @@ to_tsquery(''portuguese_unaccent'', ''' || param::TEXT || ''') 
							AND 
							(
								similarity(vw_busca_osc.tx_razao_social_osc::TEXT, ''' || param::TEXT || ''') > 0.05 
								OR 
								similarity(vw_busca_osc.tx_nome_fantasia_osc::TEXT, ''' || param::TEXT || ''') > 0.05 
							)
						) '; 
	/* BUSCA IDÊNTICA */
	ELSIF tipo_busca = 1 THEN 
		query_where := 'vw_busca_osc.cd_identificador_osc::TEXT = LTRIM(''' || param::TEXT || ''', ''0'') 
						OR 
						(
							LOWER(vw_busca_osc.tx_razao_social_osc::TEXT) = ''' || param::TEXT || '''
							OR 
							LOWER(vw_busca_osc.tx_nome_fantasia_osc::TEXT) = ''' || param::TEXT || '''
						) '; 
	/* BUSCA PARA AUTOCOMPLETE */
	ELSIF tipo_busca = 2 THEN 
		query_where := 'vw_busca_osc.cd_identificador_osc::TEXT ILIKE LTRIM(''' || param::TEXT || ''', ''0'') || ''%'' 
						OR 
						(
							LOWER(vw_busca_osc.tx_razao_social_osc::TEXT) ILIKE ''' || param::TEXT || '%'' 
							OR 
							LOWER(vw_busca_osc.tx_nome_fantasia_osc::TEXT) ILIKE ''' || param::TEXT || '%''
						) '; 
	END IF; 
	
	RAISE NOTICE '%', 
		'SELECT vw_busca_osc.id_osc 
		FROM osc.vw_busca_osc 
		WHERE ' || query_where || '
		ORDER BY GREATEST(
			similarity(vw_busca_osc.cd_identificador_osc::TEXT, LTRIM(''' || param::TEXT || ''', ''0'')), 
			similarity(vw_busca_osc.tx_razao_social_osc::TEXT, ''' || param::TEXT || '''), 
			similarity(vw_busca_osc.tx_nome_fantasia_osc::TEXT, ''' || param::TEXT || ''')
		) DESC, vw_busca_osc.id_osc ASC ' || query_limit;
	
	RETURN QUERY 
		EXECUTE 
			'SELECT vw_busca_osc.id_osc 
			FROM osc.vw_busca_osc 
			WHERE ' || query_where || '
			ORDER BY GREATEST(
				similarity(vw_busca_osc.cd_identificador_osc::TEXT, LTRIM(''' || param::TEXT || ''', ''0'')), 
				similarity(vw_busca_osc.tx_razao_social_osc::TEXT, ''' || param::TEXT || '''), 
				similarity(vw_busca_osc.tx_nome_fantasia_osc::TEXT, ''' || param::TEXT || ''')
			) DESC, vw_busca_osc.id_osc ASC ' || query_limit; 
END; 
$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.buscar_osc('cieds', 10, 0, 0);
