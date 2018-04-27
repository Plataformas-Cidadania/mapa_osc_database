DROP FUNCTION IF EXISTS portal.obter_osc_participacao_social_conferencia(param TEXT);
﻿
CREATE OR REPLACE FUNCTION portal.obter_osc_participacao_social_conferencia(param TEXT) RETURNS TABLE (
	id_conferencia INTEGER, 
	cd_conferencia INTEGER, 
	tx_nome_conferencia TEXT, 
	tx_nome_conferencia_outra TEXT, 
	ft_conferencia TEXT, 
	dt_ano_realizacao TEXT, 
	ft_ano_realizacao TEXT, 
	cd_forma_participacao_conferencia INTEGER, 
	tx_nome_forma_participacao_conferencia TEXT, 
	ft_forma_participacao_conferencia TEXT
) AS $$ 
BEGIN 
	RETURN QUERY 
		SELECT
			tb_participacao_social_conferencia.id_conferencia,
			tb_participacao_social_conferencia.cd_conferencia,
			dc_conferencia.tx_nome_conferencia,
			tb_participacao_social_conferencia_outra.tx_nome_conferencia AS tx_nome_conferencia_outra,
			COALESCE(tb_participacao_social_conferencia.ft_conferencia, tb_participacao_social_conferencia_outra.ft_nome_conferencia) AS ft_conferencia,
			TO_CHAR(tb_participacao_social_conferencia.dt_ano_realizacao::TIMESTAMP WITH TIME ZONE, 'DD-MM-YYYY'::TEXT) AS dt_ano_realizacao,
			tb_participacao_social_conferencia.ft_ano_realizacao,
			tb_participacao_social_conferencia.cd_forma_participacao_conferencia,
			dc_forma_participacao_conferencia.tx_nome_forma_participacao_conferencia,
			tb_participacao_social_conferencia.ft_forma_participacao_conferencia
		FROM
			osc.tb_participacao_social_conferencia
		LEFT JOIN
			osc.tb_participacao_social_conferencia_outra
		ON
			tb_participacao_social_conferencia_outra.id_conferencia = tb_participacao_social_conferencia.id_conferencia
		LEFT JOIN
			syst.dc_conferencia
		ON
			dc_conferencia.cd_conferencia = tb_participacao_social_conferencia.cd_conferencia
		LEFT JOIN
			syst.dc_forma_participacao_conferencia
		ON
			dc_forma_participacao_conferencia.cd_forma_participacao_conferencia = tb_participacao_social_conferencia.cd_forma_participacao_conferencia
		INNER JOIN
			osc.tb_osc
		ON
			tb_osc.id_osc = tb_participacao_social_conferencia.id_osc
		WHERE 
			tb_osc.bo_osc_ativa
		AND (
			tb_osc.id_osc = param::INTEGER OR 
			tb_osc.tx_apelido_osc = param
		);

END;
$$ LANGUAGE 'plpgsql';
