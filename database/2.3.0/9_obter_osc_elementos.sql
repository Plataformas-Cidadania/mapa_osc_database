-- Function: portal.obter_osc_elementos(text)

-- DROP FUNCTION portal.obter_osc_elementos(text);

CREATE OR REPLACE FUNCTION portal.obter_osc_elementos(IN param text)
  RETURNS TABLE(id_osc integer, bo_participacao_social_conselho boolean, ft_participacao_social_conselho text, bo_participacao_social_conferencia boolean, ft_participacao_social_conferencia text, bo_participacao_social_outro boolean, ft_participacao_social_outro text, bo_recurso boolean, ft_recurso text, bo_certificado boolean, ft_certificado text) AS
$BODY$ 
BEGIN 
	RETURN QUERY 
		SELECT 
			vw_osc_elementos.id_osc,
			vw_osc_elementos.bo_participacao_social_conselho,
			vw_osc_elementos.ft_participacao_social_conselho,
			vw_osc_elementos.bo_participacao_social_conferencia,
			vw_osc_elementos.ft_participacao_social_conferencia,
			vw_osc_elementos.bo_participacao_social_outro,
			vw_osc_elementos.ft_participacao_social_outro,
			vw_osc_elementos.bo_recurso,
			vw_osc_elementos.ft_recurso,
			vw_osc_elementos.bo_certificado,
			vw_osc_elementos.ft_certificado
		FROM 
			portal.vw_osc_elementos
		WHERE 
			vw_osc_elementos.id_osc::TEXT = param OR 
			vw_osc_elementos.tx_apelido_osc = param;
	RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION portal.obter_osc_elementos(text)
  OWNER TO postgres;
