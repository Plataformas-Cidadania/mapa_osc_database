DROP FUNCTION IF EXISTS portal.obter_grafico_total_osc_ano(parametros JSONB) CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_total_osc_ano(parametros JSONB) RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

BEGIN 
	dados := '[
		{
			"key": "Número OSC Parcerias",
			"values":[
				{
					"label": 2009, 
					"value": 1251
				},
				{
					"label": 2010, 
					"value": 1526
				},
				{
					"label": 2011, 
					"value" : 16090
				},
				{
					"label": 2012, 
					"value": 16557
				},
				{
					"label": 2013, 
					"value": 16642
				},
				{
					"label": 2014, 
					"value": 16974
				},
				{
					"label": 2015, 
					"value": 14984
				},
				{
					"label": 2016, 
					"value": 16086
				},
				{
					"label": 2017, 
					"value": 1441
				}
			]
		},
		{
			"key": "Valor Total Pago" ,
			"values":[
				{
					"label": 2009, 
					"value": 2825785175.20046
				},
				{
					"label": 2010, 
					"value": 3689756338.37335
				},
				{
					"label": 2011, 
					"value": 6897283626.21569
				},
				{
					"label": 2012, 
					"value": 7457550609.07884
				},
				{
					"label": 2013, 
					"value": 8738240049.30125
				},
				{
					"label": 2014, 
					"value": 6582659367.61274
				},
				{
					"label": 2015, 
					"value": 3476167177.2369
				},
				{
					"label": 2016, 
					"value": 3569745888.21392
				},
				{
					"label": 2017, 
					"value": 144648063.09
				}
			]
		}
	]'::JSONB;
	
	dados := '[' ||
		RTRIM((dados->>0)::TEXT, '}') || ', ' || '"cor": ' || '"' || ((parametros->>0)::JSONB->>'cor')::TEXT || ', ' || '"}, ' ||
		RTRIM((dados->>1)::TEXT, '}') || ', ' || '"cor": ' || '"' || ((parametros->>1)::JSONB->>'cor')::TEXT || ', ' || '"}' ||
	']';
	
	fontes := '{''RAIS'', ''CNIS''}'::TEXT[];
	
	RETURN QUERY 
		SELECT dados, fontes;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_grafico_total_osc_ano('[{"cor": "azul"}, {"cor": "vermelho"}]'::JSONB);
