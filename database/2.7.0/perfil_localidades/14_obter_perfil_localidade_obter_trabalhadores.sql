DROP FUNCTION IF EXISTS portal.obter_perfil_localidade_trabalhadores(INTEGER) CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_perfil_localidade_trabalhadores(id_localidade INTEGER) RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			('{' || RTRIM(LTRIM(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG(
				'{' ||
					'"nr_quantidade_trabalhadores": "' || a.nr_quantidade_trabalhadores::TEXT ||  '"' ||
				'}'
			)::TEXT, '\', '') || '}'), '{"{"', '{"'), '"}"}', '"}'), '{'), '}') || '}')::JSONB AS dados, 
			(
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()\"', '')) FROM (SELECT DISTINCT UNNEST(
					TRANSLATE(ARRAY_AGG(REPLACE(REPLACE(TRIM(TRANSLATE(a.fontes::TEXT, '"\{}', ''), ','), '","', ','), ',,', ','))::TEXT, '"', '')::TEXT[]
				)) AS a
			) AS fontes 
		FROM (
			SELECT 
				COALESCE(SUM(
					COALESCE(tb_relacoes_trabalho.nr_trabalhadores_vinculo, 0) + 
					COALESCE(tb_relacoes_trabalho.nr_trabalhadores_deficiencia, 0) + 
					COALESCE(tb_relacoes_trabalho.nr_trabalhadores_voluntarios, 0) + 
					COALESCE(tb_relacoes_trabalho_outra.nr_trabalhadores, 0)
				), 0) AS nr_quantidade_trabalhadores,
				(
					SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
						ARRAY_CAT(
							ARRAY_CAT(
								ARRAY_CAT(
									ARRAY_CAT(
										ARRAY_CAT(
											ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')), 
											ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
										),
										ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, ''))
									),
									ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho.ft_trabalhadores_deficiencia, ''))
								),
								ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho.ft_trabalhadores_voluntarios, ''))
							),
							ARRAY_AGG(DISTINCT COALESCE(tb_relacoes_trabalho_outra.ft_trabalhadores, ''))
						)
					)) AS a
				) AS fontes 
			FROM osc.tb_osc 
			LEFT JOIN osc.tb_relacoes_trabalho 
			ON tb_osc.id_osc = tb_relacoes_trabalho.id_osc 
			LEFT JOIN osc.tb_relacoes_trabalho_outra 
			ON tb_osc.id_osc = tb_relacoes_trabalho_outra.id_osc 
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

SELECT * FROM portal.obter_perfil_localidade_trabalhadores(35);
