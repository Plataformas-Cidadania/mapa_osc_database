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
				{"label": 2010, "value": 623579},
				{"label": 2011, "value": 655085},
				{"label": 2012, "value": 684125},
				{"label": 2013, "value": 716811},
				{"label": 2014, "value": 746109},
				{"label": 2015, "value": 772631},
				{"label": 2016, "value": 795092},
				{"label": 2017, "value": 781921},
				{"label": 2018, "value": 836936},
				{"label": 2019, "value": 847585},
				{"label": 2020, "value": 841244},
				{"label": 2021, "value": 860490},
				{"label": 2022, "value": 879117},
				{"label": 2023, "value": 879326}]
		}

	]'::JSONB;

	dados := '[' ||
		RTRIM((dados->>0)::TEXT, '}') || ', ' || '"color": ' || COALESCE('"' || ((parametros->>0)::JSONB->>'color')::TEXT || '"', 'null') || '}'
	']';

	dados := '[' ||
		RTRIM((dados->>0)::TEXT, '}') || ', ' || '"line": ' || COALESCE('"' || ((parametros->>0)::JSONB->>'line')::TEXT || '"', 'null') ||'}'
	']';

	fontes := '{''RAIS/MTE'', ''CNPJ/SRF/MF'',''CNPJ/SRF/MF/2023_01''}'::TEXT[];

	RETURN QUERY
		SELECT dados, fontes;
END;

$$;

alter function portal.obter_grafico_total_osc_ano(jsonb) owner to postgres;