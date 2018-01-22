DROP FUNCTION IF EXISTS portal.buscar_osc(param TEXT, limit_result INTEGER, offset_result INTEGER, tipo_busca INTEGER);

CREATE OR REPLACE FUNCTION portal.buscar_osc(param TEXT, limit_result INTEGER, offset_result INTEGER, tipo_busca INTEGER) RETURNS TABLE(
	id_osc INTEGER 
) AS $$ 

DECLARE 
	param_tsquery TEXT;
	param_cnpj TEXT;
	query_limit TEXT; 
	query_where TEXT;

BEGIN 
	IF offset_result > 0 THEN 
		query_limit := 'LIMIT ' || limit_result || ' OFFSET ' || offset_result || ';'; 
	ELSIF limit_result > 0 THEN 
		query_limit := 'LIMIT ' || limit_result || ';'; 
	ELSE 
		query_limit := ';'; 
	END IF; 
	
	param := LOWER(param);
	param_tsquery := param;
	param := TRANSLATE(param, '_', ' ');
	param_cnpj := LTRIM(param, '0');
	
	/* BUSCA POR SIMILARIDADE */
	IF tipo_busca = 0 THEN 
		query_where := 'similarity(vw_busca_osc.cd_identificador_osc::TEXT, ''' || param_cnpj || ''') > 0.3 
						OR 
						(
							document @@ to_tsquery(''portuguese_unaccent'', ''' || param_tsquery || ''') 
							AND 
							(
								similarity(vw_busca_osc.tx_razao_social_osc::TEXT, ''' || param || ''') > 0.05 
								OR 
								similarity(vw_busca_osc.tx_nome_fantasia_osc::TEXT, ''' || param || ''') > 0.05 
							)
						) '; 
	/* BUSCA IDÊNTICA */
	ELSIF tipo_busca = 1 THEN 
		query_where := 'vw_busca_osc.cd_identificador_osc::TEXT = ''' || param_cnpj || ''' 
						OR 
						(
							LOWER(vw_busca_osc.tx_razao_social_osc::TEXT) = ''' || param || '''
							OR 
							LOWER(vw_busca_osc.tx_nome_fantasia_osc::TEXT) = ''' || param || '''
						) '; 
	/* BUSCA PARA AUTOCOMPLETE */
	ELSIF tipo_busca = 2 THEN 
		query_where := 'vw_busca_osc.cd_identificador_osc::TEXT ILIKE ''' || param_cnpj || ''' || ''%'' 
						OR 
						(
							LOWER(vw_busca_osc.tx_razao_social_osc::TEXT) ILIKE ''' || param || '%'' 
							OR 
							LOWER(vw_busca_osc.tx_nome_fantasia_osc::TEXT) ILIKE ''' || param || '%''
						) '; 
	ELSE 
		RETURN; 
		
	END IF; 
	
	RETURN QUERY 
		EXECUTE 
			'SELECT vw_busca_osc.id_osc 
			FROM osc.vw_busca_osc 
			WHERE ' || query_where || '
			ORDER BY GREATEST(
				similarity(vw_busca_osc.cd_identificador_osc::TEXT, ''' || param_cnpj || '''), 
				similarity(vw_busca_osc.tx_razao_social_osc::TEXT, ''' || param || '''), 
				similarity(vw_busca_osc.tx_nome_fantasia_osc::TEXT, ''' || param || ''')
			) DESC, vw_busca_osc.tx_nome_osc ASC ' || query_limit; 
END; 
$$ LANGUAGE 'plpgsql';
