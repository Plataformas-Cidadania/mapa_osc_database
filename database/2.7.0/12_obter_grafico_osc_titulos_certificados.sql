DROP FUNCTION IF EXISTS portal.obter_grafico_osc_titulos_certificados() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_osc_titulos_certificados() RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('{"label": "' || a.rotulo::TEXT || '", "value": ' || a.valor::TEXT || '}')::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), ',,', ','), '{'), '}') || '}]')::JSONB AS dados, 
			('{' || TRIM(REPLACE(TRANSLATE((
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) 
				FROM (
					SELECT DISTINCT UNNEST( 
						('{' || TRIM(REPLACE(TRANSLATE(ARRAY_AGG(a.fontes)::TEXT, '\"', ''), ',,', ','), ',{}') || '}')::TEXT[] 
					)
				) AS a
			)::TEXT, '\"', ''), ',,', ','), ',{}') || '}')::TEXT[] AS fontes
		FROM (
			SELECT 
				CASE 
					WHEN dc_certificado.tx_nome_certificado = 'Entidade Ambientalista' THEN 'Entidade Ambientalista/MMA' 
					WHEN dc_certificado.tx_nome_certificado = 'CEBAS - Educação' THEN 'CEBAS/MEC' 
					WHEN dc_certificado.tx_nome_certificado = 'CEBAS - Saúde' THEN 'CEBAS/MS' 
					WHEN dc_certificado.tx_nome_certificado = 'OSCIP' THEN 'OSCIP/MJ' 
					WHEN dc_certificado.tx_nome_certificado = 'Utilidade Pública Federal' THEN 'UPF/MJ' 
					WHEN dc_certificado.tx_nome_certificado = 'CEBAS - Assistência Social' THEN 'CEBAS/MDS' 
					ELSE dc_certificado.tx_nome_certificado
				END AS rotulo, 
				COUNT(*) AS valor, 
				(
					TRIM(ARRAY_AGG(DISTINCT TRIM(tb_certificado.ft_certificado)) FILTER (WHERE (TRIM(tb_certificado.ft_certificado) = '') IS false)::TEXT, '{}') || ',' || 
					TRIM(ARRAY_AGG(DISTINCT TRIM(tb_osc.ft_identificador_osc)) FILTER (WHERE (TRIM(tb_osc.ft_identificador_osc) = '') IS false)::TEXT, '{}')
				) AS fontes 
			FROM osc.tb_osc 
			LEFT JOIN osc.tb_certificado 
			ON tb_osc.id_osc = tb_certificado.id_osc 
			LEFT JOIN syst.dc_certificado 
			ON tb_certificado.cd_certificado = dc_certificado.cd_certificado 
			WHERE tb_osc.bo_osc_ativa 
			AND dc_certificado.tx_nome_certificado IS NOT null 
			AND tb_osc.id_osc <> 789809 
			GROUP BY rotulo
		) AS a;
END;

$$ LANGUAGE 'plpgsql';
