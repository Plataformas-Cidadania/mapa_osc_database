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
    FOR localidade IN
        SELECT * FROM tb_perfil_localidade ORDER BY id
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
