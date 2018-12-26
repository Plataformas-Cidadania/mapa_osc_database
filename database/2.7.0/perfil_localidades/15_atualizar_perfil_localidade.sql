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
        /* ==================== Atualização do perfil de características ==================== */
        SELECT INTO dados_localidade, fontes_localidade dados, fontes
            FROM portal.obter_perfil_localidade_caracteristicas(localidade.id_localidade);

        UPDATE portal.tb_perfil_localidade
            SET caracteristicas = dados_localidade,
                ft_caracteristicas = fontes_localidade
            WHERE id = localidade.id;

        /* ==================== Atualização do perfil da evolução por ano ==================== */
        SELECT INTO dados_localidade, fontes_localidade dados, fontes
            FROM portal.obter_perfil_localidade_evolucao_quantidade_ano(localidade.id_localidade);

        UPDATE portal.tb_perfil_localidade
            SET caracteristicas = dados_localidade,
                ft_caracteristicas = fontes_localidade
            WHERE id = localidade.id;

        /* ==================== Atualização do perfil de natureza jurídica ==================== */
        SELECT INTO dados_localidade, fontes_localidade dados, fontes
            FROM portal.obter_perfil_localidade_natureza_juridica(localidade.id_localidade);

        UPDATE portal.tb_perfil_localidade
            SET caracteristicas = dados_localidade,
                ft_caracteristicas = fontes_localidade
            WHERE id = localidade.id;

        /* ==================== Atualização do perfil repasse de recursos ==================== */
        SELECT INTO dados_localidade, fontes_localidade dados, fontes
            FROM portal.obter_perfil_localidade_repasse_recursos(localidade.id_localidade);

        UPDATE portal.tb_perfil_localidade
            SET caracteristicas = dados_localidade,
                ft_caracteristicas = fontes_localidade
            WHERE id = localidade.id;

        /* ==================== Atualização do perfil de área de atuação ==================== */
        SELECT INTO dados_localidade, fontes_localidade dados, fontes
            FROM portal.obter_perfil_localidade_obter_area_atuacao(localidade.id_localidade);

        UPDATE portal.tb_perfil_localidade
            SET caracteristicas = dados_localidade,
                ft_caracteristicas = fontes_localidade
            WHERE id = localidade.id;

        /* ==================== Atualização do perfil de trabalhadores ==================== */
        SELECT INTO dados_localidade, fontes_localidade dados, fontes
            FROM portal.obter_perfil_localidade_trabalhadores(localidade.id_localidade);

        UPDATE portal.tb_perfil_localidade
            SET caracteristicas = dados_localidade,
                ft_caracteristicas = fontes_localidade
            WHERE id = localidade.id;
    END LOOP;

END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_perfil_localidade_evolucao_quantidade_ano();
