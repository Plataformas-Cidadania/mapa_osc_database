DROP FUNCTION IF EXISTS portal.obter_grafico_evolucao_recursos_transferidos(parametros JSONB) CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_evolucao_recursos_transferidos(parametros JSONB) RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

BEGIN 
	dados := '[
		{
			"key": "ESFLs", 
			"values":[
				{
					"x": 2010, 
					"y": 6278480452
				}, 
				{
					"x": 2011, 
					"y": 4898668291
				}, 
				{
					"x": 2012, 
					"y": 6688450140
				}, 
				{
					"x": 2013, 
					"y": 8196459734
				}, 
				{
					"x": 2014, 
					"y": 8265271851
				}, 
				{
					"x": 2015, 
					"y": 6744253807
				}, 
				{
					"x": 2016, 
					"y": 4901355349
				}, 
				{
					"x": 2017, 
					"y": 3252559195
				}
			]
        },
        {
			"key": "OSCs", 
			"values":[
				{
					"x": 2010, 
					"y": 11440189630.5479
				}, 
				{
					"x": 2011, 
					"y": 10054475412.4703
				}, 
				{
					"x": 2012, 
					"y": 10607810116.9065
				}, 
				{
					"x": 2013, 
					"y": 11099497076.5084
				}, 
				{
					"x": 2014, 
					"y": 12112818316.924
				}, 
				{
					"x": 2015, 
					"y": 11368502473.1809
				}, 
				{
					"x": 2016, 
					"y": 2312173689.10068
				}, 
				{
					"x": 2017, 
					"y": 6352490520.4482
				}
			]
        },
        {
			"key": "OSCs (Modalidade 50)", 
			"values":[
				{
					"x": 2010, 
					"y": 2678099914.85083
				}, 
				{
					"x": 2011, 
					"y": 1640846786.21371
				},
				{
					"x": 2012, 
					"y": 2433787954.02355
				}, 
				{
					"x": 2013, 
					"y": 2664537618.54551
				}, 
				{
					"x": 2014, 
					"y": 2498533417.99339
				}, 
				{
					"x": 2015, 
					"y": 1787719861.38991
				}, 
				{
					"x": 2016, 
					"y": 353510128.429499
				}, 
				{
					"x": 2017, 
					"y": 2229340028.59652
				}
			]
		}
	]'::JSONB;
	
	dados := '[' ||
		RTRIM((dados->>0)::TEXT, '}') || ', ' || '"tipo_valor": ' || COALESCE('"' || ((parametros->>0)::JSONB->>'tipo_valor')::TEXT || '"', 'null') || '}, ' || 
		RTRIM((dados->>1)::TEXT, '}') || ', ' || '"tipo_valor": ' || COALESCE('"' || ((parametros->>1)::JSONB->>'tipo_valor')::TEXT || '"', 'null') || '}, ' || 
		RTRIM((dados->>2)::TEXT, '}') || ', ' || '"tipo_valor": ' || COALESCE('"' || ((parametros->>1)::JSONB->>'tipo_valor')::TEXT || '"', 'null') || '}' ||
	']';
	
	fontes := null::TEXT[];
	
	RETURN QUERY 
		SELECT dados, fontes;
END;

$$ LANGUAGE 'plpgsql';
