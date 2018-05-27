DROP FUNCTION IF EXISTS portal.obter_grafico_osc_natureza_juridica_regiao() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_osc_natureza_juridica_regiao() RETURNS TABLE (
	titulo TEXT, 
	tipo TEXT, 
	dados JSONB, 
	fontes TEXT[]	
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			'Número de OSCs por natureza jurídica e região'::TEXT as titulo, 
			'barras'::TEXT as tipo, 
			c.dados::JSONB AS dados, 
			c.fontes AS fontes 
		FROM (
			SELECT 
				('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG(b.dados)::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '{'), '}') || '}]') AS dados, 
				(SELECT ARRAY(SELECT DISTINCT UNNEST(('{' || BTRIM(REPLACE(REPLACE(RTRIM(LTRIM(TRANSLATE(ARRAY_AGG(b.fontes::TEXT)::TEXT, '"\', ''), '{'), '}'), '},{', ','), ',,', ','), ',') || '}')::TEXT[]))) AS fontes
			FROM (
				SELECT 
					('{"rotulo": "' || a.regiao || '", "valor": ' || '[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('{"rotulo": "' || a.natureza_juridica::TEXT || '", "valor": ' || a.quantidade::TEXT || '}')::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '{'), '}') || '}]}') AS dados, 
					(SELECT ARRAY(SELECT DISTINCT UNNEST(('{' || BTRIM(REPLACE(REPLACE(RTRIM(LTRIM(TRANSLATE(ARRAY_AGG(a.fontes::TEXT)::TEXT, '"\', ''), '{'), '}'), '},{', ','), ',,', ','), ',') || '}')::TEXT[]))) AS fontes
				FROM (
					SELECT 
						ed_regiao.edre_nm_regiao AS regiao, 
						dc_natureza_juridica.tx_nome_natureza_juridica AS natureza_juridica, 
						count(*) AS quantidade, 
						ARRAY_AGG(DISTINCT(COALESCE(tb_dados_gerais.ft_classe_atividade_economica_osc, '') || ',' || COALESCE(tb_localizacao.ft_municipio, ''))) AS fontes 
					FROM osc.tb_dados_gerais 
					INNER JOIN osc.tb_localizacao 
					ON tb_dados_gerais.id_osc = tb_localizacao.id_osc 
					INNER JOIN syst.dc_natureza_juridica
					ON tb_dados_gerais.cd_natureza_juridica_osc = dc_natureza_juridica.cd_natureza_juridica 
					RIGHT JOIN spat.ed_regiao 
					ON ed_regiao.edre_cd_regiao::TEXT = SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1) 
					GROUP BY ed_regiao.edre_nm_regiao, dc_natureza_juridica.tx_nome_natureza_juridica 
					ORDER BY ed_regiao.edre_nm_regiao, dc_natureza_juridica.tx_nome_natureza_juridica
				) AS a 
				GROUP BY regiao
			) AS b
		) AS c;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_grafico_osc_natureza_juridica_regiao();
