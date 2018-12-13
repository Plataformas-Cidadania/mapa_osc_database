DROP TABLE IF EXISTS portal.tb_perfil_nacional;

CREATE TABLE portal.tb_perfil_nacional
(
    tx_maior_media_nacional_natureza_juridica_regiao TEXT[],
    nr_porcentagem_maior_media_natureza_juridica_regiao NUMERIC,
    tx_maior_media_nacional_natureza_juridica_estado TEXT[],
    nr_porcentagem_maior_media_natureza_juridica_estado NUMERIC,
    tx_maior_media_nacional_natureza_juridica_municipio TEXT[],
    nr_porcentagem_maior_media_natureza_juridica_municipio NUMERIC,
    nr_media_nacional_repasse_regiao NUMERIC,
    nr_media_nacional_repasse_estado NUMERIC,
    nr_media_nacional_repasse_municipio NUMERIC,
    tx_maior_media_nacional_area_atuacao_regiao TEXT[],
    nr_porcentagem_maior_media_nacional_area_atuacao_regiao NUMERIC,
    tx_maior_media_nacional_area_atuacao_estado TEXT[],
    nr_porcentagem_maior_media_nacional_area_atuacao_estado NUMERIC,
    tx_maior_media_nacional_area_atuacao_municipio TEXT[],
    nr_porcentagem_maior_media_nacional_area_atuacao_municipio NUMERIC,
    tx_porcentagem_maior_media_nacional_area_atuacao_regiao NUMERIC,
    tx_porcentagem_maior_media_nacional_area_atuacao_estado NUMERIC,
    tx_porcentagem_maior_media_nacional_area_atuacao_municipio NUMERIC,
    nr_porcentagem_maior_media_nacional_trabalhadores_regiao NUMERIC,
    nr_porcentagem_maior_media_nacional_trabalhadores_estado NUMERIC,
    nr_porcentagem_maior_media_nacional_trabalhadores_municipio NUMERIC,
    tx_porcentagem_maior_media_nacional_trabalhadores_regiao NUMERIC,
    tx_porcentagem_maior_media_nacional_trabalhadores_estado NUMERIC,
    tx_porcentagem_maior_media_nacional_trabalhadores_municipio NUMERIC
);
