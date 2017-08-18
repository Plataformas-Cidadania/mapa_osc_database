-- Function: portal.obter_osc_participacao_social_outra(text)

DROP FUNCTION portal.obter_osc_participacao_social_outra(text);

CREATE OR REPLACE FUNCTION portal.obter_osc_participacao_social_outra(IN param text)
  RETURNS TABLE(id_participacao_social_outra integer, tx_nome_participacao_social_outra text, ft_participacao_social_outra text, bo_nao_possui boolean) AS
$BODY$ 
BEGIN 
	RETURN QUERY 
		SELECT 
			vw_osc_participacao_social_outra.id_participacao_social_outra, 
			vw_osc_participacao_social_outra.tx_nome_participacao_social_outra, 
			vw_osc_participacao_social_outra.ft_participacao_social_outra,
			vw_osc_participacao_social_outra.bo_nao_possui 
		FROM
			portal.vw_osc_participacao_social_outra 
		WHERE 
			vw_osc_participacao_social_outra.id_osc::TEXT = param OR 
			vw_osc_participacao_social_outra.tx_apelido_osc = param;
	RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION portal.obter_osc_participacao_social_outra(text)
  OWNER TO postgres;
