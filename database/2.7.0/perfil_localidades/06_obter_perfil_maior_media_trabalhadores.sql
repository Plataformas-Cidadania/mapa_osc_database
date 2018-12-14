DROP FUNCTION IF EXISTS portal.obter_perfil_maior_media_trabalhadores(TEXT) CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_perfil_maior_media_trabalhadores(tipo_localidade TEXT) RETURNS TABLE (
	dados JSONB, 
	fontes TEXT[]
) AS $$ 

BEGIN
	CASE
		WHEN tipo_localidade = 'regiao' THEN
        	RETURN QUERY
				SELECT
					('{"localidades": [' || REPLACE(REPLACE(RTRIM(LTRIM(ARRAY_AGG(c.nm_localidade)::TEXT, '{'), '}'), '\', ''), '""', '"') || '], "tipo_trabalhadores": ' || c.tipo_trabalhadores::TEXT || ', "maior_media": ' || c.media::TEXT || '}')::JSONB AS dados,
					c.fontes::TEXT[] AS fontes
				FROM 
				(
					SELECT 
						'"' || nm_localidade || '"' AS nm_localidade,
						CASE 
							WHEN b.media_vinculos >= b.media_deficiencia AND b.media_vinculos >= b.media_voluntarios THEN
								'"vinculos"'
							WHEN b.media_deficiencia >= b.media_voluntarios THEN
								'"deficiencia"'
							ELSE
								'"voluntarios"'
						END AS tipo_trabalhadores,
						CASE 
							WHEN b.media_vinculos >= b.media_deficiencia AND b.media_vinculos >= b.media_voluntarios THEN
								b.media_vinculos
							WHEN b.media_deficiencia >= b.media_voluntarios THEN
								b.media_deficiencia
							ELSE
								b.media_voluntarios
						END AS media,
						b.fontes
					FROM (
						SELECT
							edre_nm_regiao AS nm_localidade,
							CASE WHEN SUM(COALESCE(nr_trabalhadores_vinculo, 0)) > 0 THEN
								SUM(COALESCE(nr_trabalhadores_vinculo, 0) + COALESCE(nr_trabalhadores_deficiencia, 0) + COALESCE(nr_trabalhadores_voluntarios, 0)) / SUM(COALESCE(nr_trabalhadores_vinculo, 0)) * 100
							ELSE
								0
							END AS media_vinculos,
							CASE WHEN SUM(COALESCE(nr_trabalhadores_deficiencia, 0)) > 0 THEN
								SUM(COALESCE(nr_trabalhadores_vinculo, 0) + COALESCE(nr_trabalhadores_deficiencia, 0) + COALESCE(nr_trabalhadores_voluntarios, 0)) / SUM(COALESCE(nr_trabalhadores_deficiencia, 0)) * 100
							ELSE
								0
							END AS media_deficiencia,
							CASE WHEN SUM(COALESCE(nr_trabalhadores_voluntarios, 0)) > 0 THEN
								SUM(COALESCE(nr_trabalhadores_vinculo, 0) + COALESCE(nr_trabalhadores_deficiencia, 0) + COALESCE(nr_trabalhadores_voluntarios, 0)) / SUM(COALESCE(nr_trabalhadores_voluntarios, 0)) * 100
							ELSE
								0
							END AS media_voluntarios,
							(
								SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
									ARRAY_CAT(
										ARRAY_CAT(
											ARRAY_CAT(
												ARRAY_AGG(DISTINCT COALESCE(ft_trabalhadores_vinculo, '')), 
												ARRAY_AGG(DISTINCT COALESCE(ft_municipio, ''))
											),
											ARRAY_AGG(DISTINCT COALESCE(ft_trabalhadores_deficiencia, ''))
										),
										ARRAY_AGG(DISTINCT COALESCE(ft_trabalhadores_voluntarios, ''))
									)
								)) AS a
							) AS fontes
						FROM osc.tb_dados_gerais
						LEFT JOIN osc.tb_localizacao
						ON tb_dados_gerais.id_osc = tb_localizacao.id_osc
						LEFT JOIN spat.ed_regiao
						ON ed_regiao.edre_cd_regiao = SUBSTRING(tb_localizacao.cd_municipio::TEXT from 1 for 1)::NUMERIC(1, 0)
						LEFT JOIN osc.tb_relacoes_trabalho
						ON tb_dados_gerais.id_osc = tb_relacoes_trabalho.id_osc
						WHERE (
							tb_relacoes_trabalho.nr_trabalhadores_vinculo IS NOT null
							OR tb_relacoes_trabalho.nr_trabalhadores_deficiencia IS NOT null
							OR tb_relacoes_trabalho.nr_trabalhadores_voluntarios IS NOT null
						)
						GROUP BY edre_nm_regiao
					) AS b
				) AS c
				GROUP BY c.fontes, c.media, c.tipo_trabalhadores
				ORDER BY c.media
				LIMIT 1;

		WHEN tipo_localidade = 'estado' THEN
        	RETURN QUERY
				SELECT
					('{"localidades": [' || REPLACE(REPLACE(RTRIM(LTRIM(ARRAY_AGG(c.nm_localidade)::TEXT, '{'), '}'), '\', ''), '""', '"') || '], "tipo_trabalhadores": ' || c.tipo_trabalhadores::TEXT || ', "maior_media": ' || c.media::TEXT || '}')::JSONB AS dados,
					c.fontes::TEXT[] AS fontes
				FROM 
				(
					SELECT 
						'"' || nm_localidade || '"' AS nm_localidade,
						CASE 
							WHEN b.media_vinculos >= b.media_deficiencia AND b.media_vinculos >= b.media_voluntarios THEN
								'"vinculos"'
							WHEN b.media_deficiencia >= b.media_voluntarios THEN
								'"deficiencia"'
							ELSE
								'"voluntarios"'
						END AS tipo_trabalhadores,
						CASE 
							WHEN b.media_vinculos >= b.media_deficiencia AND b.media_vinculos >= b.media_voluntarios THEN
								b.media_vinculos
							WHEN b.media_deficiencia >= b.media_voluntarios THEN
								b.media_deficiencia
							ELSE
								b.media_voluntarios
						END AS media,
						b.fontes
					FROM (
						SELECT
							eduf_nm_uf AS nm_localidade,
							CASE WHEN SUM(COALESCE(nr_trabalhadores_vinculo, 0)) > 0 THEN
								SUM(COALESCE(nr_trabalhadores_vinculo, 0) + COALESCE(nr_trabalhadores_deficiencia, 0) + COALESCE(nr_trabalhadores_voluntarios, 0)) / SUM(COALESCE(nr_trabalhadores_vinculo, 0)) * 100
							ELSE
								0
							END AS media_vinculos,
							CASE WHEN SUM(COALESCE(nr_trabalhadores_deficiencia, 0)) > 0 THEN
								SUM(COALESCE(nr_trabalhadores_vinculo, 0) + COALESCE(nr_trabalhadores_deficiencia, 0) + COALESCE(nr_trabalhadores_voluntarios, 0)) / SUM(COALESCE(nr_trabalhadores_deficiencia, 0)) * 100
							ELSE
								0
							END AS media_deficiencia,
							CASE WHEN SUM(COALESCE(nr_trabalhadores_voluntarios, 0)) > 0 THEN
								SUM(COALESCE(nr_trabalhadores_vinculo, 0) + COALESCE(nr_trabalhadores_deficiencia, 0) + COALESCE(nr_trabalhadores_voluntarios, 0)) / SUM(COALESCE(nr_trabalhadores_voluntarios, 0)) * 100
							ELSE
								0
							END AS media_voluntarios,
							(
								SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
									ARRAY_CAT(
										ARRAY_CAT(
											ARRAY_CAT(
												ARRAY_AGG(DISTINCT COALESCE(ft_trabalhadores_vinculo, '')), 
												ARRAY_AGG(DISTINCT COALESCE(ft_municipio, ''))
											),
											ARRAY_AGG(DISTINCT COALESCE(ft_trabalhadores_deficiencia, ''))
										),
										ARRAY_AGG(DISTINCT COALESCE(ft_trabalhadores_voluntarios, ''))
									)
								)) AS a
							) AS fontes
						FROM osc.tb_dados_gerais
						LEFT JOIN osc.tb_localizacao
						ON tb_dados_gerais.id_osc = tb_localizacao.id_osc
						LEFT JOIN spat.ed_uf
						ON ed_uf.eduf_cd_uf = SUBSTRING(tb_localizacao.cd_municipio::TEXT from 1 for 2)::NUMERIC(2, 0)
						LEFT JOIN osc.tb_relacoes_trabalho
						ON tb_dados_gerais.id_osc = tb_relacoes_trabalho.id_osc
						WHERE (
							tb_relacoes_trabalho.nr_trabalhadores_vinculo IS NOT null
							OR tb_relacoes_trabalho.nr_trabalhadores_deficiencia IS NOT null
							OR tb_relacoes_trabalho.nr_trabalhadores_voluntarios IS NOT null
						)
						GROUP BY eduf_nm_uf
					) AS b
				) AS c
				GROUP BY c.fontes, c.media, c.tipo_trabalhadores
				ORDER BY c.media
				LIMIT 1;

		WHEN tipo_localidade = 'municipio' THEN
        	RETURN QUERY
				SELECT
					('{"localidades": [' || REPLACE(REPLACE(RTRIM(LTRIM(ARRAY_AGG(c.nm_localidade)::TEXT, '{'), '}'), '\', ''), '""', '"') || '], "tipo_trabalhadores": ' || c.tipo_trabalhadores::TEXT || ', "maior_media": ' || c.media::TEXT || '}')::JSONB AS dados,
					c.fontes::TEXT[] AS fontes
				FROM 
				(
					SELECT 
						'"' || nm_localidade || '"' AS nm_localidade,
						CASE 
							WHEN b.media_vinculos >= b.media_deficiencia AND b.media_vinculos >= b.media_voluntarios THEN
								'"vinculos"'
							WHEN b.media_deficiencia >= b.media_voluntarios THEN
								'"deficiencia"'
							ELSE
								'"voluntarios"'
						END AS tipo_trabalhadores,
						CASE 
							WHEN b.media_vinculos >= b.media_deficiencia AND b.media_vinculos >= b.media_voluntarios THEN
								b.media_vinculos
							WHEN b.media_deficiencia >= b.media_voluntarios THEN
								b.media_deficiencia
							ELSE
								b.media_voluntarios
						END AS media,
						b.fontes
					FROM (
						SELECT
							edmu_nm_municipio || ' - ' || eduf_sg_uf AS nm_localidade,
							CASE WHEN SUM(COALESCE(nr_trabalhadores_vinculo, 0)) > 0 THEN
								SUM(COALESCE(nr_trabalhadores_vinculo, 0) + COALESCE(nr_trabalhadores_deficiencia, 0) + COALESCE(nr_trabalhadores_voluntarios, 0)) / SUM(COALESCE(nr_trabalhadores_vinculo, 0)) * 100
							ELSE
								0
							END AS media_vinculos,
							CASE WHEN SUM(COALESCE(nr_trabalhadores_deficiencia, 0)) > 0 THEN
								SUM(COALESCE(nr_trabalhadores_vinculo, 0) + COALESCE(nr_trabalhadores_deficiencia, 0) + COALESCE(nr_trabalhadores_voluntarios, 0)) / SUM(COALESCE(nr_trabalhadores_deficiencia, 0)) * 100
							ELSE
								0
							END AS media_deficiencia,
							CASE WHEN SUM(COALESCE(nr_trabalhadores_voluntarios, 0)) > 0 THEN
								SUM(COALESCE(nr_trabalhadores_vinculo, 0) + COALESCE(nr_trabalhadores_deficiencia, 0) + COALESCE(nr_trabalhadores_voluntarios, 0)) / SUM(COALESCE(nr_trabalhadores_voluntarios, 0)) * 100
							ELSE
								0
							END AS media_voluntarios,
							(
								SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
									ARRAY_CAT(
										ARRAY_CAT(
											ARRAY_CAT(
												ARRAY_AGG(DISTINCT COALESCE(ft_trabalhadores_vinculo, '')), 
												ARRAY_AGG(DISTINCT COALESCE(ft_municipio, ''))
											),
											ARRAY_AGG(DISTINCT COALESCE(ft_trabalhadores_deficiencia, ''))
										),
										ARRAY_AGG(DISTINCT COALESCE(ft_trabalhadores_voluntarios, ''))
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
						LEFT JOIN osc.tb_relacoes_trabalho
						ON tb_dados_gerais.id_osc = tb_relacoes_trabalho.id_osc
						WHERE (
							tb_relacoes_trabalho.nr_trabalhadores_vinculo IS NOT null
							OR tb_relacoes_trabalho.nr_trabalhadores_deficiencia IS NOT null
							OR tb_relacoes_trabalho.nr_trabalhadores_voluntarios IS NOT null
						)
						GROUP BY edmu_nm_municipio, eduf_sg_uf
					) AS b
				) AS c
				GROUP BY c.fontes, c.media, c.tipo_trabalhadores
				ORDER BY c.media
				LIMIT 1;

		ELSE
			RETURN QUERY
				SELECT null::JSONB, null::TEXT[];
    END CASE;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_perfil_maior_media_trabalhadores('regiao'::TEXT);
