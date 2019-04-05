DROP FUNCTION IF EXISTS cache.inserir_cache_exportar(TEXT);

CREATE OR REPLACE FUNCTION cache.inserir_cache_exportar(dado TEXT) RETURNS TABLE (
	resultado INTEGER, 
	mensagem TEXT, 
	codigo INTEGER
) AS $$ 

BEGIN 
	INSERT INTO cache.tb_exportar(tx_dado, dt_data_expiracao) 
		VALUES (dado, (now() + interval '1 day')::TIMESTAMP))
		RETURNING id_exportar INTO resultado;

	IF resultado IS NOT null THEN
		codigo := 200;
		mensagem := 'Cache inserido.';
	ELSE
		codigo := 404;
		mensagem := 'Cache não inserido.';
	END IF;

	RETURN NEXT;
	
EXCEPTION
	WHEN others THEN
		codigo := 400;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;
$$ LANGUAGE 'plpgsql';