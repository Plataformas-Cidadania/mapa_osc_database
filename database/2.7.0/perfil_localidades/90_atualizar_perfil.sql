DROP FUNCTION IF EXISTS portal.obter_grafico_oscs_saude_tipo_estabelecimento();

CREATE OR REPLACE FUNCTION portal.atualizar_perfil() RETURNS VOID AS $$ 

DECLARE
    nome_tipo_localidade_regiao := 'regiao';
    nome_tipo_localidade_estado := 'estado';
    nome_tipo_localidade_municipio := 'municipio';
    id_perfil INTEGER;
    nome_perfil TEXT;
    series_perfil JSONB;
    fontes_perfil TEXT[];

BEGIN
    DROP TABLE IF EXISTS portal.tb_perfil;

    /* ==================== Maior média de natureza juridica ==================== */
    nome_perfil := 'maior_media_natureza_juridica';

    /* Maior média de natureza juridica por região */
    id_perfil := 1;
    SELECT INTO series_perfil, fontes_perfil dados, fontes 
        FROM portal.obter_perfil_maior_media_natureza_juridica(nome_tipo_localidade_regiao);

    INSERT INTO portal.tb_perfil (
        id,
        nome,
        tipo_localidade,
        series,
        fontes
    ) VALUES (
        id_perfil,
        nome_perfil,
        nome_tipo_localidade_regiao,
        series_perfil,
        fontes_perfil
    );

    /* Maior média de natureza juridica por estado */
    id_perfil := 2;
    SELECT INTO series_perfil, fontes_perfil dados, fontes 
        FROM portal.obter_perfil_maior_media_natureza_juridica(nome_tipo_localidade_estado);

    INSERT INTO portal.tb_perfil (
        id,
        nome,
        tipo_localidade,
        series,
        fontes
    ) VALUES (
        id_perfil,
        nome_perfil,
        nome_tipo_localidade_estado,
        series_perfil,
        fontes_perfil
    );

    /* Maior média de natureza juridica por município */
    id_perfil := 3;
    SELECT INTO series_perfil, fontes_perfil dados, fontes 
        FROM portal.obter_perfil_maior_media_natureza_juridica(nome_tipo_localidade_municipio);

    INSERT INTO portal.tb_perfil (
        id,
        nome,
        tipo_localidade,
        series,
        fontes
    ) VALUES (
        id_perfil,
        nome_perfil,
        nome_tipo_localidade_municipio,
        series_perfil,
        fontes_perfil
    );

    /* ==================== Maior média de repasses ==================== */
    nome_perfil := 'maior_media_repasses';

    /* Maior média de repasses por região */
    id_perfil := 4;
    SELECT INTO series_perfil, fontes_perfil dados, fontes 
        FROM portal.obter_perfil_maior_media_repasse(nome_tipo_localidade_regiao);

    INSERT INTO portal.tb_perfil (
        id,
        nome,
        tipo_localidade,
        series,
        fontes
    ) VALUES (
        id_perfil,
        nome_perfil,
        nome_tipo_localidade_regiao,
        series_perfil,
        fontes_perfil
    );

    /* Maior média de repasses por estado */
    id_perfil := 5;
    SELECT INTO series_perfil, fontes_perfil dados, fontes 
        FROM portal.obter_perfil_maior_media_repasse(nome_tipo_localidade_estado);

    INSERT INTO portal.tb_perfil (
        id,
        nome,
        tipo_localidade,
        series,
        fontes
    ) VALUES (
        id_perfil,
        nome_perfil,
        nome_tipo_localidade_estado,
        series_perfil,
        fontes_perfil
    );

    /* Maior média de repasses por município */
    id_perfil := 6;
    SELECT INTO series_perfil, fontes_perfil dados, fontes 
        FROM portal.obter_perfil_maior_media_repasse(nome_tipo_localidade_municipio);

    INSERT INTO portal.tb_perfil (
        id,
        nome,
        tipo_localidade,
        series,
        fontes
    ) VALUES (
        id_perfil,
        nome_perfil,
        nome_tipo_localidade_municipio,
        series_perfil,
        fontes_perfil
    );

    /* ==================== Maior média de área de atuação ==================== */
    nome_perfil := 'maior_media_area_atuacao';

    /* Maior média de área de atuação por região */
    id_perfil := 7;
    SELECT INTO series_perfil, fontes_perfil dados, fontes 
        FROM portal.obter_perfil_maior_media_area_atuacao(nome_tipo_localidade_regiao);

    INSERT INTO portal.tb_perfil (
        id,
        nome,
        tipo_localidade,
        series,
        fontes
    ) VALUES (
        id_perfil,
        nome_perfil,
        nome_tipo_localidade_regiao,
        series_perfil,
        fontes_perfil
    );

    /* Maior média de área de atuação por estado */
    id_perfil := 8;
    SELECT INTO series_perfil, fontes_perfil dados, fontes 
        FROM portal.obter_perfil_maior_media_area_atuacao(nome_tipo_localidade_estado);

    INSERT INTO portal.tb_perfil (
        id,
        nome,
        tipo_localidade,
        series,
        fontes
    ) VALUES (
        id_perfil,
        nome_perfil,
        nome_tipo_localidade_estado,
        series_perfil,
        fontes_perfil
    );

    /* Maior média de área de atuação por município */
    id_perfil := 9;
    SELECT INTO series_perfil, fontes_perfil dados, fontes 
        FROM portal.obter_perfil_maior_media_area_atuacao(nome_tipo_localidade_municipio);

    INSERT INTO portal.tb_perfil (
        id,
        nome,
        tipo_localidade,
        series,
        fontes
    ) VALUES (
        id_perfil,
        nome_perfil,
        nome_tipo_localidade_municipio,
        series_perfil,
        fontes_perfil
    );

    /* ==================== Maior média de trabalhadores ==================== */
    nome_perfil := 'maior_media_trabalhadores';

    /* Maior média de trabalhadores por região */
    id_perfil := 10;
    SELECT INTO series_perfil, fontes_perfil dados, fontes 
        FROM portal.obter_perfil_maior_media_trabalhadores(nome_tipo_localidade_regiao);

    INSERT INTO portal.tb_perfil (
        id,
        nome,
        tipo_localidade,
        series,
        fontes
    ) VALUES (
        id_perfil,
        nome_perfil,
        nome_tipo_localidade_regiao,
        series_perfil,
        fontes_perfil
    );

    /* Maior média de trabalhadores por estado */
    id_perfil := 11;
    SELECT INTO series_perfil, fontes_perfil dados, fontes 
        FROM portal.obter_perfil_maior_media_trabalhadores(nome_tipo_localidade_estado);

    INSERT INTO portal.tb_perfil (
        id,
        nome,
        tipo_localidade,
        series,
        fontes
    ) VALUES (
        id_perfil,
        nome_perfil,
        nome_tipo_localidade_estado,
        series_perfil,
        fontes_perfil
    );

    /* Maior média de trabalhadores por município */
    id_perfil := 12;
    SELECT INTO series_perfil, fontes_perfil dados, fontes 
        FROM portal.obter_perfil_maior_media_trabalhadores(nome_tipo_localidade_municipio);

    INSERT INTO portal.tb_perfil (
        id,
        nome,
        tipo_localidade,
        series,
        fontes
    ) VALUES (
        id_perfil,
        nome_perfil,
        nome_tipo_localidade_municipio,
        series_perfil,
        fontes_perfil
    );

END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_perfil();
