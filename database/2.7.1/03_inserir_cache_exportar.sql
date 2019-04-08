DROP FUNCTION IF EXISTS cache.inserir_cache_exportar(TEXT);

CREATE OR REPLACE FUNCTION cache.inserir_cache_exportar(chave TEXT, valor TEXT) RETURNS TABLE (
	mensagem TEXT, 
	codigo INTEGER
) AS $$ 

BEGIN 
	INSERT INTO cache.tb_exportar(tx_chave, tx_valor) 
		VALUES (chave, valor);

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