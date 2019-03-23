DROP FUNCTION IF EXISTS portal.obter_grafico_oscs_assistencia_social_tipo_servico() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_oscs_assistencia_social_tipo_servico() RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('{"label": "' || a.rotulo::TEXT || '", "value": ' || a.valor::TEXT || '}')::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), ',,', ','), '{'), '}') || '}]')::JSONB AS dados, 
			('{' || TRIM(ARRAY_AGG(DISTINCT TRIM(a.fontes, '"{}')) FILTER (WHERE (TRIM(a.fontes) = '') IS false)::TEXT, '"{}') || '}')::TEXT[] AS fontes 
		FROM (
			SELECT (
				CASE 
					WHEN (SELECT tb_cneas_mds.bloco_servico ILIKE '%(%') THEN SUBSTRING(SUBSTRING(tb_cneas_mds.bloco_servico FROM 5 FOR LENGTH(tb_cneas_mds.bloco_servico)) FROM 0 FOR (POSITION('(' IN tb_cneas_mds.bloco_servico) - 5)::INTEGER) 
					ELSE SUBSTRING(tb_cneas_mds.bloco_servico FROM 5 FOR LENGTH(tb_cneas_mds.bloco_servico)) 
				END
			) AS rotulo, 
			COUNT(*) AS valor,
			TRIM((
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', ''))
				FROM (
					SELECT DISTINCT UNNEST(
						ARRAY_CAT(
							'{"MDS/CNEAS"}'::TEXT[], 
							ARRAY_AGG(DISTINCT TRIM(tb_osc.ft_identificador_osc, '"{}')) FILTER (WHERE (TRIM(tb_osc.ft_identificador_osc) = '') IS false)
						)
					)
				) AS a
			)::TEXT, '{}') AS fontes 
			FROM osc.tb_osc 
			INNER JOIN graph.tb_cneas_mds 
			ON tb_osc.cd_identificador_osc::TEXT = REGEXP_REPLACE(tb_cneas_mds.cnpj, '[^0-9]', '', 'g') 
			WHERE tb_osc.bo_osc_ativa 
			AND tb_osc.id_osc <> 789809 
			GROUP BY rotulo
		) AS a;
END;

$$ LANGUAGE 'plpgsql';
