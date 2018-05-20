DROP FUNCTION IF EXISTS portal.obter_grafico_osc_titulos_certificados() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_osc_titulos_certificados() RETURNS TABLE (
	titulo TEXT, 
	tipo TEXT, 
	dados JSON
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			'Número de organizações civis com títulos e certificações'::TEXT AS titulo, 
			'barras'::TEXT AS tipo,
			array_to_json(array_agg(('{"' || rotulo || '": ' || valor || '}')::JSON)) AS valor 
		FROM (
			SELECT dc_certificado.tx_nome_certificado AS rotulo, count(*) AS valor 
			FROM osc.tb_certificado 
			INNER JOIN syst.dc_certificado 
			ON tb_certificado.cd_certificado = dc_certificado.cd_certificado
			GROUP BY dc_certificado.cd_certificado
		) AS a;
END;

$$ LANGUAGE 'plpgsql';
