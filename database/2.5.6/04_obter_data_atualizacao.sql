DROP FUNCTION IF EXISTS portal.obter_data_atualizacao(TEXT);
DROP FUNCTION IF EXISTS portal.obter_data_atualizacao(INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_data_atualizacao(id INTEGER) RETURNS TABLE(
	dt_alteracao TEXT
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			TO_CHAR(vw_log_alteracao.dt_alteracao, 'DD-MM-YYYY')::TEXT AS dt_alteracao 
		FROM 
			portal.vw_log_alteracao 
		WHERE 
			vw_log_alteracao.id_osc = id;

END; 
$$ LANGUAGE 'plpgsql';
