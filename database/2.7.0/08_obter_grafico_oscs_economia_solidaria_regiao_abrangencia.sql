DROP FUNCTION IF EXISTS portal.obter_grafico_oscs_economia_solidaria_regiao_abrangencia(INTEGER) CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_oscs_economia_solidaria_regiao_abrangencia(tipo_serie INTEGER) RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]	
) AS $$ 

BEGIN 
	IF tipo_serie = 1 THEN 
		RETURN QUERY 
			SELECT 
				('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG(b.dados)::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), ',,', ','), '{'), '}') || '}]')::JSONB AS dados, 
				('{' || TRIM(REPLACE(TRANSLATE((
					SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) 
					FROM (
						SELECT DISTINCT UNNEST( 
							('{' || TRIM(REPLACE(TRANSLATE(ARRAY_AGG(b.fontes)::TEXT, '\"', ''), ',,', ','), ',{}') || '}')::TEXT[] 
						)
					) AS a
				)::TEXT, '\"', ''), ',,', ','), ',{}') || '}')::TEXT[] AS fontes
			FROM (
				SELECT 
					'{"key": "' || a.rotulo_1 || '", "values": ' || '[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('{"label": "' || a.rotulo_2::TEXT || '", "value": ' || a.valor::TEXT || '}')::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), ',,', ','), '{'), '}') || '}]}' AS dados, 
					TRIM(ARRAY_AGG(DISTINCT TRIM(a.fontes)) FILTER (WHERE (TRIM(a.fontes) = '') IS false)::TEXT, '{}') AS fontes
				FROM (
					SELECT 
						a.rotulo_1, 
						a.rotulo_2, 
						SUM(a.valor) AS valor, 
						TRIM(ARRAY_AGG(DISTINCT TRIM(a.fontes)) FILTER (WHERE (TRIM(a.fontes) = '') IS false)::TEXT, '{}') AS fontes
					FROM (
						SELECT * FROM (
							SELECT 
								COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação') AS rotulo_1, 
								COALESCE(tb_senaes.abr_13, 'Sem informação') AS rotulo_2, 
								COUNT(*) AS valor, 
								(
									'SENAES/MTE,' || 
									TRIM(ARRAY_AGG(DISTINCT TRIM(tb_localizacao.ft_municipio)) FILTER (WHERE (TRIM(tb_localizacao.ft_municipio) = '') IS false)::TEXT, '{}') || ',' || 
									TRIM(ARRAY_AGG(DISTINCT TRIM(tb_osc.ft_identificador_osc)) FILTER (WHERE (TRIM(tb_osc.ft_identificador_osc) = '') IS false)::TEXT, '{}')
								) AS fontes 
							FROM osc.tb_osc 
							INNER JOIN graph.tb_senaes 
							ON tb_osc.cd_identificador_osc = TRANSLATE(tb_senaes.cnpj_8, '-', '')::NUMERIC 
							LEFT JOIN osc.tb_localizacao 
							ON tb_osc.id_osc = tb_localizacao.id_osc 
							LEFT JOIN spat.ed_regiao 
							ON ed_regiao.edre_cd_regiao::TEXT = SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1) 
							WHERE tb_osc.id_osc <> 789809 
							GROUP BY rotulo_1, rotulo_2 
							ORDER BY rotulo_1, rotulo_2
						) AS a 
						UNION 
						SELECT 'Centro Oeste'::CHARACTER VARYING, 'Estadual e/ou inter-estadual'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Centro Oeste'::CHARACTER VARYING, 'Municipal e/ou inter-municipal'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Centro Oeste'::CHARACTER VARYING, 'Nacional'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Nordeste'::CHARACTER VARYING, 'Estadual e/ou inter-estadual'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Nordeste'::CHARACTER VARYING, 'Municipal e/ou inter-municipal'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Nordeste'::CHARACTER VARYING, 'Nacional'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Norte'::CHARACTER VARYING, 'Estadual e/ou inter-estadual'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Norte'::CHARACTER VARYING, 'Municipal e/ou inter-municipal'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Norte'::CHARACTER VARYING, 'Nacional'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Sudeste'::CHARACTER VARYING, 'Estadual e/ou inter-estadual'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Sudeste'::CHARACTER VARYING, 'Municipal e/ou inter-municipal'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Sudeste'::CHARACTER VARYING, 'Nacional'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Sul'::CHARACTER VARYING, 'Estadual e/ou inter-estadual'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Sul'::CHARACTER VARYING, 'Municipal e/ou inter-municipal'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Sul'::CHARACTER VARYING, 'Nacional'::TEXT, 0::BIGINT, null::TEXT
					) AS a 
					GROUP BY rotulo_1, rotulo_2 
					ORDER BY rotulo_1, rotulo_2
				) AS a 
				GROUP BY a.rotulo_1
			) AS b;

	ELSIF tipo_serie = 2 THEN 
		RETURN QUERY 
			SELECT 
				('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG(b.dados)::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), ',,', ','), '{'), '}') || '}]')::JSONB AS dados, 
				('{' || TRIM(REPLACE(TRANSLATE((
					SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) 
					FROM (
						SELECT DISTINCT UNNEST( 
							('{' || TRIM(REPLACE(TRANSLATE(ARRAY_AGG(b.fontes)::TEXT, '\"', ''), ',,', ','), ',{}') || '}')::TEXT[] 
						)
					) AS a
				)::TEXT, '\"', ''), ',,', ','), ',{}') || '}')::TEXT[] AS fontes
			FROM (
				SELECT 
					'{"key": "' || a.rotulo_2 || '", "values": ' || '[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('{"label": "' || a.rotulo_1::TEXT || '", "value": ' || a.valor::TEXT || '}')::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), ',,', ','), '{'), '}') || '}]}' AS dados, 
					TRIM(ARRAY_AGG(DISTINCT TRIM(a.fontes)) FILTER (WHERE (TRIM(a.fontes) = '') IS false)::TEXT, '{}') AS fontes
				FROM (
					SELECT 
						a.rotulo_1, 
						a.rotulo_2, 
						SUM(a.valor) AS valor, 
						TRIM(ARRAY_AGG(DISTINCT TRIM(a.fontes)) FILTER (WHERE (TRIM(a.fontes) = '') IS false)::TEXT, '{}') AS fontes
					FROM (
						SELECT * FROM (
							SELECT 
								COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação') AS rotulo_1, 
								COALESCE(tb_senaes.abr_13, 'Sem informação') AS rotulo_2, 
								COUNT(*) AS valor, 
								(
									'SENAES/MTE,' || 
									TRIM(ARRAY_AGG(DISTINCT TRIM(tb_localizacao.ft_municipio)) FILTER (WHERE (TRIM(tb_localizacao.ft_municipio) = '') IS false)::TEXT, '{}') || ',' || 
									TRIM(ARRAY_AGG(DISTINCT TRIM(tb_osc.ft_identificador_osc)) FILTER (WHERE (TRIM(tb_osc.ft_identificador_osc) = '') IS false)::TEXT, '{}')
								) AS fontes 
							FROM osc.tb_osc 
							INNER JOIN graph.tb_senaes 
							ON tb_osc.cd_identificador_osc = TRANSLATE(tb_senaes.cnpj_8, '-', '')::NUMERIC 
							LEFT JOIN osc.tb_localizacao 
							ON tb_osc.id_osc = tb_localizacao.id_osc 
							LEFT JOIN spat.ed_regiao 
							ON ed_regiao.edre_cd_regiao::TEXT = SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1) 
							WHERE tb_osc.id_osc <> 789809 
							GROUP BY rotulo_1, rotulo_2 
							ORDER BY rotulo_1, rotulo_2
						) AS a 
						UNION 
						SELECT 'Centro Oeste'::CHARACTER VARYING, 'Estadual e/ou inter-estadual'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Centro Oeste'::CHARACTER VARYING, 'Municipal e/ou inter-municipal'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Centro Oeste'::CHARACTER VARYING, 'Nacional'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Nordeste'::CHARACTER VARYING, 'Estadual e/ou inter-estadual'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Nordeste'::CHARACTER VARYING, 'Municipal e/ou inter-municipal'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Nordeste'::CHARACTER VARYING, 'Nacional'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Norte'::CHARACTER VARYING, 'Estadual e/ou inter-estadual'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Norte'::CHARACTER VARYING, 'Municipal e/ou inter-municipal'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Norte'::CHARACTER VARYING, 'Nacional'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Sudeste'::CHARACTER VARYING, 'Estadual e/ou inter-estadual'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Sudeste'::CHARACTER VARYING, 'Municipal e/ou inter-municipal'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Sudeste'::CHARACTER VARYING, 'Nacional'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Sul'::CHARACTER VARYING, 'Estadual e/ou inter-estadual'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Sul'::CHARACTER VARYING, 'Municipal e/ou inter-municipal'::TEXT, 0::BIGINT, null::TEXT 
						UNION 
						SELECT 'Sul'::CHARACTER VARYING, 'Nacional'::TEXT, 0::BIGINT, null::TEXT
					) AS a 
					GROUP BY rotulo_1, rotulo_2 
					ORDER BY rotulo_2, rotulo_1
				) AS a 
				GROUP BY a.rotulo_2
			) AS b;
	END IF;
END;

$$ LANGUAGE 'plpgsql';
