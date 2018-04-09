DROP FUNCTION IF EXISTS portal.obter_osc_atualizadas_recentemente(INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_osc_atualizadas_recentemente(quantidade_oscs INTEGER) RETURNS TABLE(
	id_osc INTEGER, 
	tx_nome_osc TEXT
)AS $$

BEGIN 
	RETURN QUERY 
		EXECUTE '
			SELECT id_osc, tx_nome_osc 
			FROM portal.vw_log_alteracao 
			ORDER BY dt_alteracao DESC 
			LIMIT ' || quantidade_oscs;
			
END;
$$ LANGUAGE 'plpgsql';
