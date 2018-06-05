DROP FUNCTION IF EXISTS portal.obter_osc_representante_conselho(TEXT);

CREATE OR REPLACE FUNCTION portal.obter_osc_representante_conselho(param TEXT) RETURNS TABLE (
	id_representante_conselho INTEGER, 
	id_participacao_social_conselho INTEGER, 
	tx_nome_representante_conselho TEXT, 
	ft_nome_representante_conselho TEXT
) AS $$ 
BEGIN 
	RETURN QUERY 
		SELECT
			tb_representante_conselho.id_representante_conselho,
			tb_representante_conselho.id_participacao_social_conselho,
			tb_representante_conselho.tx_nome_representante_conselho,
			tb_representante_conselho.ft_nome_representante_conselho
		FROM 
			osc.tb_representante_conselho 
		WHERE 
			tb_representante_conselho.id_participacao_social_conselho = param::INTEGER;

END;
$$ LANGUAGE 'plpgsql';

