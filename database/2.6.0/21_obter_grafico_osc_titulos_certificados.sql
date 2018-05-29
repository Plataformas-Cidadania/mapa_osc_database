DROP FUNCTION IF EXISTS portal.obter_grafico_osc_titulos_certificados() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_osc_titulos_certificados() RETURNS TABLE (
	titulo TEXT, 
	tipo TEXT, 
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			'Número de organizações civis com títulos e certificações'::TEXT AS titulo, 
			'barras'::TEXT AS tipo, 
			b.dados::JSONB AS dados, 
			b.fontes::TEXT[] AS fontes 
		FROM (
			SELECT 
				('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('{"rotulo": "' || a.rotulo::TEXT || '", "valor": ' || a.valor::TEXT || '}')::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '{'), '}') || '}]') AS dados, 
				(SELECT ARRAY(SELECT DISTINCT UNNEST(('{' || BTRIM(REPLACE(REPLACE(RTRIM(LTRIM(TRANSLATE(ARRAY_AGG(a.fontes::TEXT)::TEXT, '"\', ''), '{'), '}'), '},{', ','), ',,', ','), ',') || '}')::TEXT[]))) AS fontes 
			FROM (
				SELECT 
					dc_certificado.tx_nome_certificado AS rotulo, 
					count(*) AS valor, 
					ARRAY_AGG(DISTINCT(COALESCE(tb_certificado.ft_certificado, ''))) AS fontes
				FROM osc.tb_certificado 
				INNER JOIN syst.dc_certificado 
				ON tb_certificado.cd_certificado = dc_certificado.cd_certificado
				GROUP BY dc_certificado.cd_certificado
			) AS a
		) AS b;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_grafico_osc_titulos_certificados();
