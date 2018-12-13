DROP FUNCTION IF EXISTS portal.load_localidade_perfil_nacional() CASCADE;

CREATE OR REPLACE FUNCTION portal.load_localidade_perfil_nacional() RETURNS VOID AS $$ 

DECLARE
	municpios_maior_media_natureza_juridica_regiao TEXT[];
    porcentagem_maior_media_natureza_juridica_regiao NUMERIC;
	municpios_maior_media_natureza_juridica_estado TEXT[];
    porcentagem_maior_media_natureza_juridica_estado NUMERIC;
	municpios_maior_media_natureza_juridica_municipio TEXT[];
    porcentagem_maior_media_natureza_juridica_municipio NUMERIC;
    porcentagem_maior_media_nacional_natureza_juridica_regiao NUMERIC;
    porcentagem_maior_media_nacional_natureza_juridica_estado NUMERIC;
    porcentagem_maior_media_nacional_natureza_juridica_municipio NUMERIC;
    media_nacional_repasse_regiao NUMERIC;
    media_nacional_repasse_estado NUMERIC;
    media_nacional_repasse_municipio NUMERIC;
    porcentagem_maior_media_nacional_area_atuacao_regiao NUMERIC;
    porcentagem_maior_media_nacional_area_atuacao_estado NUMERIC;
    porcentagem_maior_media_nacional_area_atuacao_municipio NUMERIC;
    nome_porcentagem_maior_media_nacional_area_atuacao_regiao NUMERIC;
    nome_porcentagem_maior_media_nacional_area_atuacao_estado NUMERIC;
    nome_porcentagem_maior_media_nacional_area_atuacao_municipio NUMERIC;
    porcentagem_maior_media_nacional_trabalhadores_regiao NUMERIC;
    porcentagem_maior_media_nacional_trabalhadores_estado NUMERIC;
    porcentagem_maior_media_nacional_trabalhadores_municipio NUMERIC;
    nome_porcentagem_maior_media_nacional_trabalhadores_regiao NUMERIC;
    nome_porcentagem_maior_media_nacional_trabalhadores_estado NUMERIC;
    nome_porcentagem_maior_media_nacional_trabalhadores_municipio NUMERIC;

BEGIN
	DELETE FROM portal.tb_perfil_nacional;

	SELECT INTO municpios_maior_media_natureza_juridica_municipio, porcentagem_maior_media_natureza_juridica_regiao 
			ARRAY_AGG(b.nm_localidade),	b.media
		FROM 
		(
			SELECT a.nm_localidade, MAX(a.quantidade) / SUM(a.quantidade) * 100 AS media
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

	RAISE NOTICE '%', porcentagem_maior_media_natureza_juridica_regiao;
	/*
	INSERT INTO
		portal.tb_perfil_naiconal(
			nr_porcentagem_maior_media_natureza_juridica_regiao,
			nr_porcentagem_maior_media_natureza_juridica_estado,
			nr_porcentagem_maior_media_natureza_juridica_municipio,
			tx_porcentagem_maior_media_nacional_natureza_juridica_regiao,
			tx_porcentagem_maior_media_nacional_natureza_juridica_estado,
			tx_porcentagem_maior_media_nacional_natureza_juridica_municipio,
			nr_media_nacional_repasse_regiao,
			nr_media_nacional_repasse_estado,
			nr_media_nacional_repasse_municipio,
			nr_porcentagem_maior_media_nacional_area_atuacao_regiao,
			nr_porcentagem_maior_media_nacional_area_atuacao_estado,
			nr_porcentagem_maior_media_nacional_area_atuacao_municipio,
			tx_porcentagem_maior_media_nacional_area_atuacao_regiao,
			tx_porcentagem_maior_media_nacional_area_atuacao_estado,
			tx_porcentagem_maior_media_nacional_area_atuacao_municipio,
			nr_porcentagem_maior_media_nacional_trabalhadores_regiao,
			nr_porcentagem_maior_media_nacional_trabalhadores_estado,
			nr_porcentagem_maior_media_nacional_trabalhadores_municipio,
			tx_porcentagem_maior_media_nacional_trabalhadores_regiao,
			tx_porcentagem_maior_media_nacional_trabalhadores_estado,
			tx_porcentagem_maior_media_nacional_trabalhadores_municipio,
		) VALUES (

		);
	*/

END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.load_localidade_perfil_nacional();
