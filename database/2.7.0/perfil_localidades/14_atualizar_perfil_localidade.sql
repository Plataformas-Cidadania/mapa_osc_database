DROP FUNCTION IF EXISTS portal.atualizar_perfil_localidade() CASCADE;

CREATE OR REPLACE FUNCTION portal.atualizar_perfil_localidade() RETURNS VOID AS $$ 

DECLARE
    localidade RECORD;
    dados_localidade JSONB;
    fontes_localidade TEXT[];

BEGIN
    FOR localidade IN
        SELECT * 
            FROM portal.tb_perfil_localidade
	        WHERE tx_tipo_localidade = 'regiao'
	        OR tx_tipo_localidade = 'estado'
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
            SET evolucao_quantidade_osc_ano = dados_localidade,
                ft_evolucao_quantidade_osc_ano = fontes_localidade
            WHERE id = localidade.id;

        /* ==================== Atualização do perfil de natureza jurídica ==================== */
        SELECT INTO dados_localidade, fontes_localidade dados, fontes
            FROM portal.obter_perfil_localidade_natureza_juridica(localidade.id_localidade);

        UPDATE portal.tb_perfil_localidade
            SET natureza_juridica = dados_localidade,
                ft_natureza_juridica = fontes_localidade
            WHERE id = localidade.id;

        /* ==================== Atualização do perfil repasse de recursos ==================== */
        SELECT INTO dados_localidade, fontes_localidade dados, fontes
            FROM portal.obter_perfil_localidade_repasse_recursos(localidade.id_localidade);

        UPDATE portal.tb_perfil_localidade
            SET repasse_recursos = dados_localidade,
                ft_repasse_recursos = fontes_localidade
            WHERE id = localidade.id;

        /* ==================== Atualização do perfil de área de atuação ==================== */
        SELECT INTO dados_localidade, fontes_localidade dados, fontes
            FROM portal.obter_perfil_localidade_obter_area_atuacao(localidade.id_localidade);

        UPDATE portal.tb_perfil_localidade
            SET area_atuacao = dados_localidade,
                ft_area_atuacao = fontes_localidade
            WHERE id = localidade.id;

        /* ==================== Atualização do perfil de trabalhadores ==================== */
        SELECT INTO dados_localidade, fontes_localidade dados, fontes
            FROM portal.obter_perfil_localidade_trabalhadores(localidade.id_localidade);

        UPDATE portal.tb_perfil_localidade
            SET trabalhadores = dados_localidade,
                ft_trabalhadores = fontes_localidade
            WHERE id = localidade.id;

    END LOOP;

END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_perfil_localidade();
