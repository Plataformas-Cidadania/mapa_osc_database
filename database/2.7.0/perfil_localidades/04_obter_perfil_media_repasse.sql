DROP FUNCTION IF EXISTS portal.obter_perfil_media_repasse(TEXT) CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_perfil_media_repasse(tipo_localidade TEXT) RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

BEGIN
	CASE
		WHEN tipo_localidade = 'regiao' THEN
        	RETURN QUERY
				SELECT
					('{"localidades": [' || REPLACE(REPLACE(RTRIM(LTRIM(ARRAY_AGG(b.nm_localidade)::TEXT, '{'), '}'), '\', ''), '""', '"') || '], "maior_media": ' || b.media::TEXT || '}')::JSONB AS dados,
					b.fontes::TEXT[] AS fontes
				FROM 
				(
					SELECT
						'"' || edre_nm_regiao || '"' AS nm_localidade,
						SUM(nr_valor_recursos_osc) / COUNT(*) AS media,
						(
							SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
								ARRAY_CAT(
									ARRAY_AGG(DISTINCT COALESCE(ft_valor_recursos_osc, '')), 
									ARRAY_AGG(DISTINCT COALESCE(ft_municipio, ''))
								)
							)) AS a
						) AS fontes
					FROM osc.tb_dados_gerais
					LEFT JOIN osc.tb_localizacao
					ON tb_dados_gerais.id_osc = tb_localizacao.id_osc
					LEFT JOIN osc.tb_recursos_osc
					ON tb_dados_gerais.id_osc = tb_recursos_osc.id_osc
					LEFT JOIN spat.ed_regiao
					ON ed_regiao.edre_cd_regiao = SUBSTRING(tb_localizacao.cd_municipio::TEXT from 1 for 1)::NUMERIC(1, 0)
					WHERE nr_valor_recursos_osc IS NOT null
					GROUP BY edre_nm_regiao
				) AS b
				GROUP BY b.media, b.fontes
				ORDER BY b.media DESC
				LIMIT 1;

		WHEN tipo_localidade = 'estado' THEN
        	RETURN QUERY
				SELECT
					('{"localidades": [' || REPLACE(REPLACE(RTRIM(LTRIM(ARRAY_AGG(b.nm_localidade)::TEXT, '{'), '}'), '\', ''), '""', '"') || '], "maior_media": ' || b.media::TEXT || '}')::JSONB AS dados,
					b.fontes::TEXT[] AS fontes
				FROM 
				(
					SELECT
						'"' || eduf_nm_uf || '"' AS nm_localidade,
						SUM(nr_valor_recursos_osc) / COUNT(*) AS media,
						(
							SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
								ARRAY_CAT(
									ARRAY_AGG(DISTINCT COALESCE(ft_valor_recursos_osc, '')), 
									ARRAY_AGG(DISTINCT COALESCE(ft_municipio, ''))
								)
							)) AS a
						) AS fontes
					FROM osc.tb_dados_gerais
					LEFT JOIN osc.tb_localizacao
					ON tb_dados_gerais.id_osc = tb_localizacao.id_osc
					LEFT JOIN osc.tb_recursos_osc
					ON tb_dados_gerais.id_osc = tb_recursos_osc.id_osc
					LEFT JOIN spat.ed_uf
					ON ed_uf.eduf_cd_uf = SUBSTRING(tb_localizacao.cd_municipio::TEXT from 1 for 2)::NUMERIC(2, 0)
					WHERE nr_valor_recursos_osc IS NOT null
					GROUP BY eduf_nm_uf
				) AS b
				GROUP BY b.media, b.fontes
				ORDER BY b.media DESC
				LIMIT 1;

		WHEN tipo_localidade = 'municipio' THEN
        	RETURN QUERY
				SELECT
					('{"localidades": [' || REPLACE(REPLACE(RTRIM(LTRIM(ARRAY_AGG(b.nm_localidade)::TEXT, '{'), '}'), '\', ''), '""', '"') || '], "maior_media": ' || b.media::TEXT || '}')::JSONB AS dados,
					b.fontes::TEXT[] AS fontes
				FROM 
				(
					SELECT
						'"' || edmu_nm_municipio || ' - ' || eduf_sg_uf || '"' AS nm_localidade,
						SUM(nr_valor_recursos_osc) / COUNT(*) AS media,
						(
							SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
								ARRAY_CAT(
									ARRAY_AGG(DISTINCT COALESCE(ft_valor_recursos_osc, '')), 
									ARRAY_AGG(DISTINCT COALESCE(ft_municipio, ''))
								)
							)) AS a
						) AS fontes
					FROM osc.tb_dados_gerais
					LEFT JOIN osc.tb_localizacao
					ON tb_dados_gerais.id_osc = tb_localizacao.id_osc
					LEFT JOIN osc.tb_recursos_osc
					ON tb_dados_gerais.id_osc = tb_recursos_osc.id_osc
					LEFT JOIN spat.ed_municipio
					ON tb_localizacao.cd_municipio = ed_municipio.edmu_cd_municipio
					LEFT JOIN spat.ed_uf
					ON ed_municipio.eduf_cd_uf = ed_uf.eduf_cd_uf
					WHERE nr_valor_recursos_osc IS NOT null
					GROUP BY edmu_nm_municipio, eduf_sg_uf
				) AS b
				GROUP BY b.media, b.fontes
				ORDER BY b.media DESC
				LIMIT 1;

		ELSE
			RETURN QUERY
				SELECT null::JSONB, null::TEXT[];
    END CASE;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_perfil_media_repasse('regiao'::TEXT);
