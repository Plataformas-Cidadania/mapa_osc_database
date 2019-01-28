DROP FUNCTION IF EXISTS analysis.refresh_views_analysis() CASCADE;

CREATE OR REPLACE FUNCTION analysis.refresh_views_analysis() RETURNS VOID AS $$ 
BEGIN
    REFRESH MATERIALIZED VIEW analysis.vw_perfil_localidade_caracteristicas;
    REFRESH MATERIALIZED VIEW analysis.vw_perfil_localidade_evolucao_anual;
    REFRESH MATERIALIZED VIEW analysis.vw_perfil_localidade_natureza_juridica;
    REFRESH MATERIALIZED VIEW analysis.vw_perfil_localidade_repasse_recursos;
    REFRESH MATERIALIZED VIEW analysis.vw_perfil_localidade_area_atuacao;
    REFRESH MATERIALIZED VIEW analysis.vw_perfil_localidade_trabalhadores;
    REFRESH MATERIALIZED VIEW analysis.vw_perfil_localidade_ranking_quantidade_osc;
    REFRESH MATERIALIZED VIEW analysis.vw_perfil_localidade_ranking_repasse_recursos;
    REFRESH MATERIALIZED VIEW analysis.vw_perfil_localidade_maior_natureza_juridica;
    REFRESH MATERIALIZED VIEW analysis.vw_perfil_localidade_maior_media_repasse_recursos;
    REFRESH MATERIALIZED VIEW analysis.vw_perfil_localidade_media_repasse_recursos;
    REFRESH MATERIALIZED VIEW analysis.vw_perfil_localidade_maior_area_atuacao;
    REFRESH MATERIALIZED VIEW analysis.vw_perfil_localidade_maior_trabalhadores;
    REFRESH MATERIALIZED VIEW analysis.vw_perfil_localidade_media_nacional;

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM analysis.refresh_views_analysis();