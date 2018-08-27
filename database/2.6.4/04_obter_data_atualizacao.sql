DROP FUNCTION IF EXISTS portal.obter_data_atualizacao(TEXT);

CREATE OR REPLACE FUNCTION portal.obter_data_atualizacao(osc TEXT) RETURNS TABLE(
	dt_alteracao TEXT
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT TO_CHAR(MAX(tb_log_alteracao.dt_alteracao), 'DD-MM-YYYY'::TEXT) 
		FROM log.tb_log_alteracao 
		LEFT JOIN osc.tb_osc 
		ON tb_osc.id_osc = tb_log_alteracao.id_osc 
		WHERE tb_log_alteracao.id_osc::TEXT = osc 
		OR tb_osc.tx_apelido_osc = osc;

END; 
$$ LANGUAGE 'plpgsql';
