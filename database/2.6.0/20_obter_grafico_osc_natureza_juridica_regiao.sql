DROP FUNCTION IF EXISTS portal.obter_grafico_osc_natureza_juridica_regiao();

CREATE OR REPLACE FUNCTION portal.obter_grafico_osc_natureza_juridica_regiao() RETURNS TABLE (
	titulo TEXT, 
	tipo TEXT, 
	resultado JSON
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			'Número de OSCs por natureza jurídica e região, Brasil'::TEXT as titulo, 
			'barras'::TEXT as tipo, 
			array_to_json(array_agg(b)) AS resultado 
		FROM (
			SELECT 
				rotulo_1 AS rotulo,
				array_to_json(array_agg(('{"' || rotulo_2 || '": ' || valor || '}')::JSON)) AS valor 
			FROM (
				SELECT 
					regiao.edre_nm_regiao AS rotulo_1, 
					dados_gerais.tx_nome_natureza_juridica_osc AS rotulo_2, 
					count(*) AS valor 
				FROM spat.vw_spat_regiao AS regiao 
				RIGHT JOIN portal.vw_osc_dados_gerais AS dados_gerais 
				ON regiao.edre_cd_regiao::TEXT = SUBSTR(dados_gerais.cd_uf::TEXT, 1, 1) 
				GROUP BY regiao.edre_nm_regiao, dados_gerais.tx_nome_natureza_juridica_osc 
				ORDER BY regiao.edre_nm_regiao, dados_gerais.tx_nome_natureza_juridica_osc
			) AS a 
			GROUP BY rotulo
		) AS b;
END;

$$ LANGUAGE 'plpgsql';

