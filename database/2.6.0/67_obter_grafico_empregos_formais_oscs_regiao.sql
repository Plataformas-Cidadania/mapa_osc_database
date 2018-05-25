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
				'[{' || RTRIM(LTRIM(REPLACE(REPLACE(TRANSLATE(ARRAY_AGG('{"' || a.regiao::TEXT || '": ' || a.trabalhadores::TEXT || '}')::TEXT, '\', ''), '"{', '{'), '}"', '}'), '{'), '}') || '}]' AS dados, 
				(SELECT ARRAY(SELECT DISTINCT UNNEST(('{' || BTRIM(REPLACE(REPLACE(RTRIM(LTRIM(TRANSLATE(ARRAY_AGG(a.fontes::TEXT)::TEXT, '"\', ''), '{'), '}'), '},{', ','), ',,', ','), ',') || '}')::TEXT[]))) AS fontes
			FROM (
				SELECT 
					SUM(tb_relacoes_trabalho.nr_trabalhadores_vinculo) AS trabalhadores, 
					(
						SELECT edre_nm_regiao 
						FROM spat.ed_regiao 
						WHERE edre_cd_regiao = (SELECT SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1))::NUMERIC(1, 0)
					) AS regiao,
					ARRAY_AGG(DISTINCT(COALESCE(tb_relacoes_trabalho.ft_trabalhadores_vinculo, '') || ',' || COALESCE(tb_localizacao.ft_municipio, ''))) AS fontes
				FROM osc.tb_dados_gerais 
				INNER JOIN osc.tb_relacoes_trabalho 
				ON tb_dados_gerais.id_osc = tb_relacoes_trabalho.id_osc 
				INNER JOIN osc.tb_localizacao 
				ON tb_dados_gerais.id_osc = tb_localizacao.id_osc 
				GROUP BY regiao
			) AS a
		) AS b;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_grafico_empregos_formais_oscs_regiao();
