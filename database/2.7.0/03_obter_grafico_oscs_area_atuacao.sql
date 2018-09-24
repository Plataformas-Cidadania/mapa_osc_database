DROP FUNCTION IF EXISTS portal.obter_grafico_oscs_area_atuacao() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_oscs_area_atuacao() RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

DECLARE 
	quantidade_oscs DOUBLE PRECISION;

BEGIN 
	quantidade_oscs := (SELECT COUNT(*) FROM osc.tb_osc WHERE bo_osc_ativa IS true);
	
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
				ARRAY_AGG('{"label": "' || COALESCE(a.rotulo::TEXT, 'Outras organizações da sociedade civil') || '", "value": ' || a.valor::TEXT || '}')::TEXT AS dados, 
				(
					SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()\"', '')) FROM (SELECT DISTINCT UNNEST(
						TRANSLATE(ARRAY_AGG(REPLACE(REPLACE(TRIM(TRANSLATE(a.fontes::TEXT, '"\{}', ''), ','), '","', ','), ',,', ','))::TEXT, '"', '')::TEXT[]
					)) AS a
				) AS fontes 
			FROM (
				SELECT 
					COALESCE(dc_area_atuacao.tx_nome_area_atuacao, 'Sem informação') AS rotulo, 
					COUNT(*) AS valor, 
					(
						SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
							ARRAY_CAT(
								ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_area_atuacao.ft_area_atuacao, ''), '${ETL}', '')), 
								ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_osc.ft_identificador_osc, ''), '${ETL}', ''))
							)
						)) AS a
					) AS fontes 
				FROM osc.tb_osc 
				LEFT JOIN osc.tb_area_atuacao 
				ON tb_osc.id_osc = tb_area_atuacao.id_osc 
				LEFT JOIN syst.dc_area_atuacao 
				ON tb_area_atuacao.cd_area_atuacao = dc_area_atuacao.cd_area_atuacao 
				WHERE tb_osc.bo_osc_ativa 
				AND tb_osc.id_osc <> 789809 
				GROUP BY rotulo
			) AS a
		) AS b;
END;

$$ LANGUAGE 'plpgsql';
