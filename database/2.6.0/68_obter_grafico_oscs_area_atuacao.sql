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
			c.fontes AS fontes 
		FROM (
			SELECT 
				('{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG(b.dados)::TEXT, '\', '') || '}'), '""', '"'), '",', ','), '"}', '}'), '"{', '{'), '{'), '}') || '}')::JSONB AS dados, 
				(SELECT ARRAY(SELECT DISTINCT UNNEST(('{' || BTRIM(REPLACE(REPLACE(RTRIM(LTRIM(TRANSLATE(ARRAY_AGG(b.fontes::TEXT)::TEXT, '"\', ''), '{'), '}'), '},{', ','), ',,', ','), ',') || '}')::TEXT[]))) AS fontes
			FROM (
				SELECT 
					ARRAY_AGG('"' || COALESCE(a.area_atuacao::TEXT, 'Outras organizações da sociedade civil') || '": ' || a.quantidade::TEXT)::TEXT AS dados, 
					(SELECT ARRAY(SELECT DISTINCT UNNEST(('{' || BTRIM(REPLACE(REPLACE(RTRIM(LTRIM(TRANSLATE(ARRAY_AGG(a.fontes::TEXT)::TEXT, '"\', ''), '{'), '}'), '},{', ','), ',,', ','), ',') || '}')::TEXT[]))) AS fontes 
				FROM (
					SELECT 
						dc_area_atuacao.tx_nome_area_atuacao AS area_atuacao, 
						ROUND(((COUNT(*) / quantidade_oscs) * 100.)::NUMERIC, 2) AS quantidade, 
						ARRAY_AGG(DISTINCT(COALESCE(tb_area_atuacao.ft_area_atuacao, ''))) AS fontes 
					FROM osc.tb_dados_gerais 
					LEFT JOIN osc.tb_area_atuacao 
					ON tb_dados_gerais.id_osc = tb_area_atuacao.id_osc 
					LEFT JOIN syst.dc_area_atuacao 
					ON tb_area_atuacao.cd_area_atuacao = dc_area_atuacao.cd_area_atuacao 
					GROUP BY dc_area_atuacao.tx_nome_area_atuacao
				) AS a
			) AS b
		) AS c;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_grafico_oscs_area_atuacao();
