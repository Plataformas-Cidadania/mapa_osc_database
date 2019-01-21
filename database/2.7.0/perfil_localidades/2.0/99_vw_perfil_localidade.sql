DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade AS 

SELECT (
		SELECT json_agg(row_to_json(a))
		FROM (
			SELECT
				quantidade_oscs,
				quantidade_trabalhadores,
                quantidade_recursos,
				quantidade_projetos,
				fontes
			FROM analysis.vw_perfil_localidade_caracteristicas
			WHERE localidade = '35'
		) AS a
	) AS caracteristicas,
	(
		SELECT json_agg(row_to_json(a))
		FROM (
			SELECT
				fundacao,
				quantidade_oscs,
				fontes
			FROM analysis.vw_perfil_localidade_evolucao_anual
			WHERE localidade = '35'
		) AS a
	) AS evolucao_anual,
	(
		SELECT json_agg(row_to_json(a))
		FROM (
			SELECT
				quantidade_oscs,
				natureza_juridica,
				quantidade_oscs,
				fontes
			FROM analysis.vw_perfil_localidade_natureza_juridica
			WHERE localidade = '35'
		) AS a
	) AS natureza_juridica,
	(
		SELECT json_agg(row_to_json(a))
		FROM (
			SELECT
				fonte_recursos,
				ano,
				valor_recursos,
				fontes
			FROM analysis.vw_perfil_localidade_repasse_recursos
			WHERE localidade = '35'
		) AS a
	) AS repasse_recursos,
	(
		SELECT json_agg(row_to_json(a))
		FROM (
			SELECT
				area_atuacao,
				quantidade_oscs,
				fontes
			FROM analysis.vw_perfil_localidade_area_atuacao
			WHERE localidade = '35'
		) AS a
	) AS area_atuacao,
	(
		SELECT json_agg(row_to_json(a))
		FROM (
			SELECT
				vinculos,
				deficiencia,
				voluntarios,
				total,
				fontes
			FROM analysis.vw_perfil_localidade_trabalhadores
			WHERE localidade = '35'
		) AS a
	) AS trabalhadores
;

