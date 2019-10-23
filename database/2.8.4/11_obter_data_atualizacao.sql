-- FUNCTION: portal.obter_data_atualizacao(text)

-- DROP FUNCTION portal.obter_data_atualizacao(text);

CREATE OR REPLACE FUNCTION portal.obter_data_atualizacao(
	osc text)
    RETURNS TABLE(dt_alteracao text) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$ 

BEGIN 
	RETURN QUERY 
		SELECT TO_CHAR(tb_log_alteracao.dt_alteracao, 'DD-MM-YYYY'::TEXT) 
		FROM log.tb_log_alteracao 
		--JOIN osc.tb_osc 
		--ON tb_osc.id_osc = tb_log_alteracao.id_osc 
		WHERE id_carga is null AND (tb_log_alteracao.id_osc::TEXT = osc 
		--OR tb_osc.tx_apelido_osc = osc
								   )
		order by id_log_alteracao DESC
		limit 1;

END; 
$BODY$;