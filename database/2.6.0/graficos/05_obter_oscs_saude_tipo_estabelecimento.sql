DROP FUNCTION IF EXISTS portal.obter_oscs_saude_tipo_estabelecimento() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_oscs_saude_tipo_estabelecimento() RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

DECLARE 
	quantidade_oscs DOUBLE PRECISION;

BEGIN 
	quantidade_oscs := (
		SELECT COUNT(*) 
		FROM osc.tb_osc 
		INNER JOIN graph.tb_cnes 
		ON tb_osc.cd_identificador_osc = TRANSLATE(tb_cnes.nu_cnpj_requerente, '-', '')::NUMERIC 
		WHERE bo_osc_ativa IS true
	);

	RETURN QUERY 
		SELECT 
			('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('{"rotulo": "' || a.rotulo::TEXT || '", "valor": ' || a.valor::TEXT || '}')::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '{'), '}') || '}]')::JSONB AS dados, 
			(
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()\"', '')) FROM (SELECT DISTINCT UNNEST(
					TRANSLATE(ARRAY_AGG(REPLACE(REPLACE(TRIM(TRANSLATE(a.fontes::TEXT, '"\{}', ''), ','), '","', ','), ',,', ','))::TEXT, '"', '')::TEXT[]
				)) AS a
			) AS fontes 
		FROM (
			SELECT 
				COALESCE(tb_cnes.ds_tipo_unidade, 'Sem informação') AS rotulo, 
				ROUND(((COUNT(*) / quantidade_oscs) * 100.)::NUMERIC, 2) AS valor, 
				(
					SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
						ARRAY_CAT(
							'{"CNES/MS"}'::TEXT[], 
							ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_osc.ft_identificador_osc, ''), '${ETL}', ''))
						)
					)) AS a
				) AS fontes 
			FROM osc.tb_osc 
			INNER JOIN graph.tb_cnes 
			ON tb_osc.cd_identificador_osc = TRANSLATE(tb_cnes.nu_cnpj_requerente, '-', '')::NUMERIC 
			WHERE tb_osc.bo_osc_ativa 
			GROUP BY rotulo
		) AS a;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_oscs_saude_tipo_estabelecimento();
