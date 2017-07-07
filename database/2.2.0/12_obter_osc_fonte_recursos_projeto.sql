-- Function: portal.obter_osc_fonte_recursos_projeto(integer)

DROP FUNCTION portal.obter_osc_fonte_recursos_projeto(integer);

CREATE OR REPLACE FUNCTION portal.obter_osc_fonte_recursos_projeto(IN param integer)
  RETURNS TABLE(id_fonte_recursos_projeto integer, cd_origem_fonte_recursos_projeto integer, tx_nome_origem_fonte_recursos_projeto text, ft_fonte_recursos_projeto text, cd_tipo_parceria integer, tx_nome_tipo_parceria text) AS
$BODY$
BEGIN 
	RETURN QUERY 
		SELECT 
			vw_osc_fonte_recursos_projeto.id_fonte_recursos_projeto, 
			vw_osc_fonte_recursos_projeto.cd_origem_fonte_recursos_projeto, 
			vw_osc_fonte_recursos_projeto.tx_nome_origem_fonte_recursos_projeto, 
			vw_osc_fonte_recursos_projeto.ft_fonte_recursos_projeto,
			vw_osc_fonte_recursos_projeto.cd_tipo_parceria,
			vw_osc_fonte_recursos_projeto.tx_nome_tipo_parceria
		FROM 
			portal.vw_osc_fonte_recursos_projeto 
		WHERE 
			vw_osc_fonte_recursos_projeto.id_projeto = param;
	RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION portal.obter_osc_fonte_recursos_projeto(integer)
  OWNER TO postgres;
