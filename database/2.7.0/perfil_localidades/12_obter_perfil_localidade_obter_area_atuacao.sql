DROP FUNCTION IF EXISTS portal.obter_perfil_localidade_obter_area_atuacao(INTEGER) CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_perfil_localidade_obter_area_atuacao(id_localidade INTEGER) RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

BEGIN 
	RETURN QUERY
		SELECT
			('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG(
				'{' ||
					'"tx_nome_area_atuacao": "' || a.tx_nome_area_atuacao::TEXT || '", ' ||
					'"nr_quantidade_oscs": "' || a.nr_quantidade_oscs::TEXT ||  '"' ||
				'}'
			)::TEXT, '\', '') || '}'), '{"{"', '{"'), '"}"}', '"}'), '","', ','), '{'), '}') || '}]')::JSONB AS dados,
			(
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()\"', '')) FROM (SELECT DISTINCT UNNEST(
					TRANSLATE(ARRAY_AGG(REPLACE(REPLACE(TRIM(TRANSLATE(a.fontes::TEXT, '"\{}', ''), ','), '","', ','), ',,', ','))::TEXT, '"', '')::TEXT[]
				)) AS a
			) AS fontes 
		FROM (
			SELECT 
				COALESCE(dc_area_atuacao.tx_nome_area_atuacao, 'Sem informação') AS tx_nome_area_atuacao,
				COUNT(tb_osc) AS nr_quantidade_oscs,
				(
					SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
							ARRAY_CAT(
								ARRAY_CAT(
									ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')), 
									ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
								),
								ARRAY_AGG(DISTINCT COALESCE(tb_area_atuacao.ft_area_atuacao, ''))
							)
						)
					) AS a
				) AS fontes
			FROM osc.tb_osc
			LEFT JOIN osc.tb_area_atuacao
			ON tb_osc.id_osc = tb_area_atuacao.id_osc
			LEFT JOIN syst.dc_area_atuacao
			ON tb_area_atuacao.cd_area_atuacao = dc_area_atuacao.cd_area_atuacao
			LEFT JOIN osc.tb_localizacao
			ON tb_osc.id_osc = tb_localizacao.id_osc
			LEFT JOIN spat.ed_regiao
			ON (SELECT SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1))::NUMERIC(1, 0) = ed_regiao.edre_cd_regiao
			WHERE tb_osc.bo_osc_ativa
			AND tb_osc.id_osc <> 789809
			AND (
				SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1) = id_localidade::TEXT
				OR
				SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2) = id_localidade::TEXT
				OR
				tb_localizacao.cd_municipio = id_localidade
			)
			GROUP BY dc_area_atuacao.tx_nome_area_atuacao
		) AS a;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_perfil_localidade_obter_area_atuacao(35);
