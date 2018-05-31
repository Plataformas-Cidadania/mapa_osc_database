DROP FUNCTION IF EXISTS portal.obter_oscs_saude_tipo_estabelecimento() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_oscs_saude_tipo_estabelecimento() RETURNS TABLE (
	titulo TEXT, 
	tipo TEXT, 
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
			'Distribuição de OSCs de saúde por tipo de estabelecimento de saúde'::TEXT AS titulo, 
			'pizza'::TEXT AS tipo, 
			b.dados::JSONB AS dados, 
			b.fontes::TEXT[] AS fontes 
		FROM (
			SELECT 
				'[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('{"rotulo": "' || a.rotulo::TEXT || '", "valor": ' || a.valor::TEXT || '}')::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '{'), '}') || '}]' AS dados, 
				'{CNES/MS}'::TEXT[] AS fontes 
			FROM (
				SELECT 
					COALESCE(tb_cnes.ds_tipo_unidade, 'Sem informação') AS rotulo, 
					ROUND(((COUNT(*) / quantidade_oscs) * 100.)::NUMERIC, 2) AS valor 
				FROM osc.tb_osc 
				INNER JOIN graph.tb_cnes 
				ON tb_osc.cd_identificador_osc = TRANSLATE(tb_cnes.nu_cnpj_requerente, '-', '')::NUMERIC 
				WHERE tb_osc.bo_osc_ativa 
				GROUP BY rotulo
			) AS a
		) AS b;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_oscs_saude_tipo_estabelecimento();
