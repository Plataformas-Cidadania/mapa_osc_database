DROP FUNCTION IF EXISTS cache.obter_geo_idh_municipio_por_estado(INTEGER);

CREATE OR REPLACE FUNCTION cache.obter_geo_idh_municipio_por_estado(cd_estado INTEGER) RETURNS TABLE (
	resultado JSONB, 
	mensagem TEXT, 
	codigo INTEGER
) AS $$

BEGIN 
	SELECT INTO resultado array_to_json(array_agg(row_to_json(a)))
	FROM 
	(
		SELECT 
			edmu_cd_municipio::TEXT,
			(edmu_nm_municipio || ' - ' || eduf_sg_uf)::TEXT AS nm_municipio,
			edmu_geometry,
			(
				SELECT nr_valor::TEXT
				FROM ipeadata.tb_ipeadata
				WHERE cd_municipio = a.edmu_cd_municipio
				AND nr_ano = 2016
				AND cd_indice = 8
			)
		FROM spat.ed_municipio AS a
		INNER JOIN spat.ed_uf AS b
		ON a.eduf_cd_uf = b.eduf_cd_uf
		WHERE a.eduf_cd_uf = cd_estado
		LIMIT 3
	) AS a;

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
		RAISE NOTICE '%', SQLERRM;
		codigo := 400;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM cache.obter_geo_idh_municipio_por_estado(11::INTEGER);