DROP FUNCTION IF EXISTS portal.obter_graficos();

CREATE OR REPLACE FUNCTION portal.obter_graficos() RETURNS TABLE (
	nome_grafico TEXT,
	grafico JSONB
) AS $$ 

BEGIN 
	/*
	SELECT 
		('osc_natureza_juridica_regiao'::TEXT, (SELECT a FROM (SELECT * FROM portal.obter_grafico_osc_natureza_juridica_regiao()) as a)), 
		('distribuicao_osc_empregados_regiao'::TEXT, (SELECT a FROM (SELECT * FROM portal.obter_grafico_distribuicao_osc_empregados_regiao()) as a)), 
		('osc_titulos_certificados'::TEXT, (SELECT a FROM (SELECT * FROM portal.obter_grafico_osc_titulos_certificados()) as a))
	INTO nome_grafico, grafico;
	
	RETURN NEXT;
	*/

	RETURN QUERY SELECT (
		(
			'osc_natureza_juridica_regiao', (SELECT a FROM (SELECT * FROM portal.obter_grafico_osc_natureza_juridica_regiao()) as a)
		), 
		(
			'osc_natureza_juridica_regiao', (SELECT a FROM (SELECT * FROM portal.obter_grafico_osc_natureza_juridica_regiao()) as a)
		)
	);
	
	
EXCEPTION
	WHEN others THEN 
		RAISE NOTICE '%', SQLERRM;
		RETURN NEXT;
END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_graficos();

