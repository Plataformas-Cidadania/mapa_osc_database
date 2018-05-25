DROP FUNCTION IF EXISTS portal.obter_grafico_empregos_formais_oscs_regiao() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_empregos_formais_oscs_regiao() RETURNS TABLE (
	titulo TEXT, 
	tipo TEXT, 
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			'Número de empregos formais nas OSCs por região'::TEXT AS titulo, 
			'barras'::TEXT AS tipo, 
			b.dados::JSONB AS dados, 
			b.fontes AS fontes 
		FROM (
			SELECT 
				('{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('"' || a.regiao::TEXT || '": ' || a.quantidade::TEXT)::TEXT, '\', '') || '}'), '""', '"'), '",', ','), '"}', '}'), '"{', '{'), '{'), '}') || '}')::JSONB AS dados, 
				(SELECT ARRAY(SELECT DISTINCT UNNEST(('{' || BTRIM(REPLACE(REPLACE(RTRIM(LTRIM(TRANSLATE(ARRAY_AGG(a.fontes::TEXT)::TEXT, '"\', ''), '{'), '}'), '},{', ','), ',,', ','), ',') || '}')::TEXT[]))) AS fontes
			FROM (
				SELECT 
					ed_regiao.edre_nm_regiao AS regiao,
					SUM(tb_relacoes_trabalho.nr_trabalhadores_vinculo) AS quantidade, 
					ARRAY_AGG(DISTINCT(COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, '') || ',' || COALESCE(tb_localizacao.ft_municipio, ''))) AS fontes
				FROM osc.tb_dados_gerais 
				INNER JOIN osc.tb_relacoes_trabalho 
				ON tb_dados_gerais.id_osc = tb_relacoes_trabalho.id_osc 
				INNER JOIN osc.tb_localizacao 
				ON tb_dados_gerais.id_osc = tb_localizacao.id_osc 
				INNER JOIN spat.ed_regiao 
				ON (SELECT SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1))::NUMERIC(1, 0) = ed_regiao.edre_cd_regiao 
				GROUP BY regiao
			) AS a
		) AS b;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_grafico_empregos_formais_oscs_regiao();
