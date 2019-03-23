DROP FUNCTION IF EXISTS portal.obter_grafico_osc_natureza_juridica_regiao(INTEGER) CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_osc_natureza_juridica_regiao(tipo_serie INTEGER) RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]	
) AS $$ 

BEGIN 
	IF tipo_serie = 1 THEN 
		RETURN QUERY 
			SELECT 
				('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG(b.dados)::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '"{', '{'), ',,', ','), '{'), '}') || '}]')::JSONB AS dados, 
				(
					SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()\"', '')) FROM (SELECT DISTINCT UNNEST(
						TRANSLATE(ARRAY_AGG(REPLACE(REPLACE(REPLACE(TRIM(TRIM(TRANSLATE(b.fontes::TEXT, '"\{}', ''), ' '), ','), '","', ','), '","', ','), ',,', ','))::TEXT, '"', '')::TEXT[]
					)) AS a
				) AS fontes 
			FROM (
				SELECT 
					'{"key": "' || a.rotulo_1 || '", "values": ' || '[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('{"label": "' || a.rotulo_2::TEXT || '", "value": ' || a.valor::TEXT || '}')::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), ',,', ','), '{'), '}') || '}]}' AS dados, 
					(
						SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()\"', '')) FROM (SELECT DISTINCT UNNEST(
							TRANSLATE(ARRAY_AGG(REPLACE(REPLACE(REPLACE(TRIM(TRIM(TRANSLATE(a.fontes::TEXT, '"\{}', ''), ' '), ','), '","', ','), '","', ','), ',,', ','))::TEXT, '"', '')::TEXT[]
						)) AS a
					) AS fontes 
				FROM (
						SELECT 
							a.rotulo_1, 
							a.rotulo_2, 
							SUM(a.valor) AS valor, 
							ARRAY_AGG(a.fontes::TEXT) FILTER (WHERE a.fontes IS NOT null) AS fontes 
						FROM (
							SELECT * FROM (
								SELECT 
									COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação') AS rotulo_1, 
									COALESCE(dc_natureza_juridica.tx_nome_natureza_juridica, 'Sem informação') AS rotulo_2, 
									COUNT(*) AS valor, 
									(
										SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
											ARRAY_CAT(
												ARRAY_CAT(
													ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_dados_gerais.ft_classe_atividade_economica_osc, ''), '${ETL}', '')), 
													ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_localizacao.ft_municipio, ''), '${ETL}', ''))
												),
												ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_osc.ft_identificador_osc, ''), '${ETL}', ''))
											)
										)) AS a
									) AS fontes 
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
								AND tb_osc.id_osc <> 789809 
								GROUP BY ed_regiao.edre_nm_regiao, dc_natureza_juridica.tx_nome_natureza_juridica
							) AS a 
							UNION 
							SELECT 'Centro Oeste'::CHARACTER VARYING, 'Associação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION
							SELECT 'Centro Oeste'::CHARACTER VARYING, 'Fundação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Centro Oeste'::CHARACTER VARYING, 'Organização Religiosa'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Centro Oeste'::CHARACTER VARYING, 'Organização Social'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Centro Oeste'::CHARACTER VARYING, 'Sem informação'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Nordeste'::CHARACTER VARYING, 'Associação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION
							SELECT 'Nordeste'::CHARACTER VARYING, 'Fundação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Nordeste'::CHARACTER VARYING, 'Organização Religiosa'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Nordeste'::CHARACTER VARYING, 'Organização Social'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Nordeste'::CHARACTER VARYING, 'Sem informação'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Norte'::CHARACTER VARYING, 'Associação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION
							SELECT 'Norte'::CHARACTER VARYING, 'Fundação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Norte'::CHARACTER VARYING, 'Organização Religiosa'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Norte'::CHARACTER VARYING, 'Organização Social'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Norte'::CHARACTER VARYING, 'Sem informação'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sem informação'::CHARACTER VARYING, 'Associação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION
							SELECT 'Sem informação'::CHARACTER VARYING, 'Fundação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sem informação'::CHARACTER VARYING, 'Organização Religiosa'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sem informação'::CHARACTER VARYING, 'Organização Social'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sem informação'::CHARACTER VARYING, 'Sem informação'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sudeste'::CHARACTER VARYING, 'Associação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION
							SELECT 'Sudeste'::CHARACTER VARYING, 'Fundação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sudeste'::CHARACTER VARYING, 'Organização Religiosa'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sudeste'::CHARACTER VARYING, 'Organização Social'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sudeste'::CHARACTER VARYING, 'Sem informação'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sul'::CHARACTER VARYING, 'Associação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION
							SELECT 'Sul'::CHARACTER VARYING, 'Fundação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sul'::CHARACTER VARYING, 'Organização Religiosa'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sul'::CHARACTER VARYING, 'Organização Social'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sul'::CHARACTER VARYING, 'Sem informação'::TEXT, 0::BIGINT, null::TEXT[]
						) AS a 
						GROUP BY rotulo_1, rotulo_2 
						ORDER BY rotulo_1, rotulo_2
				) AS a 
				GROUP BY rotulo_1
			) AS b;
	
	ELSIF tipo_serie = 2 THEN 
		RETURN QUERY 
			SELECT 
				('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG(b.dados)::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), '"{', '{'), ',,', ','), '{'), '}') || '}]')::JSONB AS dados, 
				(
					SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()\"', '')) FROM (SELECT DISTINCT UNNEST(
						TRANSLATE(ARRAY_AGG(REPLACE(REPLACE(REPLACE(TRIM(TRIM(TRANSLATE(b.fontes::TEXT, '"\{}', ''), ' '), ','), '","', ','), '","', ','), ',,', ','))::TEXT, '"', '')::TEXT[]
					)) AS a
				) AS fontes 
			FROM (
				SELECT 
					'{"key": "' || a.rotulo_2 || '", "values": ' || '[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG('{"label": "' || a.rotulo_1::TEXT || '", "value": ' || a.valor::TEXT || '}')::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), ',,', ','), '{'), '}') || '}]}' AS dados, 
					(
						SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()\"', '')) FROM (SELECT DISTINCT UNNEST(
							TRANSLATE(ARRAY_AGG(REPLACE(REPLACE(REPLACE(TRIM(TRIM(TRANSLATE(a.fontes::TEXT, '"\{}', ''), ' '), ','), '","', ','), '","', ','), ',,', ','))::TEXT, '"', '')::TEXT[]
						)) AS a
					) AS fontes 
				FROM (
						SELECT 
							a.rotulo_1, 
							a.rotulo_2, 
							SUM(a.valor) AS valor, 
							ARRAY_AGG(a.fontes::TEXT) FILTER (WHERE a.fontes IS NOT null) AS fontes 
						FROM (
							SELECT * FROM (
								SELECT 
									COALESCE(ed_regiao.edre_nm_regiao, 'Sem informação') AS rotulo_1, 
									COALESCE(dc_natureza_juridica.tx_nome_natureza_juridica, 'Sem informação') AS rotulo_2, 
									COUNT(*) AS valor, 
									(
										SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
											ARRAY_CAT(
												ARRAY_CAT(
													ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_dados_gerais.ft_classe_atividade_economica_osc, ''), '${ETL}', '')), 
													ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_localizacao.ft_municipio, ''), '${ETL}', ''))
												),
												ARRAY_AGG(DISTINCT REPLACE(COALESCE(tb_osc.ft_identificador_osc, ''), '${ETL}', ''))
											)
										)) AS a
									) AS fontes 
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
								AND tb_osc.id_osc <> 789809 
								GROUP BY ed_regiao.edre_nm_regiao, dc_natureza_juridica.tx_nome_natureza_juridica
							) AS a 
							UNION 
							SELECT 'Centro Oeste'::CHARACTER VARYING, 'Associação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION
							SELECT 'Centro Oeste'::CHARACTER VARYING, 'Fundação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Centro Oeste'::CHARACTER VARYING, 'Organização Religiosa'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Centro Oeste'::CHARACTER VARYING, 'Organização Social'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Centro Oeste'::CHARACTER VARYING, 'Sem informação'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Nordeste'::CHARACTER VARYING, 'Associação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION
							SELECT 'Nordeste'::CHARACTER VARYING, 'Fundação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Nordeste'::CHARACTER VARYING, 'Organização Religiosa'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Nordeste'::CHARACTER VARYING, 'Organização Social'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Nordeste'::CHARACTER VARYING, 'Sem informação'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Norte'::CHARACTER VARYING, 'Associação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION
							SELECT 'Norte'::CHARACTER VARYING, 'Fundação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Norte'::CHARACTER VARYING, 'Organização Religiosa'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Norte'::CHARACTER VARYING, 'Organização Social'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Norte'::CHARACTER VARYING, 'Sem informação'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sem informação'::CHARACTER VARYING, 'Associação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION
							SELECT 'Sem informação'::CHARACTER VARYING, 'Fundação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sem informação'::CHARACTER VARYING, 'Organização Religiosa'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sem informação'::CHARACTER VARYING, 'Organização Social'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sem informação'::CHARACTER VARYING, 'Sem informação'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sudeste'::CHARACTER VARYING, 'Associação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION
							SELECT 'Sudeste'::CHARACTER VARYING, 'Fundação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sudeste'::CHARACTER VARYING, 'Organização Religiosa'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sudeste'::CHARACTER VARYING, 'Organização Social'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sudeste'::CHARACTER VARYING, 'Sem informação'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sul'::CHARACTER VARYING, 'Associação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION
							SELECT 'Sul'::CHARACTER VARYING, 'Fundação Privada'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sul'::CHARACTER VARYING, 'Organização Religiosa'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sul'::CHARACTER VARYING, 'Organização Social'::TEXT, 0::BIGINT, null::TEXT[] 
							UNION 
							SELECT 'Sul'::CHARACTER VARYING, 'Sem informação'::TEXT, 0::BIGINT, null::TEXT[]
						) AS a 
						GROUP BY rotulo_1, rotulo_2 
						ORDER BY rotulo_1, rotulo_2
				) AS a 
				GROUP BY rotulo_2
			) AS b;
	END IF;
END;

$$ LANGUAGE 'plpgsql';
