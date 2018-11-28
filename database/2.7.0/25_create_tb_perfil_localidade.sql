DROP TABLE IF EXISTS portal.tb_perfil_localidade;

CREATE TABLE portal.tb_perfil_localidade
(
    id_perfil_localidade SERIAL NOT NULL, -- Identificador do perfil da localidade
    id_localidade INTEGER UNIQUE NOT NULL, -- Identificador da localidade
    tx_localidade TEXT, -- Nome da localidade
	tx_tipo_localidade TEXT, -- Nome do tipo da localidade
    nr_quantidade_osc INTEGER, -- Quantidade de OSCs da localidade
    nr_quantidade_trabalhadores INTEGER, -- Quantidade de trabalhadores em OSCs da localidade
    nr_quantidade_recursos NUMERIC, -- Quantidade de recursos das OSCs da localidade
    nr_quantidade_projetos INTEGER, -- Quantidade de projetos das OSCs da localidade
    evolucao_quantidade_osc_ano JSONB, -- Dados sobre a evolução da quantidade de OSCs por ano na localidade
    natureza_juridica JSONB, -- Dados sobre a natureza jurídica das OSCs na localidade
    repasse_recursos_federais JSONB, -- Dados sobre os repasses de recursos federais para as OSCs da localidade
    area_atuacao JSONB, -- Dados sobre a área de atuação das OSCs na localidade
    trabalhadores JSONB -- Dados sobre os trabalhadores das OSCs na localidade
);

CREATE UNIQUE INDEX ix_perfil_localidade
    ON portal.tb_perfil_localidade USING btree
    (id_localidade ASC NULLS LAST)
TABLESPACE pg_default;
