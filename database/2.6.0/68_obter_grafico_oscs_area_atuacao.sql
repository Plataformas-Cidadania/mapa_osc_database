DROP FUNCTION IF EXISTS portal.obter_grafico_oscs_area_atuacao() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_oscs_area_atuacao() RETURNS TABLE (
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
			'Distribuição de OSCs por área de atuação'::TEXT AS titulo, 
			'pizza'::TEXT AS tipo, 
			c.dados::JSONB AS dados, 
			c.fontes::TEXT[] AS fontes 
		FROM (
			SELECT 
				'[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG(b.dados)::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '{'), '}') || '}]' AS dados, 
				REPLACE(REPLACE(TRANSLATE((ARRAY_AGG(DISTINCT REPLACE(TRIM(TRANSLATE(b.fontes::TEXT, '"\{}', ''), ','), '","', ',')))::TEXT, '"', ''), '{,', '{'), ',}', '}')::TEXT[] AS fontes 
			FROM (
				SELECT 
					ARRAY_AGG('{"rotulo": "' || COALESCE(a.rotulo::TEXT, 'Outras organizações da sociedade civil') || '", "valor": ' || a.valor::TEXT || '}')::TEXT AS dados, 
					REPLACE(REPLACE(TRANSLATE((ARRAY_AGG(DISTINCT REPLACE(TRIM(TRANSLATE(a.fontes::TEXT, '"\{}', ''), ','), '","', ',')))::TEXT, '"', ''), '{,', '{'), ',}', '}')::TEXT[] AS fontes 
				FROM (
					SELECT 
						COALESCE(dc_area_atuacao.tx_nome_area_atuacao, 'Sem informação') AS rotulo, 
						ROUND(((COUNT(*) / quantidade_oscs) * 100.)::NUMERIC, 2) AS valor, 
						ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_area_atuacao.ft_area_atuacao, ''), '${ETL}', '')) AS fontes 
					FROM osc.tb_osc 
					LEFT JOIN osc.tb_dados_gerais 
					ON tb_osc.id_osc = tb_dados_gerais.id_osc 
					LEFT JOIN osc.tb_area_atuacao 
					ON tb_dados_gerais.id_osc = tb_area_atuacao.id_osc 
					LEFT JOIN syst.dc_area_atuacao 
					ON tb_area_atuacao.cd_area_atuacao = dc_area_atuacao.cd_area_atuacao 
					WHERE tb_osc.bo_osc_ativa 
					GROUP BY rotulo
				) AS a
			) AS b
		) AS c;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_grafico_oscs_area_atuacao();

