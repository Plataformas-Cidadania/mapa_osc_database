DROP FUNCTION IF EXISTS portal.obter_oscs_assistencia_social_tipo_servico() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_oscs_assistencia_social_tipo_servico() RETURNS TABLE (
	titulo TEXT, 
	tipo TEXT, 
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

DECLARE 
	quantidade_oscs DOUBLE PRECISION;

BEGIN 
	quantidade_oscs := (SELECT COUNT(*) FROM osc.tb_osc WHERE bo_osc_ativa IS true);
	
	RETURN QUERY 
		SELECT 
			'Distribuição de OSCs de assistência social por tipo de serviço prestado'::TEXT AS titulo, 
			'pizza'::TEXT AS tipo, 
			c.dados::JSONB AS dados, 
			c.fontes::TEXT[] AS fontes 
		FROM (
			SELECT 
				('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG(b.dados)::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '{'), '}') || '}]') AS dados, 
				'{"OSCIP/MJ"}'::TEXT[] AS fontes
			FROM (
				SELECT 
					ARRAY_AGG('{"rotulo": "' || a.rotulo::TEXT || '", "valor": ' || a.valor::TEXT || '}')::TEXT AS dados 
				FROM (
					SELECT 
						tb_cnes.ds_natureza_organizacao AS rotulo, 
						ROUND(((COUNT(*) / quantidade_oscs) * 100.)::NUMERIC, 2) AS valor
					FROM osc.tb_dados_gerais 
					LEFT JOIN graph.tb_cnes 
					ON tb_dados_gerais.cd_identificador_osc = tb_cnes.nu_cnpj_requerente 
					GROUP BY rotulo
				) AS a
			) AS b
		) AS c;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_oscs_assistencia_social_tipo_servico();
