-- Function: portal.obter_osc_fonte_recursos_projeto(integer)
DROP FUNCTION portal.obter_osc_fonte_recursos_projeto(integer);

CREATE OR REPLACE FUNCTION portal.obter_osc_fonte_recursos_projeto(param integer) RETURNS TABLE(
	id_fonte_recursos_projeto integer, 
	cd_origem_fonte_recursos_projeto integer, 
	tx_nome_origem_fonte_recursos_projeto text, 
	ft_fonte_recursos_projeto text
) AS $$
BEGIN 
	RETURN QUERY 
		SELECT 
			vw_osc_fonte_recursos_projeto.id_fonte_recursos_projeto, 
			vw_osc_fonte_recursos_projeto.cd_origem_fonte_recursos_projeto, 
			vw_osc_fonte_recursos_projeto.tx_nome_origem_fonte_recursos_projeto, 
			vw_osc_fonte_recursos_projeto.ft_fonte_recursos_projeto
		FROM 
			portal.vw_osc_fonte_recursos_projeto 
		WHERE 
			vw_osc_fonte_recursos_projeto.id_projeto = param;
	RETURN;
END;
$$ LANGUAGE 'plpgsql';
