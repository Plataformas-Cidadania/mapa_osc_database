DROP FUNCTION IF EXISTS portal.obter_participacao_social_conferencia(param TEXT);
﻿
CREATE OR REPLACE FUNCTION portal.obter_participacao_social_conferencia(param TEXT) RETURNS TABLE (
	id_conselho INTEGER, 
	cd_conselho INTEGER, 
	tx_nome_conselho TEXT, 
	tx_nome_conselho_outro TEXT, 
	ft_conselho TEXT, 
	cd_tipo_participacao INTEGER, 
	tx_nome_tipo_participacao TEXT, 
	ft_tipo_participacao TEXT, 
	cd_periodicidade_reuniao_conselho INTEGER, 
	tx_periodicidade_reuniao TEXT, 
	ft_periodicidade_reuniao TEXT, 
	dt_data_inicio_conselho TEXT, 
	ft_data_inicio_conselho TEXT, 
	dt_data_fim_conselho TEXT, 
	ft_data_fim_conselho TEXT
) AS $$ 
BEGIN 
	RETURN QUERY 
		SELECT
			id_conferencia,
			cd_conferencia,
			tx_nome_conferencia,
			null AS tx_nome_conferencia_outro,
			ft_conferencia,
			dt_ano_realizacao,
			ft_ano_realizacao,
			cd_forma_participacao_conferencia,
			tx_nome_forma_participacao_conferencia,
			ft_forma_participacao_conferencia
		FROM
			portal.vw_osc_participacao_social_conferencia
		WHERE
			id_osc::TEXT = ?::TEXT AND cd_conferencia <> 132
    		OR
    			tx_apelido_osc = ?::TEXT
		UNION
		SELECT
			id_conferencia_outra AS id_conferencia,
			132 AS cd_conferencia,
			'Outra Conferência' AS tx_nome_conferencia,
			tx_nome_conferencia AS tx_nome_conferencia_outro,
			ft_nome_conferencia AS ft_conferencia,
			dt_ano_realizacao,
			ft_ano_realizacao,
			cd_forma_participacao_conferencia,
			tx_nome_forma_participacao_conferencia,
			ft_forma_participacao_conferencia
		FROM
			portal.vw_osc_participacao_social_conferencia_outra
		WHERE
			id_osc::TEXT = ?::TEXT
    		OR
    			tx_apelido_osc = ?::TEXT;

	RETURN QUERY 
		SELECT
			tb_participacao_social_conselho.id_conselho,
			tb_participacao_social_conselho.cd_conselho,
			dc_conselho.tx_nome_conselho,
			tb_participacao_social_conselho_outro.tx_nome_conselho AS tx_nome_conselho_outro,
			tb_participacao_social_conselho.ft_conselho,
			tb_participacao_social_conselho.cd_tipo_participacao,
			dc_tipo_participacao.tx_nome_tipo_participacao::TEXT,
			tb_participacao_social_conselho.ft_tipo_participacao,
			tb_participacao_social_conselho.cd_periodicidade_reuniao_conselho,
			dc_periodicidade_reuniao_conselho.tx_nome_periodicidade_reuniao_conselho,
			tb_participacao_social_conselho.ft_periodicidade_reuniao,
			TO_CHAR(tb_participacao_social_conselho.dt_data_inicio_conselho::TIMESTAMP WITH TIME ZONE, 'DD-MM-YYYY'::TEXT) AS dt_data_inicio_conselho,
			tb_participacao_social_conselho.ft_data_inicio_conselho,
			TO_CHAR(tb_participacao_social_conselho.dt_data_fim_conselho::TIMESTAMP WITH TIME ZONE, 'DD-MM-YYYY'::TEXT) AS dt_data_fim_conselho,
			tb_participacao_social_conselho.ft_data_fim_conselho
		FROM
			osc.tb_participacao_social_conselho
		LEFT JOIN
			osc.tb_participacao_social_conselho_outro
		ON
			tb_participacao_social_conselho.id_conselho = tb_participacao_social_conselho_outro.id_conselho
		LEFT JOIN
			syst.dc_conselho
		ON
			tb_participacao_social_conselho.cd_conselho = dc_conselho.cd_conselho
		LEFT JOIN
			syst.dc_tipo_participacao
		ON
			tb_participacao_social_conselho.cd_tipo_participacao = dc_tipo_participacao.cd_tipo_participacao
		LEFT JOIN
			syst.dc_periodicidade_reuniao_conselho
		ON
			tb_participacao_social_conselho.cd_periodicidade_reuniao_conselho = dc_periodicidade_reuniao_conselho.cd_periodicidade_reuniao_conselho
		INNER JOIN
			osc.tb_osc
		ON
			tb_osc.id_osc = tb_participacao_social_conselho.id_osc
		WHERE 
			tb_osc.bo_osc_ativa
		AND (
			tb_osc.id_osc = param::INTEGER OR 
			tb_osc.tx_apelido_osc = param
		);

END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM obter_participacao_social_conferencia('789809');

