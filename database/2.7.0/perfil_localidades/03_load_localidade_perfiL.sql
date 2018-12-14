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
					('{"localidades": [' || REPLACE(REPLACE(RTRIM(LTRIM(ARRAY_AGG(b.nm_localidade)::TEXT, '{'), '}'), '\', ''), '""', '"') || '], "maior_media": ' || b.media::TEXT || '}')::JSONB AS dados,
					null::TEXT[] AS fontes
				FROM 
				(
					SELECT '"' || a.nm_localidade || '"' AS nm_localidade, MAX(a.quantidade) / SUM(a.quantidade) * 100 AS media
					FROM (
						SELECT edre_nm_regiao AS nm_localidade, cd_natureza_juridica_osc, COUNT(*) AS quantidade
						FROM osc.tb_dados_gerais
						LEFT JOIN osc.tb_localizacao
						ON tb_dados_gerais.id_osc = tb_localizacao.id_osc
						LEFT JOIN spat.ed_regiao
						ON ed_regiao.edre_cd_regiao = SUBSTRING(tb_localizacao.cd_municipio::TEXT from 1 for 1)::NUMERIC(1, 0)
						WHERE cd_natureza_juridica_osc IS NOT null
						GROUP BY cd_natureza_juridica_osc, edre_nm_regiao
						ORDER BY quantidade DESC
					) AS a
					GROUP BY a.nm_localidade
				) AS b
				GROUP BY b.media
				ORDER BY b.media DESC
				LIMIT 1;
		WHEN tipo_localidade = 'estado' THEN
        	RETURN QUERY
				SELECT
					('{"localidades": [' || REPLACE(REPLACE(RTRIM(LTRIM(ARRAY_AGG(b.nm_localidade)::TEXT, '{'), '}'), '\', ''), '""', '"') || '], "maior_media": ' || b.media::TEXT || '}')::JSONB AS dados,
					null::TEXT[] AS fontes
				FROM 
				(
					SELECT '"' || a.nm_localidade || '"' AS nm_localidade, MAX(a.quantidade) / SUM(a.quantidade) * 100 AS media
					FROM (
						SELECT eduf_nm_uf AS nm_localidade, cd_natureza_juridica_osc, COUNT(*) AS quantidade
						FROM osc.tb_dados_gerais
						LEFT JOIN osc.tb_localizacao
						ON tb_dados_gerais.id_osc = tb_localizacao.id_osc
						LEFT JOIN spat.ed_uf
						ON ed_uf.eduf_cd_uf = SUBSTRING(tb_localizacao.cd_municipio::TEXT from 1 for 2)::NUMERIC(2, 0)
						WHERE cd_natureza_juridica_osc IS NOT null
						GROUP BY cd_natureza_juridica_osc, eduf_nm_uf
						ORDER BY quantidade DESC
					) AS a
					GROUP BY a.nm_localidade
				) AS b
				GROUP BY b.media
				ORDER BY b.media DESC
				LIMIT 1;

		WHEN tipo_localidade = 'municipio' THEN
        	RETURN QUERY
				SELECT
					('{"localidades": [' || REPLACE(REPLACE(RTRIM(LTRIM(ARRAY_AGG(b.nm_localidade)::TEXT, '{'), '}'), '\', ''), '""', '"') || '], "maior_media": ' || b.media::TEXT || '}')::JSONB AS dados,
					null::TEXT[] AS fontes
				FROM 
				(
					SELECT '"' || a.nm_localidade || '"' AS nm_localidade, MAX(a.quantidade) / SUM(a.quantidade) * 100 AS media
					FROM (
						SELECT edmu_nm_municipio || ' - ' || eduf_sg_uf AS nm_localidade, cd_natureza_juridica_osc, COUNT(*) AS quantidade
						FROM osc.tb_dados_gerais
						LEFT JOIN osc.tb_localizacao
						ON tb_dados_gerais.id_osc = tb_localizacao.id_osc
						LEFT JOIN spat.ed_municipio
						ON tb_localizacao.cd_municipio = ed_municipio.edmu_cd_municipio
						LEFT JOIN spat.ed_uf
						ON ed_municipio.eduf_cd_uf = ed_uf.eduf_cd_uf
						WHERE cd_natureza_juridica_osc IS NOT null
						GROUP BY cd_natureza_juridica_osc, edmu_nm_municipio, eduf_sg_uf
						ORDER BY quantidade DESC
					) AS a
					GROUP BY a.nm_localidade
				) AS b
				GROUP BY b.media
				ORDER BY b.media DESC
				LIMIT 1;

		ELSE
			RETURN QUERY
				SELECT null::JSONB, null::TEXT[];
    END CASE;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_perfil_maior_media_natureza_juridica('regiao'::TEXT);
