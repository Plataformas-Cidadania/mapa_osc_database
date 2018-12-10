DROP TABLE IF EXISTS portal.tb_perfil_localidade;

CREATE TABLE portal.tb_perfil_localidade
(
    id_perfil_localidade SERIAL NOT NULL, -- Identificador do perfil da localidade
    id_localidade INTEGER UNIQUE NOT NULL, -- Identificador da localidade
    tx_localidade TEXT, -- Nome da localidade
	tx_tipo_localidade TEXT, -- Nome do tipo da localidade
    nr_colocacao_nacional_quantidade_osc_regiao INTEGER,
    nr_colocacao_nacional_quantidade_osc_estado INTEGER,
    nr_colocacao_nacional_quantidade_osc_municipio INTEGER,
    nr_colocacao_nacional_repasses_regiao INTEGER,
    nr_colocacao_nacional_repasses_estado INTEGER,
    nr_colocacao_nacional_repasses_municipio INTEGER,
    caracteristicas JSON, -- Dados sobre características gerais das OSCs na localidade
    ft_caracteristicas TEXT[], -- Fontes sobre características gerais das OSCs na localidade
    evolucao_quantidade_osc_ano JSONB, -- Dados sobre a evolução da quantidade de OSCs por ano na localidade
    ft_evolucao_quantidade_osc_ano TEXT[], -- Fontes sobre a evolução da quantidade de OSCs por ano na localidade
    natureza_juridica JSONB, -- Dados sobre a natureza jurídica das OSCs na localidade
    ft_natureza_juridica TEXT[], -- Fontes sobre a natureza jurídica das OSCs na localidade
    repasse_recursos JSONB, -- Dados sobre os repasses de recursos para as OSCs da localidade
    ft_repasse_recursos TEXT[], -- Fontes sobre os repasses de recursos para as OSCs da localidade
    area_atuacao JSONB, -- Dados sobre a área de atuação das OSCs na localidade
    ft_area_atuacao TEXT[], -- Fontes sobre a área de atuação das OSCs na localidade
    trabalhadores JSONB, -- Dados sobre os trabalhadores das OSCs na localidade
    ft_trabalhadores TEXT[] -- Fontes sobre os trabalhadores das OSCs na localidade
);

CREATE UNIQUE INDEX ix_perfil_localidade
    ON portal.tb_perfil_localidade USING btree
    (id_localidade ASC NULLS LAST)
TABLESPACE pg_default;
