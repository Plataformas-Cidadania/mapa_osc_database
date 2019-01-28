DROP FUNCTION IF EXISTS analysis.obter_perfil_localidade(INTEGER) CASCADE;

CREATE OR REPLACE FUNCTION analysis.obter_perfil_localidade(id_localidade INTEGER) RETURNS TABLE (
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
	
	maior_media_nacional_natureza_juridica TEXT[];
	valor_maior_media_nacional_natureza_juridica DOUBLE PRECISION;
	localidades_primeiro_colocado_quantidade_osc TEXT[];
	valor_primeiro_colocado_quantidade_osc INTEGER;
	localidades_ultimo_colocado_quantidade_osc TEXT[];
	valor_ultimo_colocado_quantidade_osc INTEGER;
	
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
				quantidade_oscs AS nr_quantidade_oscs,
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
	
	IF caracteristicas_json IS NOT NULL THEN
		resultado := resultado || caracteristicas_json;
	END IF;

	-- ==================== Evolução Anual ==================== --
	
	IF id_localidade > 99 THEN
		SELECT INTO localidades_primeiro_colocado_quantidade_osc, valor_primeiro_colocado_quantidade_osc
			ARRAY_AGG(b.nome_localidade), MAX(a.quantidade_oscs)
		FROM analysis.vw_perfil_localidade_ranking_quantidade_osc AS a
		INNER JOIN analysis.vw_perfil_localidade_caracteristicas AS b
		ON a.localidade = b.localidade
		WHERE a.rank = (
			SELECT MIN(rank)
			FROM analysis.vw_perfil_localidade_ranking_quantidade_osc
			WHERE localidade::INTEGER > 99
		);
		
		SELECT INTO localidades_ultimo_colocado_quantidade_osc, valor_ultimo_colocado_quantidade_osc
			ARRAY_AGG(b.nome_localidade), MAX(a.quantidade_oscs)
		FROM analysis.vw_perfil_localidade_ranking_quantidade_osc AS a
		INNER JOIN analysis.vw_perfil_localidade_caracteristicas AS b
		ON a.localidade = b.localidade
		WHERE a.rank = (
			SELECT MAX(rank)
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
			SELECT MAX(rank)
			FROM analysis.vw_perfil_localidade_ranking_quantidade_osc
			WHERE localidade::INTEGER BETWEEN 0 AND 9
		);
		
		SELECT INTO localidades_ultimo_colocado_quantidade_osc, valor_ultimo_colocado_quantidade_osc
			ARRAY_AGG(b.nome_localidade), MAX(a.quantidade_oscs)
		FROM analysis.vw_perfil_localidade_ranking_quantidade_osc AS a
		INNER JOIN analysis.vw_perfil_localidade_caracteristicas AS b
		ON a.localidade = b.localidade
		WHERE a.rank = (
			SELECT MAX(rank)
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
			SELECT MAX(rank)
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
							WHERE localidade = 35::TEXT
						) AS a
					) AS values
			) AS a
		) AS b
	) AS c;

	IF evolucao_anual_json IS NOT NULL THEN
		resultado := resultado || evolucao_anual_json;
	END IF;

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
	ELSIF id_localidade BETWEEN 0 AND 9 THEN
		SELECT INTO maior_media_nacional_natureza_juridica, valor_maior_media_nacional_natureza_juridica 
			natureza_juridica, porcertagem_maior
		FROM analysis.vw_perfil_localidade_maior_natureza_juridica
		WHERE porcertagem_maior = (
			SELECT MAX(porcertagem_maior)
			FROM analysis.vw_perfil_localidade_maior_natureza_juridica
			WHERE localidade::INTEGER BETWEEN 0 AND 9
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
	END IF;
	
	FOR record IN
		SELECT dado AS tx_porcentagem_maior_media_nacional, valor AS nr_porcentagem_maior_media_nacional
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
					maior_media_nacional_natureza_juridica AS tx_porcentagem_maior_media_nacional,
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
	
	IF natureza_juridica_json IS NOT NULL THEN
		resultado := resultado || natureza_juridica_json;
	END IF;
	
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
					record.valor AS nr_repasse_media_nacional,
					tipo_repasse AS tx_maior_tipo_repasse,
					porcertagem_maior AS nr_porcentagem_maior_tipo_repasse,
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
	
	IF repasse_recursos_json IS NOT NULL THEN
		resultado := resultado || repasse_recursos_json;
	END IF;
	
	-- ==================== Área de Atuação ==================== --
	
	FOR record IN
		SELECT dado AS tx_porcentagem_maior_media_nacional, valor AS nr_porcentagem_maior_media_nacional
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
	
	IF area_atuacao_json IS NOT NULL THEN
		resultado := resultado || area_atuacao_json;
	END IF;
	
	-- ==================== Trabalhadores ==================== --
	
	FOR record IN
		SELECT dado AS tx_porcentagem_maior_media_nacional, valor AS nr_porcentagem_maior_media_nacional
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
					record.tx_porcentagem_maior_media_nacional,
					record.nr_porcentagem_maior_media_nacional,
					a.area_atuacao AS tx_porcentagem_maior,
					a.porcertagem_maior AS nr_porcentagem_maior,
					(
						SELECT json_agg(a)
						FROM (
							SELECT
								'Trabalhadores com vínculos' AS label,
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
				FROM analysis.vw_perfil_localidade_maior_area_atuacao AS a
				WHERE localidade = id_localidade::TEXT
			) AS b
		) AS c;
	END LOOP;
	
	IF trabalhadores_json IS NOT NULL THEN
		resultado := resultado || trabalhadores_json;
	END IF;
	
	/* ------------------------------ RESULTADO ------------------------------ */
	codigo := 200;
	mensagem := 'Perfil de localidade retornado.';

	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '%', SQLERRM;
		codigo := 400;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;

END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM analysis.obter_perfil_localidade(35);