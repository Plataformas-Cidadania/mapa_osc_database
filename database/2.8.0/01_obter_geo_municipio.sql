DROP FUNCTION IF EXISTS cache.obter_geo_municipio(TEXT);

CREATE OR REPLACE FUNCTION cache.obter_geo_municipio(chave TEXT) RETURNS TABLE (
	resultado JSONB, 
	mensagem TEXT, 
	codigo INTEGER
) AS $$ 

BEGIN 
    SELECT
        edmu_cd_municipio,
        edmu_nm_municipio || ' - ' || eduf_sg_uf,
        edmu_geometry
    FROM spat.ed_municipio AS a
    INNER JOIN spat.ed_uf AS b
    ON a.eduf_cd_uf = b.eduf_cd_uf
    LIMIT 1000;

	IF resultado IS NOT null THEN
		codigo := 200;
		mensagem := 'Município retornado.';
	ELSE
		codigo := 404;
		mensagem := 'Município não retornado.';
	END IF;

	RETURN NEXT;
	
EXCEPTION
	WHEN others THEN
		codigo := 400;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;
$$ LANGUAGE 'plpgsql';