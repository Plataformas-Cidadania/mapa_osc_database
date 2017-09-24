DROP FUNCTION IF EXISTS portal.obter_osc_atualizadas_recentemente();

CREATE OR REPLACE FUNCTION portal.obter_osc_atualizadas_recentemente() RETURNS TABLE(
	id_osc INTEGER
)AS $$

BEGIN 
	RETURN QUERY 
		SELECT id_osc FROM log.tb_log_alteracao ORDER BY dt_alteracao DESC LIMIT 10;
	
END;
$$ LANGUAGE 'plpgsql';
