DROP FUNCTION IF EXISTS portal.obter_perfil_localidade(INTEGER) CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_perfil_localidade(id_localidade INTEGER) RETURNS TABLE (
	resultado JSONB,
	mensagem TEXT,
	flag BOOLEAN
) AS $$ 

DECLARE
	caracteristicas_json JSONB;
	caracteristicas_fontes_json JSONB;
	evolucao_anual_json JSONB;
	evolucao_anual_fontes_json JSONB;
	natureza_juridica_json JSONB;
	natureza_juridica_maior_media_nacional_json JSONB;
	natureza_juridica_fontes_json JSONB;

BEGIN
	resultado := '{}'::JSONB;
	
	/* ==================== Características ==================== */
	SELECT INTO caracteristicas_json
		row_to_json(b)
	FROM (
			SELECT json_agg(a) AS caracteristicas
			FROM (
				SELECT
					quantidade_oscs AS quantidade,
					quantidade_trabalhadores AS nr_quantidade_trabalhadores,
					quantidade_recursos AS nr_quantidade_recursos,
					quantidade_projetos AS nr_quantidade_projetos
				FROM analysis.vw_perfil_localidade_caracteristicas
				WHERE localidade = 35::TEXT
			) AS a
	) AS b;

	SELECT INTO caracteristicas_fontes_json
		row_to_json(c) 
	FROM (
		SELECT ARRAY_AGG(b.fontes) AS fontes FROM (
			SELECT 
				DISTINCT UNNEST(a.fontes) AS fontes
			FROM (
				SELECT a.fontes
				FROM analysis.vw_perfil_localidade_caracteristicas AS a
				WHERE a.localidade = id_localidade::TEXT
			) AS a
		) AS b
	) AS c;

	resultado := resultado || caracteristicas_json || caracteristicas_fontes_json;

	/* ==================== Evolução Anual ==================== */
	SELECT INTO evolucao_anual_json
		row_to_json(b)
	FROM (
			SELECT json_agg(a) AS caracteristicas
			FROM (
				SELECT
					fundacao AS x,
					quantidade_oscs AS y
				FROM analysis.vw_perfil_localidade_evolucao_anual
				WHERE localidade = id_localidade::TEXT
			) AS a
	) AS b;

	SELECT INTO evolucao_anual_fontes_json
		row_to_json(c) 
	FROM (
		SELECT ARRAY_AGG(b.fontes) AS fontes FROM (
			SELECT 
				DISTINCT UNNEST(a.fontes) AS fontes
			FROM (
				SELECT a.fontes
				FROM analysis.vw_perfil_localidade_evolucao_anual AS a
				WHERE a.localidade = id_localidade::TEXT
			) AS a
		) AS b
	) AS c;
	
	resultado := resultado || evolucao_anual_json || evolucao_anual_fontes_json;

	/* ==================== Natureza Jurídica ==================== */
	SELECT INTO natureza_juridica_json
		row_to_json(b) 
	FROM (
		SELECT 
			a.natureza_juridica AS tx_porcentagem_maior,
			a.porcertagem_maior AS nr_porcentagem_maior,
			(
				SELECT json_agg(a)
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

	SELECT INTO natureza_juridica_fontes_json
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
	
	SELECT INTO natureza_juridica_maior_media_nacional_json
		row_to_json(a) 
	FROM (
		SELECT
			65 AS nr_porcentagem_maior_media_nacional,
			dado AS tx_porcentagem_maior_media_nacional
		FROM analysis.vw_perfil_localidade_media_nacional
		WHERE tipo_dado = 'maior_natureza_juridica'
	) AS a;
	
	resultado := resultado || natureza_juridica_json || natureza_juridica_fontes_json || natureza_juridica_maior_media_nacional_json;
	
	/* ------------------------------ RESULTADO ------------------------------ */
	flag := true;
	mensagem := 'Perfil de localidade retornado.';

	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '%', SQLERRM;
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;

END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_perfil_localidade(35);