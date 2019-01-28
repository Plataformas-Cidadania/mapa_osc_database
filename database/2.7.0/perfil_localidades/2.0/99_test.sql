DO $$

DECLARE
	id_localidade INTEGER := 35;
	
	record RECORD;
	caracteristicas_json JSONB;
	caracteristicas_fontes_json JSONB;
	evolucao_anual_json JSONB;
	evolucao_anual_fontes_json JSONB;
	natureza_juridica_json JSONB;
	natureza_juridica_fontes_json JSONB;
	repasse_recursos_json JSONB;
	repasse_recursos_fontes_json JSONB;

BEGIN
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
				WHERE localidade = id_localidade::TEXT
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
	
	--RAISE NOTICE '%', to_json(caracteristicas_json);
	--RAISE NOTICE '%', to_json(caracteristicas_fontes_json);
	
	/* ==================== Evolução Anual ==================== */
	SELECT INTO evolucao_anual_json
		row_to_json(b) AS evolucao_quantidade_osc_ano
	FROM (
		SELECT 
			(
				SELECT rank
				FROM analysis.vw_perfil_localidade_ranking_quantidade_osc
				WHERE localidade = id_localidade::TEXT
			) AS nr_colocacao_nacional,
			json_agg(a) AS series_1
		FROM (
			SELECT ano_fundacao AS x, quantidade_oscs AS y
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
	
	--RAISE NOTICE '%', to_json(evolucao_anual_json);
	--RAISE NOTICE '%', to_json(evolucao_anual_fontes_json);
	
	/* ==================== Natureza Jurídica ==================== */
	FOR record IN
		SELECT dado AS tx_porcentagem_maior_media_nacional, maior_porcentagem AS nr_porcentagem_maior_media_nacional
		FROM analysis.vw_perfil_localidade_media_nacional
		WHERE tipo_dado = 'maior_natureza_juridica'
	LOOP
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
	END LOOP;
	
	FOR record IN
		SELECT ARRAY_AGG(b.nome_localidade) AS tx_primeiro_colocado, MAX(a.quantidade_oscs) AS nr_quantidade_oscs_primeiro_colocado
		FROM analysis.vw_perfil_localidade_ranking_quantidade_osc AS a
		INNER JOIN analysis.vw_perfil_localidade_caracteristicas AS b
		ON a.localidade = b.localidade
		WHERE a.rank = (
			SELECT MIN(rank)
			FROM analysis.vw_perfil_localidade_ranking_quantidade_osc
			WHERE localidade::INTEGER > 99
		)
	LOOP
		--RAISE NOTICE '%', to_json(record);
	END LOOP;

	FOR record IN
		SELECT ARRAY_AGG(b.nome_localidade) AS tx_ultimo_colocado, MAX(a.quantidade_oscs) AS nr_quantidade_oscs_ultimo_colocado
		FROM analysis.vw_perfil_localidade_ranking_quantidade_osc AS a
		INNER JOIN analysis.vw_perfil_localidade_caracteristicas AS b
		ON a.localidade = b.localidade
		WHERE a.rank = (
			SELECT MAX(rank)
			FROM analysis.vw_perfil_localidade_ranking_quantidade_osc
			WHERE localidade::INTEGER > 99
		)
	LOOP
		--RAISE NOTICE '%', to_json(record);
	END LOOP;

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
	
	--RAISE NOTICE '%', to_json(natureza_juridica_json);
	--RAISE NOTICE '%', to_json(natureza_juridica_fontes_json);

	/* ==================== Repasse de Recursos ==================== */
	FOR record IN
		SELECT dado AS tx_porcentagem_maior_media_nacional, maior_porcentagem AS nr_porcentagem_maior_media_nacional
		FROM analysis.vw_perfil_localidade_media_nacional
		WHERE tipo_dado = '"maior_repasse_recursos"'
	LOOP
		SELECT INTO repasse_recursos_json
			row_to_json(c) 
		FROM (
			SELECT
				tipo_repasse AS tx_maior_tipo_repasse,
				porcertagem_maior AS nr_porcentagem_maior,
				(
					SELECT rank
					FROM analysis.vw_perfil_localidade_ranking_repasse_recursos
					WHERE localidade = id_localidade::TEXT
				) AS nr_colocacao_nacional,
				(
					SELECT json_agg(b)
					FROM (
						SELECT
							fonte_recursos AS key, 
							(
								SELECT json_agg(a)
								FROM (
									SELECT ano AS x, SUM(valor_recursos) AS y
									FROM analysis.vw_perfil_localidade_repasse_recursos
									WHERE localidade = id_localidade::TEXT
									AND fonte_recursos = a.fonte_recursos
									GROUP BY ano
								) AS a
							) AS values
						FROM analysis.vw_perfil_localidade_repasse_recursos AS a
						WHERE localidade = id_localidade::TEXT
						GROUP BY fonte_recursos
					) AS b
				) AS series_1
			FROM analysis.vw_perfil_localidade_maior_media_repasse_recursos AS a
			WHERE localidade = id_localidade::TEXT
		) AS c;
	END LOOP;

	SELECT INTO repasse_recursos_fontes_json
		row_to_json(c) 
	FROM (
		SELECT ARRAY_AGG(b.fontes) AS fontes FROM (
			SELECT 
				DISTINCT UNNEST(a.fontes) AS fontes
			FROM (
				SELECT a.fontes
				FROM analysis.vw_perfil_localidade_repasse_recursos AS a
				WHERE a.localidade = id_localidade::TEXT
				UNION
				SELECT a.fontes
				FROM analysis.vw_perfil_localidade_maior_media_repasse_recursos AS a
				WHERE a.localidade = id_localidade::TEXT
			) AS a
		) AS b
	) AS c;
	
	RAISE NOTICE '%', to_json(repasse_recursos_json);
	RAISE NOTICE '%', to_json(repasse_recursos_fontes_json);

END;
$$ LANGUAGE 'plpgsql';