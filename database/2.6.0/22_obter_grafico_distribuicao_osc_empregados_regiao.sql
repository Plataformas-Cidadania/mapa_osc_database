DROP FUNCTION IF EXISTS portal.obter_grafico_distribuicao_osc_empregados_regiao() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_distribuicao_osc_empregados_regiao() RETURNS TABLE (
	titulo TEXT, 
	tipo TEXT, 
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			'Distribuição de OSCs por número de empregados e região'::TEXT AS titulo, 
			'barras'::TEXT AS tipo, 
			c.dados::JSONB AS dados, 
			c.fontes AS fontes 
		FROM (
			SELECT 
				('{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG(b.dados)::TEXT, '\', '') || '}'), '""', '"'), '",', ','), '"}', '}'), '"{', '{'), '{'), '}')) AS dados, 
				(SELECT ARRAY(SELECT DISTINCT UNNEST(('{' || BTRIM(REPLACE(REPLACE(RTRIM(LTRIM(TRANSLATE(ARRAY_AGG(b.fontes::TEXT)::TEXT, '"\', ''), '{'), '}'), '},{', ','), ',,', ','), ',') || '}')::TEXT[]))) AS fontes
			FROM (
				SELECT 
					('"0": {' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('"' || a.regiao::TEXT || '": ' || a.quantidade::TEXT)::TEXT, '\', '') || '}'), '""', '"'), '",', ','), '"}', '}'), '"{', '{'), '{'), '}') || '}') AS dados, 
					(SELECT ARRAY(SELECT DISTINCT UNNEST(('{' || BTRIM(REPLACE(REPLACE(RTRIM(LTRIM(TRANSLATE(ARRAY_AGG(a.fontes::TEXT)::TEXT, '"\', ''), '{'), '}'), '},{', ','), ',,', ','), ',') || '}')::TEXT[]))) AS fontes 
				FROM (
					SELECT 
						ed_regiao.edre_nm_regiao AS regiao,
						count(*) AS quantidade, 
						ARRAY_AGG(DISTINCT(COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, '') || ',' || COALESCE(tb_localizacao.ft_municipio, ''))) AS fontes 
					FROM osc.tb_dados_gerais 
					INNER JOIN osc.tb_relacoes_trabalho 
					ON tb_dados_gerais.id_osc = tb_relacoes_trabalho.id_osc 
					INNER JOIN osc.tb_localizacao 
					ON tb_dados_gerais.id_osc = tb_localizacao.id_osc 
					INNER JOIN spat.ed_regiao 
					ON (SELECT SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1))::NUMERIC(1, 0) = ed_regiao.edre_cd_regiao 
					WHERE nr_trabalhadores_vinculo = 0 
					GROUP BY regiao
				) AS a
				UNION 
				SELECT 
					('"1 a 4": {' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('"' || a.regiao::TEXT || '": ' || a.quantidade::TEXT)::TEXT, '\', '') || '}'), '""', '"'), '",', ','), '"}', '}'), '"{', '{'), '{'), '}') || '}') AS dados, 
					(SELECT ARRAY(SELECT DISTINCT UNNEST(('{' || BTRIM(REPLACE(REPLACE(RTRIM(LTRIM(TRANSLATE(ARRAY_AGG(a.fontes::TEXT)::TEXT, '"\', ''), '{'), '}'), '},{', ','), ',,', ','), ',') || '}')::TEXT[]))) AS fontes 
				FROM (
					SELECT 
						ed_regiao.edre_nm_regiao AS regiao,
						count(*) AS quantidade, 
						ARRAY_AGG(DISTINCT(COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, '') || ',' || COALESCE(tb_localizacao.ft_municipio, ''))) AS fontes 
					FROM osc.tb_dados_gerais 
					INNER JOIN osc.tb_relacoes_trabalho 
					ON tb_dados_gerais.id_osc = tb_relacoes_trabalho.id_osc 
					INNER JOIN osc.tb_localizacao 
					ON tb_dados_gerais.id_osc = tb_localizacao.id_osc 
					INNER JOIN spat.ed_regiao 
					ON (SELECT SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1))::NUMERIC(1, 0) = ed_regiao.edre_cd_regiao 
					WHERE nr_trabalhadores_vinculo BETWEEN 1 AND 4 
					GROUP BY regiao
				) AS a
				UNION 
				SELECT 
					('"5 a 19": {' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('"' || a.regiao::TEXT || '": ' || a.quantidade::TEXT)::TEXT, '\', '') || '}'), '""', '"'), '",', ','), '"}', '}'), '"{', '{'), '{'), '}') || '}') AS dados, 
					(SELECT ARRAY(SELECT DISTINCT UNNEST(('{' || BTRIM(REPLACE(REPLACE(RTRIM(LTRIM(TRANSLATE(ARRAY_AGG(a.fontes::TEXT)::TEXT, '"\', ''), '{'), '}'), '},{', ','), ',,', ','), ',') || '}')::TEXT[]))) AS fontes 
				FROM (
					SELECT 
						ed_regiao.edre_nm_regiao AS regiao,
						count(*) AS quantidade, 
						ARRAY_AGG(DISTINCT(COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, '') || ',' || COALESCE(tb_localizacao.ft_municipio, ''))) AS fontes 
					FROM osc.tb_dados_gerais 
					INNER JOIN osc.tb_relacoes_trabalho 
					ON tb_dados_gerais.id_osc = tb_relacoes_trabalho.id_osc 
					INNER JOIN osc.tb_localizacao 
					ON tb_dados_gerais.id_osc = tb_localizacao.id_osc 
					INNER JOIN spat.ed_regiao 
					ON (SELECT SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1))::NUMERIC(1, 0) = ed_regiao.edre_cd_regiao 
					WHERE nr_trabalhadores_vinculo BETWEEN 5 AND 19 
					GROUP BY regiao
				) AS a
				UNION 
				SELECT 
					('"20 a 99": {' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('"' || a.regiao::TEXT || '": ' || a.quantidade::TEXT)::TEXT, '\', '') || '}'), '""', '"'), '",', ','), '"}', '}'), '"{', '{'), '{'), '}') || '}') AS dados, 
					(SELECT ARRAY(SELECT DISTINCT UNNEST(('{' || BTRIM(REPLACE(REPLACE(RTRIM(LTRIM(TRANSLATE(ARRAY_AGG(a.fontes::TEXT)::TEXT, '"\', ''), '{'), '}'), '},{', ','), ',,', ','), ',') || '}')::TEXT[]))) AS fontes 
				FROM (
					SELECT 
						ed_regiao.edre_nm_regiao AS regiao,
						count(*) AS quantidade, 
						ARRAY_AGG(DISTINCT(COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, '') || ',' || COALESCE(tb_localizacao.ft_municipio, ''))) AS fontes 
					FROM osc.tb_dados_gerais 
					INNER JOIN osc.tb_relacoes_trabalho 
					ON tb_dados_gerais.id_osc = tb_relacoes_trabalho.id_osc 
					INNER JOIN osc.tb_localizacao 
					ON tb_dados_gerais.id_osc = tb_localizacao.id_osc 
					INNER JOIN spat.ed_regiao 
					ON (SELECT SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1))::NUMERIC(1, 0) = ed_regiao.edre_cd_regiao 
					WHERE nr_trabalhadores_vinculo BETWEEN 20 AND 99 
					GROUP BY regiao
				) AS a
				UNION 
				SELECT 
					('"100 ou mais": {' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('"' || a.regiao::TEXT || '": ' || a.quantidade::TEXT)::TEXT, '\', '') || '}'), '""', '"'), '",', ','), '"}', '}'), '"{', '{'), '{'), '}') || '}') AS dados, 
					(SELECT ARRAY(SELECT DISTINCT UNNEST(('{' || BTRIM(REPLACE(REPLACE(RTRIM(LTRIM(TRANSLATE(ARRAY_AGG(a.fontes::TEXT)::TEXT, '"\', ''), '{'), '}'), '},{', ','), ',,', ','), ',') || '}')::TEXT[]))) AS fontes 
				FROM (
					SELECT 
						ed_regiao.edre_nm_regiao AS regiao,
						count(*) AS quantidade, 
						ARRAY_AGG(DISTINCT(COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, '') || ',' || COALESCE(tb_localizacao.ft_municipio, ''))) AS fontes 
					FROM osc.tb_dados_gerais 
					INNER JOIN osc.tb_relacoes_trabalho 
					ON tb_dados_gerais.id_osc = tb_relacoes_trabalho.id_osc 
					INNER JOIN osc.tb_localizacao 
					ON tb_dados_gerais.id_osc = tb_localizacao.id_osc 
					INNER JOIN spat.ed_regiao 
					ON (SELECT SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1))::NUMERIC(1, 0) = ed_regiao.edre_cd_regiao 
					WHERE nr_trabalhadores_vinculo >= 100 
					GROUP BY regiao
				) AS a
			) AS b
		) AS c;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_grafico_distribuicao_osc_empregados_regiao();
