DROP FUNCTION IF EXISTS analysis.obter_perfil_localidade2(INTEGER) CASCADE;

CREATE OR REPLACE FUNCTION analysis.obter_perfil_localidade2(id_localidade INTEGER) RETURNS TABLE (
	resultado JSONB,
	mensagem TEXT,
	codigo INTEGER
) AS $$ 

DECLARE
	record RECORD;
	caracteristicas_json JSONB;
	evolucao_anual_json JSONB;
	natureza_juridica_json JSONB;
	repasse_recursos_json JSONB;
	area_atuacao_json JSONB;
	trabalhadores_json JSONB;
	
	localidades_primeiro_colocado_quantidade_osc_municipio TEXT[];
	valor_primeiro_colocado_quantidade_osc_municipio INTEGER;
	localidades_ultimo_colocado_quantidade_osc_municipio TEXT[];
	valor_ultimo_colocado_quantidade_osc_municipio INTEGER;
	localidades_primeiro_colocado_quantidade_osc_estado TEXT[];
	valor_primeiro_colocado_quantidade_osc_estado INTEGER;
	localidades_ultimo_colocado_quantidade_osc_estado TEXT[];
	valor_ultimo_colocado_quantidade_osc_estado INTEGER;

	maior_media_nacional_natureza_juridica TEXT[];
	valor_maior_media_nacional_natureza_juridica DOUBLE PRECISION;
	
