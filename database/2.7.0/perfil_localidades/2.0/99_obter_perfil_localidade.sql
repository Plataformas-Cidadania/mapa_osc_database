DROP FUNCTION IF EXISTS portal.obter_perfil_localidade(INTEGER) CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_perfil_localidade(id_localidade INTEGER) RETURNS TABLE (
	resultado JSONB,
	mensagem TEXT,
	flag BOOLEAN
) AS $$ 

DECLARE
	natureza_juridica_json JSONB;
	fontes_json JSONB;

BEGIN 
	SELECT INTO natureza_juridica_json
		row_to_json(b) 
	FROM (
		SELECT 
			a.natureza_juridica AS tx_porcentagem_maior,
			a.porcertagem_maior AS nr_porcentagem_maior,
			(
				SELECT json_agg(row_to_json(a))
				FROM (
					SELECT
						quantidade_oscs,
						natureza_juridica,
						quantidade_oscs
					FROM analysis.vw_perfil_localidade_natureza_juridica
					WHERE localidade = id_localidade::TEXT
				) AS a
			) AS series_1
		FROM analysis.vw_perfil_localidade_maior_natureza_juridica AS a
		WHERE localidade = id_localidade::TEXT
	) AS b;

	SELECT INTO fontes_json
		row_to_json(c) 
	FROM (
		SELECT ARRAY_AGG(b.fontes) AS fontes FROM (
			SELECT 
				DISTINCT UNNEST(a.fontes) AS fontes
			FROM (
				SELECT a.fontes
				FROM analysis.vw_perfil_localidade_natureza_juridica AS a
				WHERE a.localidade = id_localidade::TEXT
				UNION
				SELECT a.fontes
				FROM analysis.vw_perfil_localidade_maior_natureza_juridica AS a
				WHERE a.localidade = id_localidade::TEXT
			) AS a
		) AS b
	) AS c;
	
	natureza_juridica_json := natureza_juridica_json || fontes_json;
	
	resultado := natureza_juridica_json;

	flag := true;
	mensagem := 'Perfil de localidade retornado.';

	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;

END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_perfil_localidade(35);