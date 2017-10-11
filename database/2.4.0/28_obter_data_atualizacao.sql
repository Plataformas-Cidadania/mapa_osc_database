DROP FUNCTION IF EXISTS portal.obter_data_atualizacao(param TEXT);

CREATE OR REPLACE FUNCTION portal.obter_data_atualizacao(param TEXT) RETURNS TABLE(
	dt_alteracao TEXT
) AS $$ 

DECLARE 
	idosc INTEGER;

BEGIN 
	SELECT INTO idosc
		vw_osc_dados_gerais.id_osc 
	FROM 
		portal.vw_osc_dados_gerais 
	WHERE 
		vw_osc_dados_gerais.id_osc::TEXT = param 
	OR 
		vw_osc_dados_gerais.tx_apelido_osc = param;
	
	RETURN QUERY 
		SELECT 
			to_char(max(tb_log_alteracao.dt_alteracao), 'DD-MM-YYYY')::TEXT AS dt_alteracao 
		FROM 
			log.tb_log_alteracao 
		WHERE 
			tb_log_alteracao.id_osc = idosc;

END; 
$$ LANGUAGE 'plpgsql';
