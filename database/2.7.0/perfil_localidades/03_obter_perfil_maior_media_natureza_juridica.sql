DROP FUNCTION IF EXISTS portal.obter_perfil_maior_media_natureza_juridica(TEXT) CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_perfil_maior_media_natureza_juridica(tipo_localidade TEXT) RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

BEGIN
	CASE
		WHEN tipo_localidade = 'regiao' THEN
        	RETURN QUERY
				SELECT
					('{"localidades": [' || REPLACE(REPLACE(RTRIM(LTRIM(ARRAY_AGG(b.nm_localidade)::TEXT, '{'), '}'), '\', ''), '""', '"') || '], "natureza_juridica": ' || b.natureza_juridica::TEXT || ', "maior_media": ' || b.media::TEXT || '}')::JSONB AS dados,
					b.fontes::TEXT[] AS fontes
				FROM 
				(
					SELECT
						'"' || a.nm_localidade || '"' AS nm_localidade,
						'"' || a.natureza_juridica || '"' AS natureza_juridica,
						MAX(a.quantidade) / SUM(a.quantidade) * 100 AS media,
						(
							SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()\"', '')) FROM (SELECT DISTINCT UNNEST(
								TRANSLATE(ARRAY_AGG(REPLACE(REPLACE(TRIM(TRANSLATE(a.fontes::TEXT, '"\{}', ''), ','), '","', ','), ',,', ','))::TEXT, '"', '')::TEXT[]
							)) AS a
						) AS fontes
					FROM (
						SELECT
							edre_nm_regiao AS nm_localidade,
							tx_nome_natureza_juridica AS natureza_juridica,
							COUNT(*) AS quantidade,
							(
								SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
									ARRAY_CAT(
										ARRAY_AGG(DISTINCT COALESCE(ft_natureza_juridica_osc, '')), 
										ARRAY_AGG(DISTINCT COALESCE(ft_municipio, ''))
									)
								)) AS a
							) AS fontes
						FROM osc.tb_dados_gerais
						LEFT JOIN osc.tb_localizacao
						ON tb_dados_gerais.id_osc = tb_localizacao.id_osc
						LEFT JOIN spat.ed_regiao
						ON ed_regiao.edre_cd_regiao = SUBSTRING(tb_localizacao.cd_municipio::TEXT from 1 for 1)::NUMERIC(1, 0)
						LEFT JOIN syst.dc_natureza_juridica
						ON tb_dados_gerais.cd_natureza_juridica_osc = dc_natureza_juridica.cd_natureza_juridica
						WHERE cd_natureza_juridica_osc IS NOT null
						GROUP BY tx_nome_natureza_juridica, edre_nm_regiao
					) AS a
					GROUP BY a.nm_localidade, a.natureza_juridica
				) AS b
				GROUP BY b.natureza_juridica, b.media, b.fontes
				ORDER BY b.media DESC
				LIMIT 1;

		WHEN tipo_localidade = 'estado' THEN
        	RETURN QUERY
				SELECT
					('{"localidades": [' || REPLACE(REPLACE(RTRIM(LTRIM(ARRAY_AGG(b.nm_localidade)::TEXT, '{'), '}'), '\', ''), '""', '"') || '], "natureza_juridica": ' || b.natureza_juridica::TEXT || ', "maior_media": ' || b.media::TEXT || '}')::JSONB AS dados,
					b.fontes::TEXT[] AS fontes
				FROM 
				(
					SELECT
						'"' || a.nm_localidade || '"' AS nm_localidade,
						'"' || a.natureza_juridica || '"' AS natureza_juridica,
						MAX(a.quantidade) / SUM(a.quantidade) * 100 AS media,
						(
							SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()\"', '')) FROM (SELECT DISTINCT UNNEST(
								TRANSLATE(ARRAY_AGG(REPLACE(REPLACE(TRIM(TRANSLATE(a.fontes::TEXT, '"\{}', ''), ','), '","', ','), ',,', ','))::TEXT, '"', '')::TEXT[]
							)) AS a
						) AS fontes
					FROM (
						SELECT
							eduf_nm_uf AS nm_localidade,
							tx_nome_natureza_juridica AS natureza_juridica,
							COUNT(*) AS quantidade,
							(
								SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
									ARRAY_CAT(
										ARRAY_AGG(DISTINCT COALESCE(ft_natureza_juridica_osc, '')), 
										ARRAY_AGG(DISTINCT COALESCE(ft_municipio, ''))
									)
								)) AS a
							) AS fontes
						FROM osc.tb_dados_gerais
						LEFT JOIN osc.tb_localizacao
						ON tb_dados_gerais.id_osc = tb_localizacao.id_osc
						LEFT JOIN spat.ed_uf
						ON ed_uf.eduf_cd_uf = SUBSTRING(tb_localizacao.cd_municipio::TEXT from 1 for 2)::NUMERIC(2, 0)
						LEFT JOIN syst.dc_natureza_juridica
						ON tb_dados_gerais.cd_natureza_juridica_osc = dc_natureza_juridica.cd_natureza_juridica
						WHERE cd_natureza_juridica_osc IS NOT null
						GROUP BY tx_nome_natureza_juridica, eduf_nm_uf
						ORDER BY quantidade DESC
					) AS a
					GROUP BY a.nm_localidade, a.natureza_juridica
				) AS b
				GROUP BY b.natureza_juridica, b.media, b.fontes
				ORDER BY b.media DESC
				LIMIT 1;

		WHEN tipo_localidade = 'municipio' THEN
        	RETURN QUERY
				SELECT
					('{"localidades": [' || REPLACE(REPLACE(RTRIM(LTRIM(ARRAY_AGG(b.nm_localidade)::TEXT, '{'), '}'), '\', ''), '""', '"') || '], "natureza_juridica": ' || b.natureza_juridica::TEXT || ', "maior_media": ' || b.media::TEXT || '}')::JSONB AS dados,
					b.fontes::TEXT[] AS fontes
				FROM 
				(
					SELECT
						'"' || a.nm_localidade || '"' AS nm_localidade,
						'"' || a.natureza_juridica || '"' AS natureza_juridica,
						MAX(a.quantidade) / SUM(a.quantidade) * 100 AS media,
						(
							SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()\"', '')) FROM (SELECT DISTINCT UNNEST(
								TRANSLATE(ARRAY_AGG(REPLACE(REPLACE(TRIM(TRANSLATE(a.fontes::TEXT, '"\{}', ''), ','), '","', ','), ',,', ','))::TEXT, '"', '')::TEXT[]
							)) AS a
						) AS fontes
					FROM (
						SELECT
							edmu_nm_municipio || ' - ' || eduf_sg_uf AS nm_localidade,
							tx_nome_natureza_juridica AS natureza_juridica,
							COUNT(*) AS quantidade,
							(
								SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
									ARRAY_CAT(
										ARRAY_AGG(DISTINCT COALESCE(ft_natureza_juridica_osc, '')), 
										ARRAY_AGG(DISTINCT COALESCE(ft_municipio, ''))
									)
								)) AS a
							) AS fontes
						FROM osc.tb_dados_gerais
						LEFT JOIN osc.tb_localizacao
						ON tb_dados_gerais.id_osc = tb_localizacao.id_osc
						LEFT JOIN spat.ed_municipio
						ON tb_localizacao.cd_municipio = ed_municipio.edmu_cd_municipio
						LEFT JOIN spat.ed_uf
						ON ed_municipio.eduf_cd_uf = ed_uf.eduf_cd_uf
						LEFT JOIN syst.dc_natureza_juridica
						ON tb_dados_gerais.cd_natureza_juridica_osc = dc_natureza_juridica.cd_natureza_juridica
						WHERE cd_natureza_juridica_osc IS NOT null
						GROUP BY tx_nome_natureza_juridica, edmu_nm_municipio, eduf_sg_uf
						ORDER BY quantidade DESC
					) AS a
					GROUP BY a.nm_localidade, a.natureza_juridica
				) AS b
				GROUP BY b.natureza_juridica, b.media, b.fontes
				ORDER BY b.media DESC
				LIMIT 1;

		ELSE
			RETURN QUERY
				SELECT null::JSONB, null::TEXT[];
    END CASE;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_perfil_maior_media_natureza_juridica('regiao'::TEXT);
