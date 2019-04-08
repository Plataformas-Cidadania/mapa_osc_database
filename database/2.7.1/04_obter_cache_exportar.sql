DROP FUNCTION IF EXISTS cache.obter_cache_exportar(TEXT);

CREATE OR REPLACE FUNCTION cache.obter_cache_exportar(chave TEXT) RETURNS TABLE (
	resultado TEXT, 
	mensagem TEXT, 
	codigo INTEGER
) AS $$ 

BEGIN 
    SELECT INTO resultado tx_valor
		FROM cache.tb_exportar
        WHERE tx_chave = chave;

	IF resultado IS NOT null THEN
		codigo := 200;
		mensagem := 'Cache retornado.';
	ELSE
		codigo := 404;
		mensagem := 'Cache não retornado.';
	END IF;

	RETURN NEXT;
	
EXCEPTION
	WHEN others THEN
		codigo := 400;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;
$$ LANGUAGE 'plpgsql';