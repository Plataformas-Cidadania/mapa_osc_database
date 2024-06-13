-------------------------- ALTER PERMISSON MATERIALIZED VIEW ------------------------

alter materialized view portal.vw_osc_dados_gerais owner to postgres;

alter materialized view portal.vw_osc_descricao owner to postgres;

alter materialized view portal.vw_osc_recursos_projeto owner to postgres;

alter materialized view osc.vw_busca_resultado owner to postgres;

alter materialized view portal.vw_osc_recursos_osc owner to postgres;

alter materialized view portal.vw_osc_objetivo_projeto owner to postgres;

alter materialized view portal.vw_osc_publico_beneficiado_projeto owner to postgres;

alter materialized view portal.vw_osc_fonte_recursos_projeto owner to postgres;

alter materialized view portal.vw_osc_projeto owner to postgres;

alter materialized view portal.vw_osc_representante_conselho owner to postgres;

alter materialized view portal.vw_osc_participacao_social_outra owner to postgres;

alter materialized view portal.vw_osc_participacao_social_conferencia owner to postgres;

alter materialized view portal.vw_osc_participacao_social_conselho owner to postgres;

alter materialized view portal.vw_osc_conselho_fiscal owner to postgres;

alter materialized view portal.vw_osc_governanca owner to postgres;

alter materialized view portal.vw_osc_relacoes_trabalho owner to postgres;

alter materialized view portal.vw_osc_certificado owner to postgres;

alter materialized view portal.vw_osc_objetivo_osc owner to postgres;

alter materialized view portal.vw_osc_area_atuacao owner to postgres;

alter materialized view portal.vw_osc_barra_transparencia owner to postgres;

alter materialized view spat.vw_geo_cluster_regiao owner to postgres;

alter materialized view spat.vw_spat_estado owner to postgres;

alter materialized view spat.vw_spat_municipio owner to postgres;

alter materialized view spat.vw_spat_regiao owner to postgres;

-------------------------- REFRESH MATERIALIZED VIEW ------------------------

refresh materialized view portal.vw_osc_dados_gerais;

refresh materialized view portal.vw_osc_descricao;

refresh materialized view portal.vw_osc_recursos_projeto;

refresh materialized view osc.vw_busca_resultado;

refresh materialized view portal.vw_osc_recursos_osc;

refresh materialized view portal.vw_osc_objetivo_projeto;

refresh materialized view portal.vw_osc_publico_beneficiado_projeto;

refresh materialized view portal.vw_osc_fonte_recursos_projeto;

refresh materialized view portal.vw_osc_projeto;

refresh materialized view portal.vw_osc_representante_conselho;

refresh materialized view portal.vw_osc_participacao_social_outra;

refresh materialized view portal.vw_osc_participacao_social_conferencia;

refresh materialized view portal.vw_osc_participacao_social_conselho;

refresh materialized view portal.vw_osc_conselho_fiscal;

refresh materialized view portal.vw_osc_governanca;

refresh materialized view portal.vw_osc_relacoes_trabalho;

refresh materialized view portal.vw_osc_certificado;

refresh materialized view portal.vw_osc_objetivo_osc;

refresh materialized view portal.vw_osc_area_atuacao;

refresh materialized view portal.vw_osc_barra_transparencia;

refresh materialized view spat.vw_geo_cluster_regiao;

refresh materialized view spat.vw_spat_estado;

refresh materialized view spat.vw_spat_municipio;

refresh materialized view spat.vw_spat_regiao;