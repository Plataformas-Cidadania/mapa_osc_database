DROP FUNCTION IF EXISTS portal.obter_grafico_distribuicao_osc_empregados_regiao() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_distribuicao_osc_empregados_regiao() RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG(b.dados)::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '{'), '}') || '}]')::JSONB AS dados, 
			REPLACE(REPLACE(TRANSLATE((ARRAY_AGG(DISTINCT REPLACE(TRIM(TRANSLATE(b.fontes::TEXT, '"\{}', ''), ','), '","', ',')))::TEXT, '"', ''), '{,', '{'), ',}', '}')::TEXT[] AS fontes 
		FROM (
			SELECT 
				'{"rotulo": "' || a.rotulo_1 || '", "valor": ' || '[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('{"rotulo": "' || a.rotulo_2::TEXT || '", "valor": ' || a.valor::TEXT || '}')::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '{'), '}') || '}]}' AS dados, 
				REPLACE(REPLACE(REPLACE(TRANSLATE((ARRAY_AGG(DISTINCT REPLACE(TRIM(TRANSLATE(a.fontes::TEXT, '"\{}', ''), ','), '","', ',')))::TEXT, '"', ''), '{,', '{'), ',}', '}'), ',,', ',')::TEXT[] AS fontes 
			FROM (
				SELECT 
					COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação') AS rotulo_1, 
					(
						CASE 
							WHEN (tb_relacoes_trabalho.nr_trabalhadores_vinculo = 0) THEN '0' 
							WHEN (tb_relacoes_trabalho.nr_trabalhadores_vinculo BETWEEN 1 AND 4) THEN '1 a 4' 
							WHEN (tb_relacoes_trabalho.nr_trabalhadores_vinculo BETWEEN 5 AND 19) THEN '5 a 19' 
							WHEN (tb_relacoes_trabalho.nr_trabalhadores_vinculo BETWEEN 20 AND 99) THEN '20 a 99' 
							WHEN (tb_relacoes_trabalho.nr_trabalhadores_vinculo >= 100) THEN '100 ou mais' 
							ELSE '0'
						END
					) AS rotulo_2, 
					COUNT(*) AS valor, 
					ARRAY_CAT(ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, ''), '${ETL}', '')), ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_osc.ft_identificador_osc, ''), '${ETL}', ''))) AS fontes 
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
				GROUP BY rotulo_1, rotulo_2
			) AS a 
			GROUP BY a.rotulo_1
		) AS b;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_grafico_distribuicao_osc_empregados_regiao();
