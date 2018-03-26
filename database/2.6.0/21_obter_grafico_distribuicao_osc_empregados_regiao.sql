DROP FUNCTION IF EXISTS portal.obter_grafico_distribuicao_osc_empregados_regiao();

CREATE OR REPLACE FUNCTION portal.obter_grafico_distribuicao_osc_empregados_regiao() RETURNS TABLE (
	titulo TEXT, 
	tipo TEXT, 
	dados JSON
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 'Distribuição de OSCs por número de empregados e região, Brasil'::TEXT AS titulo, 'barras'::TEXT AS tipo, (SELECT row_to_json(p)) AS resultado 
		FROM (
			SELECT (
				SELECT array_to_json(array_agg(row_to_json(a))) 
				FROM (
					SELECT count(*) AS valor, (
						SELECT edre_nm_regiao 
						FROM spat.ed_regiao 
						WHERE edre_cd_regiao = (SELECT SUBSTR(cd_uf::TEXT, 1, 1))::NUMERIC(1, 0)
					) AS rotulo 
					FROM portal.vw_osc_dados_gerais 
					JOIN portal.vw_osc_relacoes_trabalho 
					ON vw_osc_dados_gerais.id_osc = vw_osc_relacoes_trabalho.id_osc
					WHERE nr_trabalhadores_vinculo = 0 
					GROUP BY rotulo
				) AS a
			) AS "0",
			(
				SELECT array_to_json(array_agg(row_to_json(b))) 
				FROM (
					SELECT count(*) AS valor, (
						SELECT edre_nm_regiao 
						FROM spat.ed_regiao 
						WHERE edre_cd_regiao = (SELECT SUBSTR(cd_uf::TEXT, 1, 1))::NUMERIC(1, 0)
					) AS rotulo 
					FROM portal.vw_osc_dados_gerais 
					JOIN portal.vw_osc_relacoes_trabalho 
					ON vw_osc_dados_gerais.id_osc = vw_osc_relacoes_trabalho.id_osc
					WHERE nr_trabalhadores_vinculo BETWEEN 1 AND 4 
					GROUP BY rotulo
				) AS b
			) AS "1 a 4",
			(
				SELECT array_to_json(array_agg(row_to_json(c))) 
				FROM (
					SELECT count(*) AS valor, (
						SELECT edre_nm_regiao 
						FROM spat.ed_regiao 
						WHERE edre_cd_regiao = (SELECT SUBSTR(cd_uf::TEXT, 1, 1))::NUMERIC(1, 0)
					) AS rotulo 
					FROM portal.vw_osc_dados_gerais 
					JOIN portal.vw_osc_relacoes_trabalho 
					ON vw_osc_dados_gerais.id_osc = vw_osc_relacoes_trabalho.id_osc
					WHERE nr_trabalhadores_vinculo BETWEEN 5 AND 19 
					GROUP BY rotulo
				) AS c
			) AS "5 a 19",
			(
				SELECT array_to_json(array_agg(row_to_json(d))) 
				FROM (
					SELECT count(*) AS valor, (
						SELECT edre_nm_regiao 
						FROM spat.ed_regiao 
						WHERE edre_cd_regiao = (SELECT SUBSTR(cd_uf::TEXT, 1, 1))::NUMERIC(1, 0)
					) AS rotulo 
					FROM portal.vw_osc_dados_gerais 
					JOIN portal.vw_osc_relacoes_trabalho 
					ON vw_osc_dados_gerais.id_osc = vw_osc_relacoes_trabalho.id_osc
					WHERE nr_trabalhadores_vinculo BETWEEN 20 AND 99 
					GROUP BY rotulo
				) AS d
			) AS "20 a 99",
			(
				SELECT array_to_json(array_agg(row_to_json(e))) 
				FROM (
					SELECT count(*) AS valor, (
						SELECT edre_nm_regiao 
						FROM spat.ed_regiao 
						WHERE edre_cd_regiao = (SELECT SUBSTR(cd_uf::TEXT, 1, 1))::NUMERIC(1, 0)
					) AS rotulo 
					FROM portal.vw_osc_dados_gerais 
					JOIN portal.vw_osc_relacoes_trabalho 
					ON vw_osc_dados_gerais.id_osc = vw_osc_relacoes_trabalho.id_osc
					WHERE nr_trabalhadores_vinculo >= 100 
					GROUP BY rotulo
				) AS e
			) AS "100 ou mais"
		) p;
END;

$$ LANGUAGE 'plpgsql';

