DROP TABLE IF EXISTS portal.tb_perfil_localidade;

CREATE TABLE portal.tb_perfil_localidade
(
    id_perfil_localidade SERIAL NOT NULL, -- Identificador do perfil da localidade
    id_localidade INTEGER UNIQUE NOT NULL, -- Identificador da localidade
    tx_localidade TEXT, -- Nome da localidade
	tx_tipo_localidade TEXT, -- Nome do tipo da localidade
    nr_colocacao_nacional_quantidade_osc_regiao INTEGER, -- Colocação em nível nacional da quantidade de OSCs por região
    nr_colocacao_nacional_quantidade_osc_estado INTEGER, -- Colocação em nível nacional da quantidade de OSCs por estado
    nr_colocacao_nacional_quantidade_osc_municipio INTEGER, -- Colocação em nível nacional da quantidade de OSCs por município
    nr_maior_concentracao_natureza_juridica_regiao NUMERIC, -- Maior concentração de OSCs de uma determinada natureza jurídica por região
    nr_maior_concentracao_natureza_juridica_estado NUMERIC, -- Maior concentração de OSCs de uma determinada natureza jurídica por estado
    nr_maior_concentracao_natureza_juridica_municipio NUMERIC, -- Maior concentração de OSCs de uma determinada natureza jurídica por município
    tx_maior_concentracao_natureza_juridica_regiao NUMERIC, -- Natureza jurídica da maior concentração por região
    tx_maior_concentracao_natureza_juridica_estado NUMERIC, -- Natureza jurídica da maior concentração por estado
    tx_maior_concentracao_natureza_juridica_municipio NUMERIC, -- Natureza jurídica da maior concentração por município
    nr_media_concentracao_natureza_juridica_regiao NUMERIC, -- Média concentração de OSCs de uma determinada natureza jurídica por região
    nr_media_concentracao_natureza_juridica_estado NUMERIC, -- Média concentração de OSCs de uma determinada natureza jurídica por estado
    nr_media_concentracao_natureza_juridica_municipio NUMERIC, -- Média concentração de OSCs de uma determinada natureza jurídica por município
    tx_media_concentracao_natureza_juridica_regiao NUMERIC, -- Natureza jurídica da média concentração por região
    tx_media_concentracao_natureza_juridica_estado NUMERIC, -- Natureza jurídica da média concentração por estado
    tx_media_concentracao_natureza_juridica_municipio NUMERIC, -- Natureza jurídica da média concentração por município
    nr_colocacao_nacional_repasses_regiao NUMERIC, -- Maior montante de repasses por região
    nr_colocacao_nacional_repasses_estado NUMERIC, -- Maior montante de repasses por estado
    nr_colocacao_nacional_repasses_municipio NUMERIC, -- Maior montante de repasses por município
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
