DROP FUNCTION IF EXISTS portal.load_localidade_perfil_localidade() CASCADE;

CREATE OR REPLACE FUNCTION portal.load_localidade_perfil_localidade() RETURNS VOID AS $$ 

DECLARE
	localidades RECORD;
	id INTEGER;
    nome_localidade TEXT;
	nome_tipo_localidade TEXT;
    colocacao_nacional_quantidade_osc_regiao INTEGER;
    colocacao_nacional_quantidade_osc_estado INTEGER;
    colocacao_nacional_quantidade_osc_municipio INTEGER;
    porcentagem_maior_media_natureza_juridica_regiao NUMERIC;
    porcentagem_maior_media_natureza_juridica_estado NUMERIC;
    porcentagem_maior_media_natureza_juridica_municipio NUMERIC;
    porcentagem_maior_media_nacional_natureza_juridica_regiao NUMERIC;
    porcentagem_maior_media_nacional_natureza_juridica_estado NUMERIC;
    porcentagem_maior_media_nacional_natureza_juridica_municipio NUMERIC;
    colocacao_nacional_repasses_regiao INTEGER;
    colocacao_nacional_repasses_estado INTEGER;
    colocacao_nacional_repasses_municipio INTEGER;
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
	FOR osc IN
        SELECT edre_cd_regiao::NUMERIC AS id_localidade FROM spat.ed_regiao
		UNION
		SELECT eduf_cd_uf::NUMERIC AS id_localidade FROM spat.ed_uf
		UNION
		SELECT edmu_cd_municipio::NUMERIC AS id_localidade FROM spat.ed_municipio
    LOOP
		INSERT INTO
			portal.tb_perfil_localidade(
				id_localidade,
				tx_localidade,
				tx_tipo_localidade,
				nr_colocacao_nacional_quantidade_osc_regiao,
				nr_colocacao_nacional_quantidade_osc_estado,
				nr_colocacao_nacional_quantidade_osc_municipio,
				nr_porcentagem_maior_media_natureza_juridica_regiao,
				nr_porcentagem_maior_media_natureza_juridica_estado,
				nr_porcentagem_maior_media_natureza_juridica_municipio,
				tx_porcentagem_maior_media_nacional_natureza_juridica_regiao,
				tx_porcentagem_maior_media_nacional_natureza_juridica_estado,
				tx_porcentagem_maior_media_nacional_natureza_juridica_municipio,
				nr_colocacao_nacional_repasses_regiao,
				nr_colocacao_nacional_repasses_estado,
				nr_colocacao_nacional_repasses_municipio,
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
		END LOOP;
		
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.load_localidade_perfil_localidade();
