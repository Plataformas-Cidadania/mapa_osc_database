DROP FUNCTION IF EXISTS portal.inicializar_perfil_localidade() CASCADE;

CREATE OR REPLACE FUNCTION portal.inicializar_perfil_localidade() RETURNS VOID AS $$ 

DECLARE
    id_perfil INTEGER := 1;
    nome_tipo_localidade_regiao TEXT := 'regiao';
    nome_tipo_localidade_estado TEXT := 'estado';
    nome_tipo_localidade_municipio TEXT := 'municipio';
    localidade RECORD;
    nome_localidade TEXT;
    nome_tipo_localidade TEXT;

BEGIN
    DELETE FROM portal.tb_perfil_localidade;

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
