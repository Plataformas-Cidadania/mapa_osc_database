DROP FUNCTION IF EXISTS portal.obter_grafico_empregos_formais_oscs_regiao() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_empregos_formais_oscs_regiao() RETURNS TABLE (
	titulo TEXT, 
	tipo TEXT, 
	dados JSON
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 'Número de empregos formais nas OSCs por região'::TEXT AS titulo, 'barras'::TEXT AS tipo, (SELECT row_to_json(p)) AS dados 
		FROM (
			SELECT (
				SELECT array_to_json(array_agg(row_to_json(a))) 
				FROM (
					SELECT count(*) AS valor, (
						SELECT edre_nm_regiao 
						FROM spat.ed_regiao 
						WHERE edre_cd_regiao = (SELECT SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1))::NUMERIC(1, 0)
					) AS rotulo 
					FROM osc.tb_dados_gerais 
					INNER JOIN osc.tb_relacoes_trabalho 
					ON tb_dados_gerais.id_osc = tb_relacoes_trabalho.id_osc 
					INNER JOIN osc.tb_localizacao 
					ON tb_dados_gerais.id_osc = tb_localizacao.id_osc 
					GROUP BY rotulo
				) AS a
			)
		) p;
END;

$$ LANGUAGE 'plpgsql';
