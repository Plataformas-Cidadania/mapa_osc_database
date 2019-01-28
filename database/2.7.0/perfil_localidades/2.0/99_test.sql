DO $$

DECLARE
	id_localidade INTEGER := 1;
	resultado JSONB := '{}';
	
	record RECORD;
	caracteristicas_json JSONB;
	evolucao_anual_json JSONB;
	natureza_juridica_json JSONB;
	repasse_recursos_json JSONB;
	area_atuacao_json JSONB;
	
	localidades_maior_media_nacional_natureza_juridica TEXT[];
	valor_maior_media_nacional_natureza_juridica DOUBLE PRECISION;
	localidades_primeiro_colocado_quantidade_osc TEXT[];
	valor_primeiro_colocado_quantidade_osc INTEGER;
	localidades_ultimo_colocado_quantidade_osc TEXT[];
	valor_ultimo_colocado_quantidade_osc INTEGER;
	
BEGIN
	-- ==================== Características ==================== --
	/*
	SELECT INTO caracteristicas_json
		row_to_json(b)
	FROM (
		SELECT
			row_to_json(a) AS caracteristicas
		FROM (
			SELECT
				quantidade_oscs AS quantidade,
				quantidade_trabalhadores AS nr_quantidade_trabalhadores,
				quantidade_recursos AS nr_quantidade_recursos,
				quantidade_projetos AS nr_quantidade_projetos,
				(
					SELECT ARRAY_AGG(b.fontes)
					FROM (
						SELECT 
							DISTINCT UNNEST(a.fontes) AS fontes
						FROM (
							SELECT a.fontes
							FROM analysis.vw_perfil_localidade_caracteristicas AS a
							WHERE a.localidade = 35::TEXT
						) AS a
					) AS b
				) AS fontes
			FROM analysis.vw_perfil_localidade_caracteristicas
			WHERE localidade = 35::TEXT
		) AS a
	) AS b;

	resultado := resultado || caracteristicas_json;
	*/
	-- ==================== Evolução Anual ==================== --
	/*
	IF id_localidade > 99 THEN
		SELECT INTO localidades_primeiro_colocado_quantidade_osc, valor_primeiro_colocado_quantidade_osc
			ARRAY_AGG(b.nome_localidade), MAX(a.quantidade_oscs)
		FROM analysis.vw_perfil_localidade_ranking_quantidade_osc AS a
		INNER JOIN analysis.vw_perfil_localidade_caracteristicas AS b
		ON a.localidade = b.localidade
		WHERE a.rank = (
			SELECT MAX(rank)
			FROM analysis.vw_perfil_localidade_ranking_quantidade_osc
			WHERE localidade::INTEGER > 99
		);
		
		SELECT INTO localidades_ultimo_colocado_quantidade_osc, valor_ultimo_colocado_quantidade_osc
			ARRAY_AGG(b.nome_localidade), MAX(a.quantidade_oscs)
		FROM analysis.vw_perfil_localidade_ranking_quantidade_osc AS a
		INNER JOIN analysis.vw_perfil_localidade_caracteristicas AS b
		ON a.localidade = b.localidade
		WHERE a.rank = (
			SELECT MIN(rank)
			FROM analysis.vw_perfil_localidade_ranking_quantidade_osc
			WHERE localidade::INTEGER > 99
		);
	ELSIF id_localidade BETWEEN 0 AND 9 THEN
		SELECT INTO localidades_primeiro_colocado_quantidade_osc, valor_primeiro_colocado_quantidade_osc
			ARRAY_AGG(b.nome_localidade), MAX(a.quantidade_oscs)
		FROM analysis.vw_perfil_localidade_ranking_quantidade_osc AS a
		INNER JOIN analysis.vw_perfil_localidade_caracteristicas AS b
		ON a.localidade = b.localidade
		WHERE a.rank = (
			SELECT MIN(rank)
			FROM analysis.vw_perfil_localidade_ranking_quantidade_osc
			WHERE localidade::INTEGER BETWEEN 0 AND 9
		);
		
		SELECT INTO localidades_ultimo_colocado_quantidade_osc, valor_ultimo_colocado_quantidade_osc
			ARRAY_AGG(b.nome_localidade), MAX(a.quantidade_oscs)
		FROM analysis.vw_perfil_localidade_ranking_quantidade_osc AS a
		INNER JOIN analysis.vw_perfil_localidade_caracteristicas AS b
		ON a.localidade = b.localidade
		WHERE a.rank = (
			SELECT MIN(rank)
			FROM analysis.vw_perfil_localidade_ranking_quantidade_osc
			WHERE localidade::INTEGER BETWEEN 0 AND 9
		);
	ELSIF id_localidade BETWEEN 10 AND 99 THEN
		SELECT INTO localidades_primeiro_colocado_quantidade_osc, valor_primeiro_colocado_quantidade_osc
			ARRAY_AGG(b.nome_localidade), MAX(a.quantidade_oscs)
		FROM analysis.vw_perfil_localidade_ranking_quantidade_osc AS a
		INNER JOIN analysis.vw_perfil_localidade_caracteristicas AS b
		ON a.localidade = b.localidade
		WHERE a.rank = (
			SELECT MIN(rank)
			FROM analysis.vw_perfil_localidade_ranking_quantidade_osc
			WHERE localidade::INTEGER BETWEEN 10 AND 99
		);
		
		SELECT INTO localidades_ultimo_colocado_quantidade_osc, valor_ultimo_colocado_quantidade_osc
			ARRAY_AGG(b.nome_localidade), MAX(a.quantidade_oscs)
		FROM analysis.vw_perfil_localidade_ranking_quantidade_osc AS a
		INNER JOIN analysis.vw_perfil_localidade_caracteristicas AS b
		ON a.localidade = b.localidade
		WHERE a.rank = (
			SELECT MIN(rank)
			FROM analysis.vw_perfil_localidade_ranking_quantidade_osc
			WHERE localidade::INTEGER BETWEEN 10 AND 99
		);
	END IF;
	
	SELECT INTO evolucao_anual_json
		row_to_json(c)
	FROM (
		SELECT
			row_to_json(b) AS evolucao_quantidade_osc_ano
		FROM (
			SELECT 
				(
					SELECT rank
					FROM analysis.vw_perfil_localidade_ranking_quantidade_osc
					WHERE localidade = 35::TEXT
				) AS nr_colocacao_nacional,
				localidades_primeiro_colocado_quantidade_osc AS tx_primeiro_colocado,
				valor_primeiro_colocado_quantidade_osc AS nr_quantidade_oscs_primeiro_colocado,
				localidades_ultimo_colocado_quantidade_osc AS tx_ultimo_colocado,
				valor_ultimo_colocado_quantidade_osc AS nr_quantidade_oscs_ultimo_colocado,
				json_agg(a) AS series_1,
				(
					SELECT ARRAY_AGG(b.fontes) FROM (
						SELECT 
							DISTINCT UNNEST(a.fontes) AS fontes
						FROM (
							SELECT a.fontes
							FROM analysis.vw_perfil_localidade_evolucao_anual AS a
							WHERE a.localidade = 35::TEXT
						) AS a
					) AS b
				) AS fontes
			FROM (
				SELECT ano_fundacao AS x, quantidade_oscs AS y
				FROM analysis.vw_perfil_localidade_evolucao_anual
				WHERE localidade = 35::TEXT
			) AS a
		) AS b
	) AS c;

	resultado := resultado || evolucao_anual_json;
	*/
	-- ==================== Natureza Jurídica ==================== --
	/*
	IF id_localidade > 99 THEN
		SELECT INTO localidades_maior_media_nacional_natureza_juridica, valor_maior_media_nacional_natureza_juridica 
			ARRAY_AGG(b.nome_localidade), MAX(a.porcertagem_maior)
		FROM analysis.vw_perfil_localidade_maior_natureza_juridica AS a
		INNER JOIN analysis.vw_perfil_localidade_caracteristicas AS b
		ON a.localidade = b.localidade
		WHERE a.porcertagem_maior = (
			SELECT MAX(porcertagem_maior)
			FROM analysis.vw_perfil_localidade_maior_natureza_juridica
			WHERE localidade::INTEGER > 99
		);
	ELSIF id_localidade BETWEEN 0 AND 9 THEN
		SELECT INTO localidades_maior_media_nacional_natureza_juridica, valor_maior_media_nacional_natureza_juridica 
			ARRAY_AGG(b.nome_localidade), MAX(a.porcertagem_maior)
		FROM analysis.vw_perfil_localidade_maior_natureza_juridica AS a
		INNER JOIN analysis.vw_perfil_localidade_caracteristicas AS b
		ON a.localidade = b.localidade
		WHERE a.porcertagem_maior = (
			SELECT MAX(porcertagem_maior)
			FROM analysis.vw_perfil_localidade_maior_natureza_juridica
			WHERE localidade::INTEGER BETWEEN 0 AND 9
		);
	ELSIF id_localidade BETWEEN 10 AND 99 THEN
		SELECT INTO localidades_maior_media_nacional_natureza_juridica, valor_maior_media_nacional_natureza_juridica 
			ARRAY_AGG(b.nome_localidade), MAX(a.porcertagem_maior)
		FROM analysis.vw_perfil_localidade_maior_natureza_juridica AS a
		INNER JOIN analysis.vw_perfil_localidade_caracteristicas AS b
		ON a.localidade = b.localidade
		WHERE a.porcertagem_maior = (
			SELECT MAX(porcertagem_maior)
			FROM analysis.vw_perfil_localidade_maior_natureza_juridica
			WHERE localidade::INTEGER BETWEEN 10 AND 99
		);
	END IF;
	
	FOR record IN
		SELECT dado AS tx_porcentagem_maior_media_nacional, maior_porcentagem AS nr_porcentagem_maior_media_nacional
		FROM analysis.vw_perfil_localidade_media_nacional
		WHERE tipo_dado = 'maior_natureza_juridica'
	LOOP
		SELECT INTO natureza_juridica_json
			row_to_json(c) 
		FROM (
			SELECT
				row_to_json(b) AS natureza_juridica
			FROM (
				SELECT
					a.natureza_juridica AS tx_porcentagem_maior,
					a.porcertagem_maior AS nr_porcentagem_maior,
					localidades_maior_media_nacional_natureza_juridica AS tx_porcentagem_maior_media_nacional,
					valor_maior_media_nacional_natureza_juridica AS nr_porcentagem_maior_media_nacional,
					(
						SELECT json_agg(a)
						FROM (
							SELECT
								natureza_juridica AS label,
								quantidade_oscs AS value
							FROM analysis.vw_perfil_localidade_natureza_juridica
							WHERE localidade = id_localidade::TEXT
						) AS a
					) AS series_1,
					(
						SELECT ARRAY_AGG(b.fontes) FROM (
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
					) AS fontes
				FROM analysis.vw_perfil_localidade_maior_natureza_juridica AS a
				WHERE localidade = id_localidade::TEXT
			) AS b
		) AS c;
	END LOOP;
	
	resultado := resultado || natureza_juridica_json;
	*/
	-- ==================== Repasse de Recursos ==================== --
	/*
	FOR record IN
		SELECT dado AS tx_porcentagem_maior_media_nacional, maior_porcentagem AS nr_porcentagem_maior_media_nacional
		FROM analysis.vw_perfil_localidade_media_nacional
		WHERE tipo_dado = 'maior_repasse_recursos'
	LOOP
		SELECT INTO repasse_recursos_json
			row_to_json(d) 
		FROM (
			SELECT
				row_to_json(c) AS repasse_recursos
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
					) AS series_1,
					(
						SELECT ARRAY_AGG(b.fontes) FROM (
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
					) AS fontes
				FROM analysis.vw_perfil_localidade_maior_media_repasse_recursos AS a
				WHERE localidade = id_localidade::TEXT
			) AS c
		) AS d;
	END LOOP;
	
	resultado := resultado || repasse_recursos_json;
	*/
	-- ==================== Área de Atuação ==================== --
	
	FOR record IN
		SELECT dado AS tx_porcentagem_maior_media_nacional, maior_porcentagem AS nr_porcentagem_maior_media_nacional
		FROM analysis.vw_perfil_localidade_media_nacional
		WHERE tipo_dado = 'maior_area_atuacao'
	LOOP
		SELECT INTO area_atuacao_json
			row_to_json(c) 
		FROM (
			SELECT
				row_to_json(b) AS area_atuacao
			FROM (
				SELECT
					record.tx_porcentagem_maior_media_nacional,
					record.nr_porcentagem_maior_media_nacional,
					a.area_atuacao AS tx_porcentagem_maior,
					a.porcertagem_maior AS nr_porcentagem_maior,
					(
						SELECT json_agg(a)
						FROM (
							SELECT
								area_atuacao AS label,
								quantidade_oscs AS value
							FROM analysis.vw_perfil_localidade_area_atuacao
							WHERE localidade = id_localidade::TEXT
						) AS a
					) AS series_1,
					(
						SELECT ARRAY_AGG(b.fontes) FROM (
							SELECT 
								DISTINCT UNNEST(a.fontes) AS fontes
							FROM (
								SELECT a.fontes
								FROM analysis.vw_perfil_localidade_area_atuacao AS a
								WHERE a.localidade = id_localidade::TEXT
								UNION
								SELECT a.fontes
								FROM analysis.vw_perfil_localidade_maior_natureza_juridica AS a
								WHERE a.localidade = id_localidade::TEXT
							) AS a
						) AS b
					) AS fontes
				FROM analysis.vw_perfil_localidade_maior_area_atuacao AS a
				WHERE localidade = id_localidade::TEXT
			) AS b
		) AS c;
	END LOOP;
	
	resultado := resultado || area_atuacao_json;

	RAISE NOTICE '%', resultado;
END;
$$ LANGUAGE 'plpgsql';