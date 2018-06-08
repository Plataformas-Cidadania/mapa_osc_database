DROP FUNCTION IF EXISTS portal.obter_grafico_oscs_saude_regiao_tipo_gestao() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_oscs_saude_regiao_tipo_gestao() RETURNS TABLE (
	titulo TEXT, 
	tipo TEXT, 
	dados JSONB, 
	fontes TEXT[]	
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			'Distribuição de OSCs de saúde por região e tipo de gestão'::TEXT as titulo, 
			'barras'::TEXT as tipo, 
			c.dados::JSONB AS dados, 
			c.fontes::TEXT[] AS fontes 
		FROM (
			SELECT 
				'[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG(b.dados)::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '{'), '}') || '}]' AS dados, 
				REPLACE(REPLACE(REPLACE(TRANSLATE((ARRAY_AGG(DISTINCT REPLACE(TRIM(TRANSLATE(b.fontes::TEXT, '"\{}', ''), ','), '","', ',')))::TEXT, '"', ''), '{,', '{'), ',}', '}'), ',,', ',')::TEXT[] AS fontes 
			FROM (
				SELECT 
					'{"rotulo": "' || a.rotulo_1 || '", "valor": ' || '[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('{"rotulo": "' || a.rotulo_2::TEXT || '", "valor": ' || a.valor::TEXT || '}')::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '{'), '}') || '}]}' AS dados, 
					REPLACE(REPLACE(REPLACE(TRANSLATE((ARRAY_AGG(DISTINCT REPLACE(TRIM(TRANSLATE(a.fontes::TEXT, '"\{}', ''), ','), '","', ',')))::TEXT, '"', ''), '{,', '{'), ',}', '}'), ',,', ',')::TEXT[] AS fontes 
				FROM (
					SELECT 
						COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação') AS rotulo_1, 
						COALESCE(tb_cnes.ds_gestao, 'Sem informação') AS rotulo_2, 
						COUNT(*) AS valor, 
						ARRAY_CAT('{"CNES/MS"}'::TEXT[], ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_localizacao.ft_municipio, ''), '${ETL}', ''))) AS fontes 
					FROM osc.tb_osc 
					INNER JOIN graph.tb_cnes 
					ON tb_osc.cd_identificador_osc = TRANSLATE(tb_cnes.nu_cnpj_requerente, '-', '')::NUMERIC 
					LEFT JOIN osc.tb_localizacao 
					ON tb_osc.id_osc = tb_localizacao.id_osc 
					LEFT JOIN spat.ed_regiao 
					ON ed_regiao.edre_cd_regiao::TEXT = SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1) 
					GROUP BY rotulo_1, rotulo_2 
					ORDER BY rotulo_1, rotulo_2 
				) AS a 
				GROUP BY a.rotulo_1
			) AS b
		) AS c;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_grafico_oscs_saude_regiao_tipo_gestao();
