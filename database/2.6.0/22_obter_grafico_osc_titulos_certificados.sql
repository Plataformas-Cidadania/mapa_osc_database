DROP FUNCTION IF EXISTS portal.obter_grafico_osc_titulos_certificados();

CREATE OR REPLACE FUNCTION portal.obter_grafico_osc_titulos_certificados() RETURNS TABLE (
	titulo TEXT, 
	tipo TEXT, 
	resultado JSON
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			'Número de organizações civis com títulos e certificações'::TEXT AS titulo, 
			'barras'::TEXT AS tipo,
			array_to_json(array_agg(('{"' || rotulo || '": ' || valor || '}')::JSON)) AS valor 
		FROM (
			SELECT tx_nome_certificado AS rotulo, count(*) AS valor 
			FROM portal.vw_osc_certificado 
			GROUP BY tx_nome_certificado
		) AS a;
END;

$$ LANGUAGE 'plpgsql';

