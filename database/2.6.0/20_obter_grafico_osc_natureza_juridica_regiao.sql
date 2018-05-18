DROP FUNCTION IF EXISTS portal.obter_grafico_osc_natureza_juridica_regiao();

CREATE OR REPLACE FUNCTION portal.obter_grafico_osc_natureza_juridica_regiao() RETURNS TABLE (
	titulo TEXT, 
	tipo TEXT, 
	dados JSON
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			'Número de OSCs por natureza jurídica e região, Brasil'::TEXT as titulo, 
			'barras'::TEXT as tipo, 
			array_to_json(array_agg(b)) AS dados 
		FROM (
			SELECT 
				rotulo_1 AS rotulo,
				array_to_json(array_agg(('{"' || rotulo_2 || '": ' || valor || '}')::JSON)) AS valor 
			FROM (
				SELECT 
					ed_regiao.edre_nm_regiao AS rotulo_1, 
					dc_natureza_juridica.tx_nome_natureza_juridica AS rotulo_2, 
					count(*) AS valor 
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
			GROUP BY rotulo
		) AS b;
END;

$$ LANGUAGE 'plpgsql';
