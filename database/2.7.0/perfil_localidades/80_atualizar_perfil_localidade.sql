DROP FUNCTION IF EXISTS portal.atualizar_perfil_localidade_evolucao_quantidade_ano() CASCADE;

CREATE OR REPLACE FUNCTION portal.atualizar_perfil_localidade_evolucao_quantidade_ano() RETURNS VOID AS $$ 

DECLARE
    localidade RECORD;
    dados_localidade JSONB;
    fontes_localidade TEXT[];

BEGIN
    FOR localidade IN
        SELECT * 
            FROM portal.tb_perfil_localidade
    LOOP
        /* ==================== Atualização de características do perfil ==================== */
        SELECT INTO dados_localidade, fontes_localidade dados, fontes
            FROM portal.obter_perfil_localidade_caracteristicas(localidade.id_localidade);

        UPDATE portal.tb_perfil_localidade
            SET caracteristicas = dados_localidade,
                ft_caracteristicas = fontes_localidade
            WHERE id = localidade.id;

        /* ==================== Atualização de evolução por ano do perfil ==================== */
        SELECT INTO dados_localidade, fontes_localidade dados, fontes
            FROM portal.obter_perfil_localidade_evolucao_quantidade_ano(localidade.id_localidade);

        UPDATE portal.tb_perfil_localidade
            SET caracteristicas = dados_localidade,
                ft_caracteristicas = fontes_localidade
            WHERE id = localidade.id;

        /* ==================== Atualização de natureza jurídica do perfil ==================== */
        SELECT INTO dados_localidade, fontes_localidade dados, fontes
            FROM portal.obter_perfil_localidade_natureza_juridica(localidade.id_localidade);

        UPDATE portal.tb_perfil_localidade
            SET caracteristicas = dados_localidade,
                ft_caracteristicas = fontes_localidade
            WHERE id = localidade.id;
    END LOOP;

END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_perfil_localidade_evolucao_quantidade_ano();
