-- Function: portal.obter_osc_recursos_osc(text)

DROP FUNCTION portal.obter_osc_recursos_osc(text);

CREATE OR REPLACE FUNCTION portal.obter_osc_recursos_osc(IN param text)
  RETURNS TABLE(id_recursos_osc integer, cd_fonte_recursos_osc integer, tx_nome_origem_fonte_recursos_osc text, tx_nome_fonte_recursos_osc text, ft_fonte_recursos_osc text, dt_ano_recursos_osc text, ft_ano_recursos_osc text, nr_valor_recursos_osc double precision, ft_valor_recursos_osc text, bo_nao_possui boolean) AS
$BODY$ 
BEGIN 
	RETURN QUERY 
		SELECT
			vw_osc_recursos_osc.id_recursos_osc, 
			vw_osc_recursos_osc.cd_fonte_recursos_osc, 
			vw_osc_recursos_osc.tx_nome_origem_fonte_recursos_osc, 
			vw_osc_recursos_osc.tx_nome_fonte_recursos_osc, 
			vw_osc_recursos_osc.ft_fonte_recursos_osc, 
			vw_osc_recursos_osc.dt_ano_recursos_osc, 
			vw_osc_recursos_osc.ft_ano_recursos_osc, 
			vw_osc_recursos_osc.nr_valor_recursos_osc, 
			vw_osc_recursos_osc.ft_valor_recursos_osc ,
			vw_osc_recursos_osc.bo_nao_possui
		FROM 
			portal.vw_osc_recursos_osc 
		WHERE 
			vw_osc_recursos_osc.id_osc::TEXT = param OR 
			vw_osc_recursos_osc.tx_apelido_osc = param;
	RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION portal.obter_osc_recursos_osc(text)
  OWNER TO postgres;
