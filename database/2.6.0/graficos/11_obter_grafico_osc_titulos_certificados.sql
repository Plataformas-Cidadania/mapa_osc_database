DROP FUNCTION IF EXISTS portal.obter_grafico_osc_titulos_certificados() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_osc_titulos_certificados() RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('{"rotulo": "' || a.rotulo::TEXT || '", "valor": ' || a.valor::TEXT || '}')::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '{'), '}') || '}]')::JSONB AS dados, 
			REPLACE(REPLACE(REPLACE(TRANSLATE((ARRAY_AGG(DISTINCT REPLACE(TRIM(TRANSLATE(a.fontes::TEXT, '"\{}', ''), ','), '","', ',')))::TEXT, '"', ''), '{,', '{'), ',}', '}'), ',,', ',')::TEXT[] AS fontes 
		FROM (
			SELECT 
				COALESCE(dc_certificado.tx_nome_certificado, 'Sem informação') AS rotulo, 
				count(*) AS valor, 
				ARRAY_CAT(ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_certificado.ft_certificado, ''), '${ETL}', '')), ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_osc.ft_identificador_osc, ''), '${ETL}', ''))) AS fontes 
			FROM osc.tb_osc 
			LEFT JOIN osc.tb_certificado 
			ON tb_osc.id_osc = tb_certificado.id_osc
			LEFT JOIN syst.dc_certificado 
			ON tb_certificado.cd_certificado = dc_certificado.cd_certificado
			WHERE tb_osc.bo_osc_ativa 
			GROUP BY rotulo
		) AS a;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_grafico_osc_titulos_certificados();

