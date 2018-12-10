DROP FUNCTION IF EXISTS portal.obter_perfil_localidade_caracteristicas(INTEGER) CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_perfil_localidade_caracteristicas(id_localidade INTEGER) RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			('{' || RTRIM(LTRIM(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG(
				'{' ||
					'"nr_quantidade_oscs": "' || a.nr_quantidade_oscs::TEXT || '", ' || 
					'"nr_quantidade_trabalhadores": "' || a.nr_quantidade_trabalhadores::TEXT ||  '", ' || 
					'"nr_quantidade_recursos": "' || a.nr_quantidade_recursos::TEXT || '", ' || 
					'"nr_quantidade_projetos": "' || a.nr_quantidade_projetos::TEXT ||  '"' || 
				'}'
			)::TEXT, '\', '') || '}'), '{"{"', '{"'), '"}"}', '"}'), '{'), '}') || '}')::JSONB AS dados, 
			(
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()\"', '')) FROM (SELECT DISTINCT UNNEST(
					TRANSLATE(ARRAY_AGG(REPLACE(REPLACE(TRIM(TRANSLATE(a.fontes::TEXT, '"\{}', ''), ','), '","', ','), ',,', ','))::TEXT, '"', '')::TEXT[]
				)) AS a
			) AS fontes 
		FROM (
			SELECT 
				COUNT(tb_osc) AS nr_quantidade_oscs, 
				SUM(
					COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) + 
					COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) + 
					COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0) + 
					COALESCE(tb_relacoes_trabalho_outra.nr_trabalhadores, 0)
				) AS nr_quantidade_trabalhadores, 
				SUM(
					COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0) + 
					COALESCE(tb_recursos_outro_osc.nr_valor_recursos_outro_osc, 0)
				) AS nr_quantidade_recursos, 
				COUNT(tb_projeto) AS nr_quantidade_projetos, 
				(
					SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
						ARRAY_CAT(
							ARRAY_CAT(
								ARRAY_CAT(
									ARRAY_CAT(
										ARRAY_CAT(
											ARRAY_CAT(
												ARRAY_CAT(
													ARRAY_CAT(
														ARRAY_CAT(
															ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_identificador_osc, '')), 
															ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, ''))
														),
														ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, ''))
													),
													ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho.ft_trabalhadores_deficiencia, ''))
												),
												ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho.ft_trabalhadores_voluntarios, ''))
											),
											ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho_outra.ft_trabalhadores, ''))
										),
										ARRAY_AGG(DISTINCT COALESCE(tb_recursos_osc.ft_valor_recursos_osc, ''))
									),
									ARRAY_AGG(DISTINCT COALESCE(tb_recursos_outro_osc.ft_valor_recursos_outro_osc, ''))
								),
								ARRAY_AGG(DISTINCT COALESCE(tb_projeto.ft_nome_projeto, ''))
							),
							ARRAY_AGG(DISTINCT COALESCE(tb_projeto.ft_identificador_projeto_externo, ''))
						)
					)) AS a
				) AS fontes 
			FROM osc.tb_osc 
			LEFT JOIN osc.tb_relacoes_trabalho 
			ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc 
			LEFT JOIN osc.tb_relacoes_trabalho_outra 
			ON tb_osc.id_osc = tb_relacoes_trabalho_outra.id_osc 
			LEFT JOIN osc.tb_recursos_osc 
			ON tb_osc.id_osc = tb_recursos_osc.id_osc 
			LEFT JOIN osc.tb_recursos_outro_osc 
			ON tb_osc.id_osc = tb_recursos_outro_osc.id_osc 
			LEFT JOIN osc.tb_projeto 
			ON tb_osc.id_osc = tb_projeto.id_osc 
			LEFT JOIN osc.tb_localizacao 
			ON tb_osc.id_osc = tb_localizacao.id_osc 
			LEFT JOIN spat.ed_regiao 
			ON (SELECT SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1))::NUMERIC(1, 0) = ed_regiao.edre_cd_regiao 
			WHERE tb_osc.bo_osc_ativa 
			AND tb_osc.id_osc <> 789809 
			AND (
				SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1) = id_localidade::TEXT 
				OR 
				SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2) = id_localidade::TEXT 
				OR 
				tb_localizacao.cd_municipio = id_localidade 
			)
		) AS a;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_perfil_localidade_caracteristicas(11);
