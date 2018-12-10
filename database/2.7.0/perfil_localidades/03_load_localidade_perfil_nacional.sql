DROP FUNCTION IF EXISTS portal.load_localidade_perfil_nacional() CASCADE;

CREATE OR REPLACE FUNCTION portal.load_localidade_perfil_nacional() RETURNS VOID AS $$ 

DECLARE
    porcentagem_maior_media_natureza_juridica_regiao NUMERIC;
    porcentagem_maior_media_natureza_juridica_estado NUMERIC;
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

	SELECT INTO porcentagem_maior_media_natureza_juridica_regiao 
		AVG(a.quantidade) AS media 
	FROM (
		SELECT cd_municipio, cd_natureza_juridica_osc, COUNT(*) AS quantidade
		FROM osc.tb_dados_gerais
		LEFT JOIN osc.tb_localizacao
		ON tb_dados_gerais.id_osc = tb_localizacao.id_osc
		WHERE cd_natureza_juridica_osc IS NOT null
		GROUP BY (cd_natureza_juridica_osc, cd_municipio)
	) AS a
	GROUP BY a.cd_natureza_juridica_osc
	ORDER BY media DESC
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
