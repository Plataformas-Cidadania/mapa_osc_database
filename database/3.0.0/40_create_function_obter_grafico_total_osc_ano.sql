drop function portal.obter_grafico_total_osc_ano(jsonb);

create function portal.obter_grafico_total_osc_ano(parametros jsonb)
    returns TABLE(dados jsonb, fontes text[])
    language plpgsql
as
$$
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
				{"label": 2018, "value": 781921},
                {"label": 2020, "value": 815676}
			]
		}

	]'::JSONB;

	dados := '[' ||
		RTRIM((dados->>0)::TEXT, '}') || ', ' || '"color": ' || COALESCE('"' || ((parametros->>0)::JSONB->>'color')::TEXT || '"', 'null') || '}'
	']';

	dados := '[' ||
		RTRIM((dados->>0)::TEXT, '}') || ', ' || '"line": ' || COALESCE('"' || ((parametros->>0)::JSONB->>'line')::TEXT || '"', 'null') ||'}'
	']';

	fontes := '{''RAIS/MTE'', ''CNPJ/SRF/MF''}'::TEXT[];

	RETURN QUERY
		SELECT dados, fontes;
END;

$$;

alter function portal.obter_grafico_total_osc_ano(jsonb) owner to postgres;