DROP FUNCTION IF EXISTS portal.obter_grafico(TEXT);

CREATE OR REPLACE FUNCTION portal.obter_grafico(param TEXT) RETURNS TABLE (
	resultado JSONB,
	mensagem TEXT,
	flag BOOLEAN
) AS $$ 

DECLARE
	linha RECORD;

BEGIN 
	SELECT INTO linha
		id, 
		titulo, 
		tipo, 
		dados
	FROM 
		portal.vw_graficos
	WHERE 
		id = param::INTEGER;

	IF linha != (null::INTEGER, null::TEXT, null::TEXT)::RECORD THEN 
		resultado := to_jsonb(linha);
		flag := true;
		mensagem := 'Dados de gráfico retornado.';
	ELSE 
		flag := false;
		mensagem := 'Gráfico não encontrada.';
	END IF;

	RETURN NEXT;
	
EXCEPTION
	WHEN others THEN 
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;
$$ LANGUAGE 'plpgsql';