BEGIN
	SELECT INTO resultado row_to_json(a)
	FROM (
		SELECT
			nome_localidade AS tx_localidade,
			CASE
				WHEN tipo_localidade = 'regiao' THEN 'Região'
				WHEN tipo_localidade = 'estado' THEN 'Estado'
				WHEN tipo_localidade = 'municipio' THEN 'Município'
			END AS tx_tipo_localidade
		FROM analysis.vw_perfil_localidade_caracteristicas
		WHERE localidade = id_localidade::TEXT
	) AS a;
	
	-- ==================== Características ==================== --
	
	SELECT INTO caracteristicas_json
		row_to_json(b)
	FROM (
		SELECT
			row_to_json(a) AS caracteristicas
		FROM (
			SELECT
				nr_quantidade_osc,
				ft_quantidade_osc,
				nr_quantidade_trabalhadores,
				ft_quantidade_trabalhadores,
				nr_quantidade_recursos,
				ft_quantidade_recursos,
				nr_quantidade_projetos,
				ft_quantidade_projetos
			FROM analysis.vw_perfil_localidade_caracteristicas
			WHERE localidade = id_localidade::TEXT
		) AS a
	) AS b;
	
	caracteristicas_json := COALESCE(caracteristicas_json, '{"caracteristicas": null}'::JSONB);
	resultado := resultado || caracteristicas_json;

	-- ==================== Evolução Anual ==================== --
	
	SELECT INTO localidades_primeiro_colocado_quantidade_osc_municipio, valor_primeiro_colocado_quantidade_osc_municipio
		ARRAY_AGG(b.nome_localidade), MAX(a.nr_quantidade_osc)
	FROM analysis.vw_perfil_localidade_ranking_quantidade_osc AS a
	INNER JOIN analysis.vw_perfil_localidade_caracteristicas AS b
	ON a.localidade = b.localidade
	WHERE a.rank = 1
	AND tipo_rank = 'municipio';
	
	SELECT INTO localidades_ultimo_colocado_quantidade_osc_municipio, valor_ultimo_colocado_quantidade_osc_municipio
		ARRAY_AGG(b.nome_localidade), MAX(a.nr_quantidade_osc)
	FROM analysis.vw_perfil_localidade_ranking_quantidade_osc AS a
	INNER JOIN analysis.vw_perfil_localidade_caracteristicas AS b
	ON a.localidade = b.localidade
	WHERE a.rank = (
		SELECT MAX(rank)
		FROM analysis.vw_perfil_localidade_ranking_quantidade_osc
		WHERE localidade::INTEGER > 99
	)
	AND tipo_rank = 'municipio';

	SELECT INTO localidades_primeiro_colocado_quantidade_osc_estado, valor_primeiro_colocado_quantidade_osc_estado
		ARRAY_AGG(b.nome_localidade), MAX(a.nr_quantidade_osc)
	FROM analysis.vw_perfil_localidade_ranking_quantidade_osc AS a
	INNER JOIN analysis.vw_perfil_localidade_caracteristicas AS b
	ON a.localidade = b.localidade
	WHERE a.rank = 1
	AND tipo_rank = 'estado';
	
	SELECT INTO localidades_ultimo_colocado_quantidade_osc_estado, valor_ultimo_colocado_quantidade_osc_estado
		ARRAY_AGG(b.nome_localidade), MAX(a.nr_quantidade_osc)
	FROM analysis.vw_perfil_localidade_ranking_quantidade_osc AS a
	INNER JOIN analysis.vw_perfil_localidade_caracteristicas AS b
	ON a.localidade = b.localidade
	WHERE a.rank = (
		SELECT MAX(rank)
		FROM analysis.vw_perfil_localidade_ranking_quantidade_osc
		WHERE localidade::INTEGER BETWEEN 10 AND 99
	)
	AND tipo_rank = 'estado';

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
					WHERE localidade = id_localidade::TEXT
				) AS nr_colocacao_nacional,
				localidades_primeiro_colocado_quantidade_osc_municipio AS tx_primeiro_colocado_municipio,
				valor_primeiro_colocado_quantidade_osc_municipio AS nr_quantidade_oscs_primeiro_colocado_municipio,
				localidades_ultimo_colocado_quantidade_osc_municipio AS tx_ultimo_colocado_municipio,
				valor_ultimo_colocado_quantidade_osc_municipio AS nr_quantidade_oscs_ultimo_colocado_municipio,
				localidades_primeiro_colocado_quantidade_osc_estado AS tx_primeiro_colocado_estado,
				valor_primeiro_colocado_quantidade_osc_estado AS nr_quantidade_oscs_primeiro_colocado_estado,
				localidades_ultimo_colocado_quantidade_osc_estado AS tx_ultimo_colocado_estado,
				valor_ultimo_colocado_quantidade_osc_estado AS nr_quantidade_oscs_ultimo_colocado_estado,
				json_agg(a) AS series_1,
				(
					SELECT ARRAY_AGG(b.fontes) FROM (
						SELECT 
							DISTINCT UNNEST(a.fontes) AS fontes
						FROM (
							SELECT a.fontes
							FROM analysis.vw_perfil_localidade_evolucao_anual AS a
							WHERE a.localidade = id_localidade::TEXT
						) AS a
					) AS b
				) AS fontes
			FROM (
				SELECT
					'Quantidade OSC'::TEXT AS key,
					''::TEXT AS tipo_valor,
					true::BOOLEAN AS area,
					'#99d8ff'::TEXT AS color,
					(
						SELECT json_agg(a)
						FROM (
							SELECT ano_fundacao AS x, quantidade_oscs AS y
							FROM analysis.vw_perfil_localidade_evolucao_anual
							WHERE localidade = id_localidade::TEXT
							ORDER BY x
						) AS a
					) AS values
			) AS a
		) AS b
	) AS c;

	evolucao_anual_json := COALESCE(evolucao_anual_json, '{"evolucao_quantidade_osc_ano": null}'::JSONB);
	resultado := resultado || evolucao_anual_json;

	-- ==================== Natureza Jurídica ==================== --
	
	IF id_localidade > 99 THEN
		SELECT INTO maior_media_nacional_natureza_juridica, valor_maior_media_nacional_natureza_juridica 
			natureza_juridica, porcertagem_maior
		FROM analysis.vw_perfil_localidade_maior_natureza_juridica
		WHERE porcertagem_maior = (
			SELECT MAX(porcertagem_maior)
			FROM analysis.vw_perfil_localidade_maior_natureza_juridica
			WHERE localidade::INTEGER > 99
		);
	
	ELSIF id_localidade BETWEEN 10 AND 99 THEN
		SELECT INTO maior_media_nacional_natureza_juridica, valor_maior_media_nacional_natureza_juridica 
			natureza_juridica, porcertagem_maior
		FROM analysis.vw_perfil_localidade_maior_natureza_juridica
		WHERE porcertagem_maior = (
			SELECT MAX(porcertagem_maior)
			FROM analysis.vw_perfil_localidade_maior_natureza_juridica
			WHERE localidade::INTEGER BETWEEN 10 AND 99
		);

	ELSIF id_localidade BETWEEN 0 AND 9 THEN
		SELECT INTO maior_media_nacional_natureza_juridica, valor_maior_media_nacional_natureza_juridica 
			natureza_juridica, porcertagem_maior
		FROM analysis.vw_perfil_localidade_maior_natureza_juridica
		WHERE porcertagem_maior = (
			SELECT MAX(porcertagem_maior)
			FROM analysis.vw_perfil_localidade_maior_natureza_juridica
			WHERE localidade::INTEGER BETWEEN 0 AND 9
		);

	END IF;
	
	FOR record IN
		SELECT dado, valor
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
					record.dado AS tx_porcentagem_maior_media_nacional,
					ROUND(record.valor::DECIMAL, 2)::DOUBLE PRECISION AS nr_porcentagem_maior_media_nacional,
					a.natureza_juridica AS tx_porcentagem_maior,
					ROUND(a.porcertagem_maior::DECIMAL, 2)::DOUBLE PRECISION AS nr_porcentagem_maior,
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
	
	natureza_juridica_json := COALESCE(natureza_juridica_json, '{"natureza_juridica": null}'::JSONB);
	resultado := resultado || natureza_juridica_json;
	
	-- ==================== Repasse de Recursos ==================== --
	
	FOR record IN
		SELECT valor
		FROM analysis.vw_perfil_localidade_media_nacional
		WHERE tipo_dado = 'media_repasse_recursos'
	LOOP
		SELECT INTO repasse_recursos_json
			row_to_json(d) 
		FROM (
			SELECT
				row_to_json(c) AS repasse_recursos
			FROM (
				SELECT
					(
						SELECT media
						FROM analysis.vw_perfil_localidade_media_repasse_recursos
						WHERE localidade = id_localidade::TEXT
					) AS nr_repasse_media,
					ROUND(record.valor::DECIMAL, 2)::DOUBLE PRECISION AS nr_repasse_media_nacional,
					tipo_repasse AS tx_maior_tipo_repasse,
					ROUND(porcertagem_maior::DECIMAL, 2)::DOUBLE PRECISION AS nr_porcentagem_maior_tipo_repasse,
					(
						SELECT rank
						FROM analysis.vw_perfil_localidade_ranking_repasse_recursos
						WHERE localidade = id_localidade::TEXT
					) AS nr_colocacao_nacional,
					(
						SELECT json_agg(b)
						FROM (
							SELECT
								'$'::TEXT AS tipo_valor,
								fonte_recursos AS key, 
								(
									SELECT json_agg(a)
									FROM (
										SELECT ano AS x, SUM(valor_recursos) AS y
										FROM analysis.vw_perfil_localidade_repasse_recursos
										WHERE localidade = id_localidade::TEXT
										AND fonte_recursos = a.fonte_recursos
										GROUP BY ano
										ORDER BY x
									) AS a
								) AS values
							FROM analysis.vw_perfil_localidade_repasse_recursos AS a
							WHERE localidade = id_localidade::TEXT
							AND fonte_recursos IS NOT NULL
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
	
	repasse_recursos_json := COALESCE(repasse_recursos_json, '{"repasse_recursos": null}'::JSONB);
	resultado := resultado || repasse_recursos_json;
	
	-- ==================== Área de Atuação ==================== --
	
	SELECT INTO area_atuacao_json
		row_to_json(c) 
	FROM (
		SELECT
			row_to_json(b) AS area_atuacao
		FROM (
			SELECT
				a.area_atuacao AS tx_porcentagem_maior,
				ROUND(a.porcertagem_maior::DECIMAL, 2)::DOUBLE PRECISION AS nr_porcentagem_maior,
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

	area_atuacao_json = ('{"area_atuacao": ' || (area_atuacao_json->'area_atuacao' || '{"media_nacional": []}')::TEXT || '}')::JSON;

	FOR record IN
		SELECT json_array_elements_text((area_atuacao_json->'area_atuacao'->'tx_porcentagem_maior')::JSON) AS nome_area_atuacao
	LOOP
		 area_atuacao_json := jsonb_insert(
			(area_atuacao_json)::JSONB,
			'{area_atuacao, media_nacional, 0}',
			('{"tx_area_atuacao": "' || record.nome_area_atuacao || '", "nr_area_atuacao": "' || (
				SELECT media FROM analysis.vw_perfil_localidade_area_atuacao_nacional WHERE area_atuacao = record.nome_area_atuacao
			)::TEXT || '"}')::JSONB,
			true
		);
	END LOOP;
	
	area_atuacao_json := COALESCE(area_atuacao_json, '{"area_atuacao": null}'::JSONB);
	resultado := resultado || area_atuacao_json;
	
	-- ==================== Trabalhadores ==================== --
	
	FOR record IN
		SELECT dado, valor
		FROM analysis.vw_perfil_localidade_media_nacional
		WHERE tipo_dado = 'maior_trabalhadores'
	LOOP
		SELECT INTO trabalhadores_json
			row_to_json(c) 
		FROM (
			SELECT
				row_to_json(b) AS trabalhadores
			FROM (
				SELECT
					record.dado AS tx_porcentagem_maior_media_nacional,
					ROUND(record.valor::DECIMAL, 2)::DOUBLE PRECISION AS nr_porcentagem_maior_media_nacional,
					a.tipo_trabalhadores AS tx_porcentagem_maior,
					ROUND(a.porcertagem_maior::DECIMAL, 2)::DOUBLE PRECISION AS nr_porcentagem_maior,
					(
						SELECT json_agg(a)
						FROM (
							SELECT
								'Trabalhadores formais com vínculos' AS label,
								vinculos AS value
							FROM analysis.vw_perfil_localidade_trabalhadores
							WHERE localidade = id_localidade::TEXT
							UNION
							SELECT
								'Trabalhadores com deficiência' AS label,
								deficiencia AS value
							FROM analysis.vw_perfil_localidade_trabalhadores
							WHERE localidade = id_localidade::TEXT
							UNION
							SELECT
								'Trabalhadores voluntários' AS label,
								voluntarios AS value
							FROM analysis.vw_perfil_localidade_trabalhadores
							WHERE localidade = id_localidade::TEXT
						) AS a
					) AS series_1,
					(
						SELECT ARRAY_AGG(b.fontes) FROM (
							SELECT 
								DISTINCT UNNEST(a.fontes) AS fontes
							FROM (
								SELECT a.fontes
								FROM analysis.vw_perfil_localidade_trabalhadores AS a
								WHERE a.localidade = id_localidade::TEXT
								UNION
								SELECT a.fontes
								FROM analysis.vw_perfil_localidade_maior_trabalhadores AS a
								WHERE a.localidade = id_localidade::TEXT
							) AS a
						) AS b
					) AS fontes
				FROM analysis.vw_perfil_localidade_maior_trabalhadores AS a
				WHERE localidade = id_localidade::TEXT
			) AS b
		) AS c;
	END LOOP;
	
	trabalhadores_json := COALESCE(trabalhadores_json, '{"area_atuacao": null}'::JSONB);
	resultado := resultado || trabalhadores_json;
	
	/* ------------------------------ RESULTADO ------------------------------ */
	codigo := 200;
	mensagem := 'Perfil de localidade retornado.';

	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		codigo := 400;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;

END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM analysis.obter_perfil_localidade2(1100064::INTEGER);