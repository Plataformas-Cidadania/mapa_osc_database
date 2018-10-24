DROP FUNCTION IF EXISTS portal.obter_grafico_distribuicao_osc_empregados_regiao(INTEGER) CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_distribuicao_osc_empregados_regiao(tipo_serie INTEGER) RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

BEGIN 
	IF tipo_serie = 1 THEN 
		RETURN QUERY 
			SELECT 
				('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG(b.dados)::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '{'), '}') || '}]')::JSONB AS dados, 
				(
					SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()\"', '')) FROM (SELECT DISTINCT UNNEST(
						TRANSLATE(ARRAY_AGG(REPLACE(TRIM(TRANSLATE(b.fontes::TEXT, '"\{}', ''), ','), '","', ','))::TEXT, '"', '')::TEXT[]
					)) AS a
				) AS fontes 
			FROM (
				SELECT 
					'{"key": "' || a.rotulo_1 || '", "values": ' || '[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('{"label": "' || a.rotulo_2::TEXT || '", "value": ' || a.valor::TEXT || '}')::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '{'), '}') || '}]}' AS dados, 
					(
						SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()\"', '')) FROM (SELECT DISTINCT UNNEST(
							TRANSLATE(ARRAY_AGG(REPLACE(REPLACE(TRIM(TRANSLATE(a.fontes::TEXT, '"\{}', ''), ','), '","', ','), ',,', ','))::TEXT, '"', '')::TEXT[]
						)) AS a
					) AS fontes 
				FROM (
					SELECT 
						a.rotulo_1, 
						a.rotulo_2, 
						SUM(a.valor) AS valor, 
						ARRAY_AGG(a.fontes::TEXT) FILTER (WHERE a.fontes IS NOT null) AS fontes 
					FROM (
						SELECT * FROM (
							SELECT 
								COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação') AS rotulo_1, 
								(
									CASE 
										WHEN (tb_relacoes_trabalho.nr_trabalhadores_vinculo = 0) THEN '0' 
										WHEN (tb_relacoes_trabalho.nr_trabalhadores_vinculo BETWEEN 1 AND 4) THEN '1 a 4' 
										WHEN (tb_relacoes_trabalho.nr_trabalhadores_vinculo BETWEEN 5 AND 19) THEN '5 a 19' 
										WHEN (tb_relacoes_trabalho.nr_trabalhadores_vinculo BETWEEN 20 AND 99) THEN '20 a 99' 
										WHEN (tb_relacoes_trabalho.nr_trabalhadores_vinculo >= 100) THEN '100 ou mais' 
										ELSE '0'
									END
								) AS rotulo_2, 
								COUNT(*) AS valor, 
								(
									SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
										ARRAY_CAT(
											ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, ''), '${ETL}', '')), 
											ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_osc.ft_identificador_osc, ''), '${ETL}', ''))
										)
									)) AS a
								) AS fontes 
							FROM osc.tb_osc 
							LEFT JOIN osc.tb_dados_gerais 
							ON tb_osc.id_osc = tb_dados_gerais.id_osc 
							LEFT JOIN osc.tb_relacoes_trabalho 
							ON tb_dados_gerais.id_osc = tb_relacoes_trabalho.id_osc 
							LEFT JOIN osc.tb_localizacao 
							ON tb_dados_gerais.id_osc = tb_localizacao.id_osc 
							LEFT JOIN spat.ed_regiao 
							ON (SELECT SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1))::NUMERIC(1, 0) = ed_regiao.edre_cd_regiao 
							WHERE tb_osc.bo_osc_ativa 
							AND tb_osc.id_osc <> 789809 
							GROUP BY rotulo_1, rotulo_2 
							ORDER BY rotulo_1, rotulo_2 
						) AS a 
						UNION 
						SELECT 'Norte'::TEXT AS rotulo_1, '0'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Norte'::TEXT AS rotulo_1, '1 a 4'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Norte'::TEXT AS rotulo_1, '5 a 19'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Norte'::TEXT AS rotulo_1, '20 a 99'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Norte'::TEXT AS rotulo_1, '100 ou mais'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Nordeste'::TEXT AS rotulo_1, '0'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Nordeste'::TEXT AS rotulo_1, '1 a 4'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Nordeste'::TEXT AS rotulo_1, '5 a 19'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Nordeste'::TEXT AS rotulo_1, '20 a 99'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Nordeste'::TEXT AS rotulo_1, '100 ou mais'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Centro Oeste'::TEXT AS rotulo_1, '0'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Centro Oeste'::TEXT AS rotulo_1, '1 a 4'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Centro Oeste'::TEXT AS rotulo_1, '5 a 19'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Centro Oeste'::TEXT AS rotulo_1, '20 a 99'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Centro Oeste'::TEXT AS rotulo_1, '100 ou mais'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sudeste'::TEXT AS rotulo_1, '0'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sudeste'::TEXT AS rotulo_1, '1 a 4'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sudeste'::TEXT AS rotulo_1, '5 a 19'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sudeste'::TEXT AS rotulo_1, '20 a 99'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sudeste'::TEXT AS rotulo_1, '100 ou mais'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sul'::TEXT AS rotulo_1, '0'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sul'::TEXT AS rotulo_1, '1 a 4'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sul'::TEXT AS rotulo_1, '5 a 19'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sul'::TEXT AS rotulo_1, '20 a 99'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sul'::TEXT AS rotulo_1, '100 ou mais'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sem informação'::TEXT AS rotulo_1, '0'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sem informação'::TEXT AS rotulo_1, '1 a 4'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sem informação'::TEXT AS rotulo_1, '5 a 19'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sem informação'::TEXT AS rotulo_1, '20 a 99'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sem informação'::TEXT AS rotulo_1, '100 ou mais'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes
					) AS a 
					GROUP BY rotulo_1, rotulo_2 
					ORDER BY rotulo_1, rotulo_2
				) AS a 
				GROUP BY a.rotulo_1
			) AS b;

	ELSIF tipo_serie = 2 THEN 
		RETURN QUERY 
			SELECT 
				('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG(b.dados)::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '{'), '}') || '}]')::JSONB AS dados, 
				(
					SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()\"', '')) FROM (SELECT DISTINCT UNNEST(
						TRANSLATE(ARRAY_AGG(REPLACE(TRIM(TRANSLATE(b.fontes::TEXT, '"\{}', ''), ','), '","', ','))::TEXT, '"', '')::TEXT[]
					)) AS a
				) AS fontes 
			FROM (
				SELECT 
					'{"key": "' || a.rotulo_2 || '", "values": ' || '[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('{"label": "' || a.rotulo_1::TEXT || '", "value": ' || a.valor::TEXT || '}')::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '{'), '}') || '}]}' AS dados, 
					(
						SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()\"', '')) FROM (SELECT DISTINCT UNNEST(
							TRANSLATE(ARRAY_AGG(REPLACE(REPLACE(TRIM(TRANSLATE(a.fontes::TEXT, '"\{}', ''), ','), '","', ','), ',,', ','))::TEXT, '"', '')::TEXT[]
						)) AS a
					) AS fontes 
				FROM (
					SELECT 
						a.rotulo_1, 
						a.rotulo_2, 
						SUM(a.valor) AS valor, 
						ARRAY_AGG(a.fontes::TEXT) FILTER (WHERE a.fontes IS NOT null) AS fontes 
					FROM (
						SELECT * FROM (
							SELECT 
								COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação') AS rotulo_1, 
								(
									CASE 
										WHEN (tb_relacoes_trabalho.nr_trabalhadores_vinculo = 0) THEN '0' 
										WHEN (tb_relacoes_trabalho.nr_trabalhadores_vinculo BETWEEN 1 AND 4) THEN '1 a 4' 
										WHEN (tb_relacoes_trabalho.nr_trabalhadores_vinculo BETWEEN 5 AND 19) THEN '5 a 19' 
										WHEN (tb_relacoes_trabalho.nr_trabalhadores_vinculo BETWEEN 20 AND 99) THEN '20 a 99' 
										WHEN (tb_relacoes_trabalho.nr_trabalhadores_vinculo >= 100) THEN '100 ou mais' 
										ELSE '0'
									END
								) AS rotulo_2, 
								COUNT(*) AS valor, 
								(
									SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
										ARRAY_CAT(
											ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, ''), '${ETL}', '')), 
											ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_osc.ft_identificador_osc, ''), '${ETL}', ''))
										)
									)) AS a
								) AS fontes 
							FROM osc.tb_osc 
							LEFT JOIN osc.tb_dados_gerais 
							ON tb_osc.id_osc = tb_dados_gerais.id_osc 
							LEFT JOIN osc.tb_relacoes_trabalho 
							ON tb_dados_gerais.id_osc = tb_relacoes_trabalho.id_osc 
							LEFT JOIN osc.tb_localizacao 
							ON tb_dados_gerais.id_osc = tb_localizacao.id_osc 
							LEFT JOIN spat.ed_regiao 
							ON (SELECT SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1))::NUMERIC(1, 0) = ed_regiao.edre_cd_regiao 
							WHERE tb_osc.bo_osc_ativa 
							AND tb_osc.id_osc <> 789809 
							GROUP BY rotulo_1, rotulo_2 
							ORDER BY rotulo_1, rotulo_2 
						) AS a 
						UNION 
						SELECT 'Norte'::TEXT AS rotulo_1, '0'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Norte'::TEXT AS rotulo_1, '1 a 4'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Norte'::TEXT AS rotulo_1, '5 a 19'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Norte'::TEXT AS rotulo_1, '20 a 99'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Norte'::TEXT AS rotulo_1, '100 ou mais'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Nordeste'::TEXT AS rotulo_1, '0'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Nordeste'::TEXT AS rotulo_1, '1 a 4'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Nordeste'::TEXT AS rotulo_1, '5 a 19'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Nordeste'::TEXT AS rotulo_1, '20 a 99'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Nordeste'::TEXT AS rotulo_1, '100 ou mais'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Centro Oeste'::TEXT AS rotulo_1, '0'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Centro Oeste'::TEXT AS rotulo_1, '1 a 4'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Centro Oeste'::TEXT AS rotulo_1, '5 a 19'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Centro Oeste'::TEXT AS rotulo_1, '20 a 99'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Centro Oeste'::TEXT AS rotulo_1, '100 ou mais'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sudeste'::TEXT AS rotulo_1, '0'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sudeste'::TEXT AS rotulo_1, '1 a 4'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sudeste'::TEXT AS rotulo_1, '5 a 19'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sudeste'::TEXT AS rotulo_1, '20 a 99'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sudeste'::TEXT AS rotulo_1, '100 ou mais'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sul'::TEXT AS rotulo_1, '0'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sul'::TEXT AS rotulo_1, '1 a 4'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sul'::TEXT AS rotulo_1, '5 a 19'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sul'::TEXT AS rotulo_1, '20 a 99'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sul'::TEXT AS rotulo_1, '100 ou mais'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sem informação'::TEXT AS rotulo_1, '0'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sem informação'::TEXT AS rotulo_1, '1 a 4'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sem informação'::TEXT AS rotulo_1, '5 a 19'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sem informação'::TEXT AS rotulo_1, '20 a 99'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes 
						UNION 
						SELECT 'Sem informação'::TEXT AS rotulo_1, '100 ou mais'::TEXT AS rotulo_2, 0::BIGINT AS valor, null::TEXT[] AS fontes
					) AS a 
					GROUP BY rotulo_1, rotulo_2 
					ORDER BY rotulo_1, rotulo_2
				) AS a 
				GROUP BY a.rotulo_2
			) AS b;
	END IF;
END;

$$ LANGUAGE 'plpgsql';
