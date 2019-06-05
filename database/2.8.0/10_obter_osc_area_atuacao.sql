DROP FUNCTION IF EXISTS portal.obter_osc_area_atuacao2(TEXT);

CREATE OR REPLACE FUNCTION portal.obter_osc_area_atuacao2(param TEXT) RETURNS TABLE (
	resultado JSONB,
	mensagem TEXT,
	flag BOOLEAN
) AS $$

DECLARE
	linha RECORD;
	osc RECORD;

BEGIN
	resultado := null;

	SELECT INTO osc * FROM osc.tb_osc WHERE (id_osc = param::INTEGER OR tx_apelido_osc = param) AND bo_osc_ativa;

	IF osc.id_osc IS NOT null THEN
		SELECT INTO linha
			tb_osc.id_osc,
			tb_osc.tx_apelido_osc,
			tb_area_atuacao.cd_area_atuacao,
			tx_nome_area_atuacao AS tx_nome_area_atuacao,
			tb_area_atuacao.tx_nome_outra AS tx_nome_area_atuacao_outra,
			tb_area_atuacao.cd_subarea_atuacao,
			tx_nome_subarea_atuacao AS tx_nome_subarea_atuacao,
			tb_area_atuacao.tx_nome_outra AS tx_nome_subarea_atuacao_outra,
			tb_area_atuacao.ft_area_atuacao,
			tb_area_atuacao.bo_oficial
		FROM osc.tb_osc
		LEFT JOIN osc.tb_area_atuacao
		ON tb_osc.id_osc = tb_area_atuacao.id_osc
		LEFT JOIN syst.dc_area_atuacao
		ON syst.dc_area_atuacao.cd_area_atuacao = osc.tb_area_atuacao.cd_area_atuacao
		LEFT JOIN syst.dc_subarea_atuacao
		ON syst.dc_subarea_atuacao.cd_subarea_atuacao = osc.tb_area_atuacao.cd_subarea_atuacao
		WHERE tb_osc.id_osc = osc.id_osc;

		IF linha != (null::INTEGER, null::TEXT, null::TEXT)::RECORD THEN
			resultado := to_jsonb(linha);
		END IF;

		flag := true;
		mensagem := 'Área de atuação retornado.';

	ELSE 
		flag := false;
		mensagem := 'OSC não encontrada.';
	END IF;

	RETURN NEXT;

EXCEPTION
	WHEN others THEN 
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;
$$ LANGUAGE 'plpgsql';