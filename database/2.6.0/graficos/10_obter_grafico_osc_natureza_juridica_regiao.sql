DROP FUNCTION IF EXISTS portal.obter_grafico_osc_natureza_juridica_regiao() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_osc_natureza_juridica_regiao() RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]	
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG(b.dados)::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '"{', '{'), '{'), '}') || '}]')::JSONB AS dados, 
			REPLACE(REPLACE(REPLACE(TRANSLATE((ARRAY_AGG(DISTINCT REPLACE(TRIM(TRANSLATE(b.fontes::TEXT, '"\{}', ''), ','), '","', ',')))::TEXT, '"', ''), '{,', '{'), ',}', '}'), ',,', ',')::TEXT[] AS fontes 
		FROM (
			SELECT 
				'{"rotulo": "' || a.rotulo_1 || '", "valor": ' || '[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('{"rotulo": "' || a.rotulo_2::TEXT || '", "valor": ' || a.valor::TEXT || '}')::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '{'), '}') || '}]}' AS dados, 
				REPLACE(REPLACE(REPLACE(TRANSLATE((ARRAY_AGG(DISTINCT REPLACE(TRIM(TRANSLATE(a.fontes::TEXT, '"\{}', ''), ','), '","', ',')))::TEXT, '"', ''), '{,', '{'), ',}', '}'), ',,', ',')::TEXT[] AS fontes 
			FROM (
				SELECT 
					COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação') AS rotulo_1, 
					COALESCE(dc_natureza_juridica.tx_nome_natureza_juridica, 'Sem informação') AS rotulo_2, 
					COUNT(*) AS valor, 
					ARRAY_CAT(ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_dados_gerais.ft_classe_atividade_economica_osc, ''), '${ETL}', '')), ARRAY_CAT(ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_localizacao.ft_municipio, ''), '${ETL}', '')), ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_osc.ft_identificador_osc, ''), '${ETL}', '')))) AS fontes 
				FROM osc.tb_osc 
				LEFT JOIN osc.tb_dados_gerais 
				ON tb_osc.id_osc = tb_dados_gerais.id_osc  
				LEFT JOIN syst.dc_natureza_juridica
				ON tb_dados_gerais.cd_natureza_juridica_osc = dc_natureza_juridica.cd_natureza_juridica 
				LEFT JOIN osc.tb_localizacao 
				ON tb_dados_gerais.id_osc = tb_localizacao.id_osc 
				LEFT JOIN spat.ed_regiao 
				ON ed_regiao.edre_cd_regiao::TEXT = SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1) 
				WHERE tb_osc.bo_osc_ativa 
				GROUP BY ed_regiao.edre_nm_regiao, dc_natureza_juridica.tx_nome_natureza_juridica
			) AS a 
			GROUP BY rotulo_1
		) AS b;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_grafico_osc_natureza_juridica_regiao();

