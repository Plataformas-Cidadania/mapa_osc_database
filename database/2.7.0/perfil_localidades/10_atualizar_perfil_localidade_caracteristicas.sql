DROP FUNCTION IF EXISTS portal.atualizar_perfil_localidade_caracteristicas() CASCADE;

CREATE OR REPLACE FUNCTION portal.atualizar_perfil_localidade_caracteristicas() RETURNS VOID AS $$ 

DECLARE
    id_perfil INTEGER := 1;
    localidade RECORD;
    caracteristicas_localidade JSONB;
    fontes_caracteristicas_localidade TEXT[];

BEGIN
    FOR localidade IN
        SELECT * 
            FROM portal.tb_perfil_localidade 
            ORDER BY id
    LOOP
        SELECT INTO caracteristicas_localidade, fontes_caracteristicas_localidade dados, fontes
            FROM portal.obter_perfil_localidade_caracteristicas(localidade.id_localidade);

        UPDATE portal.tb_perfil_localidade
            SET caracteristicas = caracteristicas_localidade,
                ft_caracteristicas = fontes_caracteristicas_localidade
            WHERE id = localidade.id;

        id_perfil := id_perfil + 1;
    END LOOP;

END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_perfil_localidade_caracteristicas();
