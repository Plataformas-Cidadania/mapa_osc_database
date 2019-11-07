-- FUNCTION: portal.obter_grafico_total_osc_ano(jsonb)

-- DROP FUNCTION portal.obter_grafico_total_osc_ano(jsonb);

CREATE OR REPLACE FUNCTION portal.obter_grafico_total_osc_ano(
	parametros jsonb)
    RETURNS TABLE(dados jsonb, fontes text[]) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$ 
/*,
		{
			"key": "Taxa de Crescimento Acumulado",
			"values": [
				{"label": 2010, "value": 0}, 
				{"label": 2011, "value": 0.04}, 
				{"label": 2012, "value": 0.01}, 
				{"label": 2013, "value": 0.012}, 
				{"label": 2014, "value": -0.067}, 
				{"label": 2015, "value": 0.031}, 
				{"label": 2016, "value": 0.56}
			]
		}*/
BEGIN 
	dados := '[
		{
			"key": "Número de OSCs",
			"values": [
				{"label": 2010, "value": 530986}, 
				{"label": 2011, "value": 554625}, 
				{"label": 2012, "value": 574055}, 
				{"label": 2013, "value": 568961}, 
				{"label": 2014, "value": 552575}, 
				{"label": 2015, "value": 525591}, 
				{"label": 2016, "value": 820186},
				{"label": 2018, "value": 781921}
			]
		}
		
	]'::JSONB;
	
	dados := '[' ||
		RTRIM((dados->>0)::TEXT, '}') || ', ' || '"color": ' || COALESCE('"' || ((parametros->>0)::JSONB->>'color')::TEXT || '"', 'null') || '}'--'}, ' ||
		--RTRIM((dados->>1)::TEXT, '}') || ', ' || '"color": ' || COALESCE('"' || ((parametros->>1)::JSONB->>'color')::TEXT || '"', 'null') || '}' ||
	']';
	
	dados := '[' ||
		RTRIM((dados->>0)::TEXT, '}') || ', ' || '"line": ' || COALESCE('"' || ((parametros->>0)::JSONB->>'line')::TEXT || '"', 'null') ||'}' --'}, ' ||
		--RTRIM((dados->>1)::TEXT, '}') || ', ' || '"bar": ' || COALESCE('"' || ((parametros->>1)::JSONB->>'bar')::TEXT || '"', 'null') || '}' ||
	']';
	
	fontes := '{''RAIS/MTE'', ''CNPJ/SRF/MF''}'::TEXT[];
	
	RETURN QUERY 
		SELECT dados, fontes;
END;

$BODY$;

ALTER FUNCTION portal.obter_grafico_total_osc_ano(jsonb)
    OWNER TO postgres;
