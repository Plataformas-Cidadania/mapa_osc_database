DROP FUNCTION IF EXISTS portal.obter_grafico_empregos_formais_oscs_regiao() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_empregos_formais_oscs_regiao() RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('{"rotulo": "' || a.rotulo::TEXT || '", "valor": ' || a.valor::TEXT || '}')::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '{'), '}') || '}]')::JSONB AS dados, 
			REPLACE(REPLACE(REPLACE(TRANSLATE((ARRAY_AGG(DISTINCT REPLACE(TRIM(TRANSLATE(a.fontes::TEXT, '"\{}', ''), ','), '","', ',')))::TEXT, '"', ''), '{,', '{'), ',}', '}'), ',,', ',')::TEXT[] AS fontes 
		FROM (
			SELECT 
				COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação') AS rotulo, 
				COALESCE(SUM(tb_relacoes_trabalho.nr_trabalhadores_vinculo), 0) AS valor, 
				ARRAY_CAT(ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, ''), '${ETL}', '')), ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_localizacao.ft_municipio, ''), '${ETL}', ''))) AS fontes 
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
			GROUP BY rotulo
		) AS a;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_grafico_empregos_formais_oscs_regiao();
