DROP FUNCTION IF EXISTS portal.obter_grafico(TEXT);

CREATE OR REPLACE FUNCTION portal.obter_grafico(param TEXT) RETURNS TABLE (
	resultado JSONB, 
	mensagem TEXT, 
	codigo INTEGER
) AS $$ 

DECLARE
	linha RECORD;

BEGIN 
	SELECT INTO linha 
		configuracao, 
		tipo_grafico, 
		titulo, 
		legenda, 
		titulo_colunas, 
		legenda_x, 
		legenda_y, 
		series_1, 
		series_2, 
		fontes 
	FROM 
		portal.tb_analise
	WHERE 
		id_analise = param::INTEGER;

	IF linha != (null::TEXT[], null::TEXT, null::TEXT, null::TEXT, null::TEXT[], null::TEXT, null::TEXT, null::JSONB, null::JSONB, null::TEXT[])::RECORD THEN 
		resultado := to_jsonb(linha);
		codigo := 200;
		mensagem := 'Dados de gráfico retornado.';
	ELSE 
		codigo := 404;
		mensagem := 'Gráfico não encontrada.';
	END IF;

	RETURN NEXT;
	
EXCEPTION
	WHEN others THEN 
		codigo := 400;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_grafico(1::TEXT);
