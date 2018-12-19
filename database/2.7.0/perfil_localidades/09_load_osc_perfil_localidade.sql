/*
DELETE FROM portal.tb_perfil_localidade;

INSERT INTO portal.tb_perfil_localidade (id_osc)
VALUES (
    SELECT id_osc
    FROM osc.tb_osc
    WHERE tb_osc.bo_osc_ativa
    AND id_osc <> 789809;
);
*/

DROP FUNCTION IF EXISTS portal.atualizar_perfil_localidade_caracteristicas() CASCADE;

CREATE OR REPLACE FUNCTION portal.atualizar_perfil_localidade_caracteristicas() RETURNS VOID AS $$ 

DECLARE
    id_perfil := 1;

BEGIN
    DELETE FROM portal.tb_perfil_localidade;

    SELECT INTO maior_media_natureza_juridica_regiao series 
    FROM portal.tb_perfil 
    WHERE id = 1;

    SELECT INTO maior_media_natureza_juridica_estado series FROM 
    FROM portal.tb_perfil 
    WHERE id = 2;

    SELECT INTO maior_media_natureza_juridica_municipio series FROM 
    FROM portal.tb_perfil 
    WHERE id = 3;

    SELECT INTO media_repasse_regiao series 
    FROM portal.tb_perfil 
    WHERE id = 4;

    SELECT INTO media_repasse_estado series FROM 
    FROM portal.tb_perfil 
    WHERE id = 5;

    SELECT INTO media_repasse_municipio series FROM 
    FROM portal.tb_perfil 
    WHERE id = 6;

    SELECT INTO maior_media_area_atuacao_regiao series 
    FROM portal.tb_perfil 
    WHERE id = 7;

    SELECT INTO maior_media_area_atuacao_estado series FROM 
    FROM portal.tb_perfil 
    WHERE id = 8;

    SELECT INTO maior_media_natureza_juridica_municipio series FROM 
    FROM portal.tb_perfil 
    WHERE id = 9;

    SELECT INTO maior_media_trabalhadores_regiao series 
    FROM portal.tb_perfil 
    WHERE id = 10;

    SELECT INTO maior_media_trabalhadores_estado series FROM 
    FROM portal.tb_perfil 
    WHERE id = 11;

    SELECT INTO maior_media_trabalhadores_municipio series FROM 
    FROM portal.tb_perfil 
    WHERE id = 12;

    FOR localidade IN
        SELECT 
            edre_cd_regiao::NUMERIC AS id_localidade, 
            edmu_nm_municipio::TEXT AS nome_localidade,
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
            edre_nm_regiao::TEXT AS nome_localidade,
            nome_tipo_localidade_municipio AS tipo_localidade 
            FROM spat.ed_municipio
    LOOP
        INSERT INTO 
            portal.tb_perfil_localidade(
                id,
                id_localidade,
                tx_localidade,
                tx_tipo_localidade,
                nr_colocacao_quantidade_osc_regiao,
                nr_colocacao_quantidade_osc_estado,
                nr_colocacao_quantidade_osc_municipio,
                nr_maior_media_natureza_juridica_regiao,
                nr_maior_media_natureza_juridica_estado,
                nr_maior_media_natureza_juridica_municipio,
                tx_maior_media_natureza_juridica_regiao,
                tx_maior_media_natureza_juridica_estado,
                tx_maior_media_natureza_juridica_municipio,
                nr_colocacao_repasses_regiao,
                nr_colocacao_repasses_estado,
                nr_colocacao_repasses_municipio,
                nr_media_repasse_regiao,
                nr_media_repasse_estado,
                nr_media_repasse_municipio,
                nr_maior_media_area_atuacao_regiao,
                nr_maior_media_area_atuacao_estado,
                nr_maior_media_area_atuacao_municipio,
                tx_maior_media_area_atuacao_regiao,
                tx_maior_media_area_atuacao_estado,
                tx_maior_media_area_atuacao_municipio,
                nr_maior_media_trabalhadores_regiao,
                nr_maior_media_trabalhadores_estado,
                nr_maior_media_trabalhadores_municipio,
                tx_maior_media_trabalhadores_regiao,
                tx_maior_media_trabalhadores_estado,
                tx_maior_media_trabalhadores_municipio,
            ) VALUES (
                id_perfil,
                localidade.id_localidade,
                localidade.nome_localidade,
                localidade.tipo_localidade,
            );

        id_perfil := id_perfil + 1;
    END LOOP;

END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_localidade_perfil_localidade();
