DROP FUNCTION IF EXISTS portal.obter_data_atualizacao(TEXT);

CREATE OR REPLACE FUNCTION portal.obter_data_atualizacao(param TEXT) RETURNS TABLE(
	dt_alteracao TEXT
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT TO_CHAR(MAX(tb_log_alteracao.dt_alteracao), 'DD-MM-YYYY'::text) 
		FROM log.tb_log_alteracao 
		LEFT JOIN osc.tb_osc 
		ON tb_osc.id_osc = tb_log_alteracao.id_osc 
		WHERE tb_log_alteracao.id_osc = param::INTEGER 
		OR tb_osc.tx_apelido_osc = param;

END; 
$$ LANGUAGE 'plpgsql';
