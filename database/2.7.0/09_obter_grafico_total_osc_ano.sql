DROP FUNCTION IF EXISTS portal.obter_grafico_total_osc_ano(parametros JSONB) CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_total_osc_ano(parametros JSONB) RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

BEGIN 
	dados := '[
		{
			"key": "Número de OSCs",
			"values": [
				{"label": 2010, "value": 514027}, 
				{"label": 2011, "value": 534728}, 
				{"label": 2012, "value": 539792}, 
				{"label": 2013, "value": 546453}, 
				{"label": 2014, "value": 509608}, 
				{"label": 2015, "value": 525591}, 
				{"label": 2016, "value": 820186}
			]
		},
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
		}
	]'::JSONB;
	
	dados := '[' ||
		RTRIM((dados->>0)::TEXT, '}') || ', ' || '"color": ' || COALESCE('"' || ((parametros->>0)::JSONB->>'color')::TEXT || '"', 'null') || '}, ' ||
		RTRIM((dados->>1)::TEXT, '}') || ', ' || '"color": ' || COALESCE('"' || ((parametros->>1)::JSONB->>'color')::TEXT || '"', 'null') || '}' ||
	']';
	
	dados := '[' ||
		RTRIM((dados->>0)::TEXT, '}') || ', ' || '"bar": ' || COALESCE('"' || ((parametros->>0)::JSONB->>'bar')::TEXT || '"', 'null') || '}, ' ||
		RTRIM((dados->>1)::TEXT, '}') || ', ' || '"bar": ' || COALESCE('"' || ((parametros->>1)::JSONB->>'bar')::TEXT || '"', 'null') || '}' ||
	']';
	
	fontes := '{''MTE/RAIS'', ''MPS/CNIS''}'::TEXT[];
	
	RETURN QUERY 
		SELECT dados, fontes;
END;

$$ LANGUAGE 'plpgsql';
