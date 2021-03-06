DROP FUNCTION IF EXISTS portal.obter_grafico_oscs_saude_tipo_estabelecimento() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_oscs_saude_tipo_estabelecimento() RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

DECLARE 
	tipos_mais_comuns TEXT[];
	quantidade_oscs DOUBLE PRECISION;

BEGIN 
	quantidade_oscs := (
		SELECT COUNT(*) 
		FROM osc.tb_osc 
		INNER JOIN graph.tb_cnes 
		ON tb_osc.cd_identificador_osc = TRANSLATE(tb_cnes.nu_cnpj_requerente, '-', '')::NUMERIC 
		WHERE bo_osc_ativa IS true
	);

	SELECT INTO tipos_mais_comuns ARRAY_AGG(a.tipo_estabelecimento) FROM (
			SELECT tb_cnes.ds_tipo_unidade AS tipo_estabelecimento 
				FROM osc.tb_osc 
				INNER JOIN graph.tb_cnes 
				ON tb_osc.cd_identificador_osc = TRANSLATE(tb_cnes.nu_cnpj_requerente, '-', '')::NUMERIC 
				WHERE tb_osc.bo_osc_ativa 
				AND tb_cnes.ds_tipo_unidade IS NOT NULL 
				GROUP BY tipo_estabelecimento 
				ORDER BY COUNT(*) DESC
				LIMIT 6
		) AS a;

	RETURN QUERY 
		SELECT 
			('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('{"label": "' || a.rotulo::TEXT || '", "value": ' || a.valor::TEXT || '}')::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), ',,', ','), '{'), '}') || '}]')::JSONB AS dados, 
			('{' || TRIM(REPLACE(TRANSLATE((
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) 
				FROM (
					SELECT DISTINCT UNNEST( 
						('{' || TRIM(REPLACE(TRANSLATE(ARRAY_AGG(a.fontes)::TEXT, '\"', ''), ',,', ','), ',{}') || '}')::TEXT[] 
					)
				) AS a
			)::TEXT, '\"', ''), ',,', ','), ',{}') || '}')::TEXT[] AS fontes
		FROM (
			SELECT 
				CASE 
					WHEN tb_cnes.ds_tipo_unidade IS NULL THEN 'Sem informação' 
					WHEN tb_cnes.ds_tipo_unidade = ANY(tipos_mais_comuns) THEN tb_cnes.ds_tipo_unidade
					ELSE 'Outros'
				END AS rotulo, 
				COUNT(*) AS valor,
				(
					'CNES/MS,' || 
					TRIM(ARRAY_AGG(DISTINCT TRIM(tb_osc.ft_identificador_osc)) FILTER (WHERE (TRIM(tb_osc.ft_identificador_osc) = '') IS false)::TEXT, '{}')
				) AS fontes 
			FROM osc.tb_osc 
			INNER JOIN graph.tb_cnes 
			ON tb_osc.cd_identificador_osc = TRANSLATE(tb_cnes.nu_cnpj_requerente, '-', '')::NUMERIC 
			WHERE tb_osc.bo_osc_ativa 
			AND tb_osc.id_osc <> 789809 
			GROUP BY rotulo
		) AS a;
END;

$$ LANGUAGE 'plpgsql';
