DROP FUNCTION IF EXISTS portal.atualizar_perfil_localidade() CASCADE;

CREATE OR REPLACE FUNCTION portal.atualizar_perfil_localidade() RETURNS VOID AS $$ 

DECLARE
    id_perfil INTEGER := 1;
    nome_tipo_localidade_regiao TEXT := 'regiao';
    nome_tipo_localidade_estado TEXT := 'estado';
    nome_tipo_localidade_municipio TEXT := 'municipio';
    localidade RECORD;
    nome_localidade TEXT;
    nome_tipo_localidade TEXT;
    /*
    maior_media_natureza_juridica_regiao JSONB;
    maior_media_natureza_juridica_estado JSONB;
    maior_media_natureza_juridica_municipio JSONB;
    media_repasse_regiao JSONB;
    media_repasse_estado JSONB;
    media_repasse_municipio JSONB;
    maior_media_area_atuacao_regiao JSONB;
    maior_media_area_atuacao_estado JSONB;
    maior_media_area_atuacao_municipio JSONB;
    maior_media_trabalhadores_regiao JSONB;
    maior_media_trabalhadores_estado JSONB;
    maior_media_trabalhadores_municipio JSONB;
    */

BEGIN
    DELETE FROM portal.tb_perfil_localidade;

    /*
    SELECT INTO maior_media_natureza_juridica_regiao series 
    FROM portal.tb_perfil 
    WHERE id = 1;

    SELECT INTO maior_media_natureza_juridica_estado series 
    FROM portal.tb_perfil 
    WHERE id = 2;

    SELECT INTO maior_media_natureza_juridica_municipio series 
    FROM portal.tb_perfil 
    WHERE id = 3;

    SELECT INTO media_repasse_regiao series 
    FROM portal.tb_perfil 
    WHERE id = 4;

    SELECT INTO media_repasse_estado series 
    FROM portal.tb_perfil 
    WHERE id = 5;

    SELECT INTO media_repasse_municipio series 
    FROM portal.tb_perfil 
    WHERE id = 6;

    SELECT INTO maior_media_area_atuacao_regiao series 
    FROM portal.tb_perfil 
    WHERE id = 7;

    SELECT INTO maior_media_area_atuacao_estado series 
    FROM portal.tb_perfil 
    WHERE id = 8;

    SELECT INTO maior_media_area_atuacao_municipio series 
    FROM portal.tb_perfil 
    WHERE id = 9;

    SELECT INTO maior_media_trabalhadores_regiao series 
    FROM portal.tb_perfil 
    WHERE id = 10;

    SELECT INTO maior_media_trabalhadores_estado series 
    FROM portal.tb_perfil 
    WHERE id = 11;

    SELECT INTO maior_media_trabalhadores_municipio series 
    FROM portal.tb_perfil 
    WHERE id = 12;
    */

    FOR localidade IN
        SELECT 
            edre_cd_regiao::NUMERIC AS id_localidade, 
            edre_nm_regiao::TEXT AS nome_localidade,
            nome_tipo_localidade_regiao AS tipo_localidade 
            FROM spat.ed_regiao
		UNION
		SELECT 
            eduf_cd_uf::NUMERIC AS id_localidade, 
            eduf_nm_uf::TEXT AS nome_localidade,
            nome_tipo_localidade_estado AS tipo_localidade 
            FROM spat.ed_uf
		UNION
		SELECT 
            edmu_cd_municipio::NUMERIC AS id_localidade, 
            edmu_nm_municipio::TEXT AS nome_localidade,
            nome_tipo_localidade_municipio AS tipo_localidade 
            FROM spat.ed_municipio
        ORDER BY id_localidade
    LOOP
        INSERT INTO 
            portal.tb_perfil_localidade(
                id,
                id_localidade,
                tx_localidade,
                tx_tipo_localidade
            ) VALUES (
                id_perfil,
                localidade.id_localidade,
                localidade.nome_localidade,
                localidade.tipo_localidade
            );

        id_perfil := id_perfil + 1;
    END LOOP;

END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_perfil_localidade();
