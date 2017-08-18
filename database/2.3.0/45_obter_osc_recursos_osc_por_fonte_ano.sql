DROP FUNCTION IF EXISTS portal.obter_osc_recursos_osc_por_fonte_ano(integer, text, text);

CREATE OR REPLACE FUNCTION portal.obter_osc_recursos_osc_por_fonte_ano(fonte_param integer, ano_param text, osc_param text) RETURNS TABLE(
	cd_fonte_recursos_osc integer, 
	id_recursos_osc integer, 
	nr_valor_recursos_osc double precision, 
	ft_valor_recursos_osc text, bo_nao_possui boolean
) AS

$BODY$ 
BEGIN 
	RETURN QUERY 
		SELECT 
			vw_osc_recursos_osc.cd_fonte_recursos_osc, 
			vw_osc_recursos_osc.id_recursos_osc, 
			vw_osc_recursos_osc.nr_valor_recursos_osc, 
			vw_osc_recursos_osc.ft_valor_recursos_osc,
			vw_osc_recursos_osc.bo_nao_possui 
		FROM 
			portal.vw_osc_recursos_osc 
		WHERE 
			vw_osc_recursos_osc.cd_fonte_recursos_osc = fonte_param AND 
			vw_osc_recursos_osc.dt_ano_recursos_osc = ano_param AND 
			(vw_osc_recursos_osc.id_osc::TEXT = osc_param OR vw_osc_recursos_osc.tx_apelido_osc = osc_param);
	RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION portal.obter_osc_recursos_osc_por_fonte_ano(integer, text, text)
  OWNER TO postgres;
