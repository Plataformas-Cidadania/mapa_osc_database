﻿DROP FUNCTION IF EXISTS portal.obter_osc_participacao_social_conferencia_outra(param TEXT);

CREATE OR REPLACE FUNCTION portal.obter_osc_participacao_social_conferencia_outra(param TEXT) RETURNS TABLE (
	id_conferencia_outra INTEGER,
	tx_nome_conferencia TEXT, 
	ft_nome_conferencia TEXT
) AS $$ 
BEGIN 
	RETURN QUERY 
		SELECT 
			vw_osc_participacao_social_conferencia_outra.id_conferencia_outra,
			vw_osc_participacao_social_conferencia_outra.tx_nome_conferencia, 
			vw_osc_participacao_social_conferencia_outra.ft_nome_conferencia
		FROM 
			portal.vw_osc_participacao_social_conferencia_outra 
		WHERE 
			vw_osc_participacao_social_conferencia_outra.id_osc::TEXT = param OR 
			vw_osc_participacao_social_conferencia_outra.tx_apelido_osc = param;
	RETURN;
END;
$$ LANGUAGE 'plpgsql';
