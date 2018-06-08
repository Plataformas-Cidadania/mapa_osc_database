DROP FUNCTION IF EXISTS portal.atualizar_graficos(TEXT);

CREATE OR REPLACE FUNCTION portal.atualizar_graficos(param TEXT) RETURNS TABLE (
	resultado JSONB, 
	mensagem TEXT, 
	codigo INTEGER
) AS $$ 

DECLARE
	linha RECORD;

BEGIN 
	UPDATE portal.tb_analise

	resultado := to_jsonb(linha);
	codigo := 200;
	mensagem := 'Dados de gráfico retornado.';

	RETURN NEXT;
	
EXCEPTION
	WHEN others THEN 
		codigo := 400;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;
$$ LANGUAGE 'plpgsql';

