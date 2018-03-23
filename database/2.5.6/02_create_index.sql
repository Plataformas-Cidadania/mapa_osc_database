CREATE UNIQUE INDEX ix_siafi
    ON graph.siafi USING btree
    (id_siafi ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_cnes
    ON graph.tb_cnes USING btree
    (id_cnes,nu_cnpj_requerente ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_rais
    ON graph.tb_rais USING btree
    (id_tb_rais,id_estab ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_log_alteracao
    ON log.tb_log_alteracao USING btree
    (id_log_alteracao, id_osc, dt_alteracao ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_log_carga
    ON log.tb_log_carga USING btree
    (id_carga ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_log_erro_carga
    ON log.tb_log_erro_carga USING btree
    (id_log_erro_carga, cd_identificador_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_vw_busca_osc
    ON osc.vw_busca_osc USING btree
    (id_osc, cd_identificador_osc  ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_vw_busca_osc_geo
    ON osc.vw_busca_osc_geo USING btree
    (id_osc  ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_vw_geo_osc
    ON osc.vw_geo_osc USING btree
    (id_osc  ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_area_atuacao
    ON osc.tb_area_atuacao USING btree
    (id_area_atuacao, id_osc, cd_area_atuacao, cd_subarea_atuacao ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_area_atuacao_projeto
    ON osc.tb_area_atuacao_projeto USING btree
    (id_area_atuacao_projeto,id_projeto,cd_subarea_atuacao ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_certificado
    ON osc.tb_certificado USING btree
    (id_certificado, id_osc, cd_certificado ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_conselho_fiscal
    ON osc.tb_conselho_fiscal USING btree
    (id_conselheiro,id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_contato
    ON osc.tb_contato USING btree
    (id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_dados_gerais
    ON osc.tb_dados_gerais USING btree
    (id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_financiador_projeto
    ON osc.tb_financiador_projeto USING btree
    (id_financiador_projeto,id_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_fonte_recursos_projeto
    ON osc.tb_fonte_recursos_projeto USING btree
    (id_fonte_recursos_projeto,id_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_governanca
    ON osc.tb_governanca USING btree
    (id_dirigente,id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_localizacao
    ON osc.tb_localizacao USING btree
    (id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_localizacao_projeto
    ON osc.tb_localizacao_projeto USING btree
    (id_localizacao_projeto,id_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_objetivo_osc
    ON osc.tb_objetivo_osc USING btree
    (id_objetivo_osc,id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_objetivo_projeto
    ON osc.tb_objetivo_projeto USING btree
    (id_objetivo_projeto,id_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_osc
    ON osc.tb_osc USING btree
    (id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_osc_parceira_projeto
    ON osc.tb_osc_parceira_projeto USING btree
    (id_osc,id_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_participacao_social_conferencia
    ON osc.tb_participacao_social_conferencia USING btree
    (id_conferencia,id_osc,cd_conferencia ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_participacao_social_conferencia_outra
    ON osc.tb_participacao_social_conferencia_outra USING btree
    (id_conferencia_outra,id_conferencia ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_participacao_social_conselho
    ON osc.tb_participacao_social_conselho USING btree
    (id_conselho,id_osc,cd_conselho ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_participacao_social_conselho_outro
    ON osc.tb_participacao_social_conselho_outro USING btree
    (id_conselho_outro,id_conselho ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_participacao_social_outra
    ON osc.tb_participacao_social_outra USING btree
    (id_participacao_social_outra,id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_projeto
    ON osc.tb_projeto USING btree
    (id_osc,id_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_publico_beneficiado
    ON osc.tb_publico_beneficiado USING btree
    (id_publico_beneficiado ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_publico_beneficiado_projeto
    ON osc.tb_publico_beneficiado_projeto USING btree
    (id_projeto,id_publico_beneficiado ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_recursos_osc
    ON osc.tb_recursos_osc USING btree
    (id_osc,id_recursos_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_recursos_outro_osc
    ON osc.tb_recursos_outro_osc USING btree
    (id_osc,id_recursos_outro_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_relacoes_trabalho
    ON osc.tb_relacoes_trabalho USING btree
    (id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_relacoes_trabalho_outra
    ON osc.tb_relacoes_trabalho_outra USING btree
    (id_relacoes_trabalho_outra,id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_representante_conselho
    ON osc.tb_representante_conselho USING btree
    (id_representante_conselho,id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_tipo_parceria_projeto
    ON osc.tb_tipo_parceria_projeto USING btree
    (id_tipo_parceria_projeto,id_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_edital
    ON portal.tb_edital USING btree
    (id_edital ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_newsletters
    ON portal.tb_newsletters USING btree
    (id_newsletters ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_peso_barra_transparencia
    ON portal.tb_peso_barra_transparencia USING btree
    (id_peso_barra_transparencia ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_representacao
    ON portal.tb_representacao USING btree
    (id_representacao, id_osc, id_usuario ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_token
    ON portal.tb_token USING btree
    (id_token, id_usuario ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_tb_usuario
    ON portal.tb_usuario USING btree
    (id_usuario,cd_tipo_usuario ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_spatial_ref_sys
    ON public.spatial_ref_sys USING btree
    (srid ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_vw_geo_cluster_regiao
    ON spat.vw_geo_cluster_regiao USING btree
    (id_regiao ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_vw_spat_estado
    ON spat.vw_spat_estado USING btree
    (eduf_cd_uf ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_vw_spat_municipio
    ON spat.vw_spat_municipio USING btree
    (edmu_cd_municipio ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_vw_spat_regiao
    ON spat.vw_spat_regiao USING btree
    (edre_cd_regiao ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_ed_uf
    ON spat.ed_uf USING btree
    (eduf_cd_uf ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_ed_municipio
    ON spat.ed_municipio USING btree
    (edmu_cd_municipio ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_ed_regiao
    ON spat.ed_regiao USING btree
    (edre_cd_regiao ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_abrangencia_projeto
    ON syst.dc_abrangencia_projeto USING btree
    (cd_abrangencia_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_area_atuacao
    ON syst.dc_area_atuacao USING btree
    (cd_area_atuacao ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_certificado
    ON syst.dc_certificado USING btree
    (cd_certificado ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_classe_atividade_economica
    ON syst.dc_classe_atividade_economica USING btree
    (cd_classe_atividade_economica ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_conferencia
    ON syst.dc_conferencia USING btree
    (cd_conferencia ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_conselho
    ON syst.dc_conselho USING btree
    (cd_conselho ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_fonte_dados
    ON syst.dc_fonte_dados USING btree
    (cd_sigla_fonte_dados ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_fonte_geocodificacao
    ON syst.dc_fonte_geocodificacao USING btree
    (cd_fonte_geocodoficacao ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_fonte_recursos_osc
    ON syst.dc_fonte_recursos_osc USING btree
    (cd_fonte_recursos_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_fonte_recursos_projeto
    ON syst.dc_fonte_recursos_projeto USING btree
    (cd_fonte_recursos_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_forma_participacao_conferencia
    ON syst.dc_forma_participacao_conferencia USING btree
    (cd_forma_participacao_conferencia ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_meta_projeto
    ON syst.dc_meta_projeto USING btree
    (cd_meta_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_natureza_juridica
    ON syst.dc_natureza_juridica USING btree
    (cd_natureza_juridica ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_objetivo_projeto
    ON syst.dc_objetivo_projeto USING btree
    (cd_objetivo_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_origem_fonte_recursos_osc
    ON syst.dc_origem_fonte_recursos_osc USING btree
    (cd_origem_fonte_recursos_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_origem_fonte_recursos_projeto
    ON syst.dc_origem_fonte_recursos_projeto USING btree
    (cd_origem_fonte_recursos_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_periodicidade_reuniao_conselho
    ON syst.dc_periodicidade_reuniao_conselho USING btree
    (cd_periodicidade_reuniao_conselho ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_situacao_imovel
    ON syst.dc_situacao_imovel USING btree
    (cd_situacao_imovel ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_status_carga
    ON syst.dc_status_carga USING btree
    (cd_status ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_status_projeto
    ON syst.dc_status_projeto USING btree
    (cd_status_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_subarea_atuacao
    ON syst.dc_subarea_atuacao USING btree
    (cd_subarea_atuacao ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_subclasse_atividade_economica
    ON syst.dc_subclasse_atividade_economica USING btree
    (cd_subclasse_atividade_economica ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_tipo_parceria
    ON syst.dc_tipo_parceria USING btree
    (cd_tipo_parceria ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_tipo_participacao
    ON syst.dc_tipo_participacao USING btree
    (cd_tipo_participacao ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_tipo_usuario
    ON syst.dc_tipo_usuario USING btree
    (cd_tipo_usuario ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_dc_zona_atuacao_projeto
    ON syst.dc_zona_atuacao_projeto USING btree
    (cd_zona_atuacao_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_layer
    ON topology.layer USING btree
    (topology_id,layer_id ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_topology
    ON topology.topology USING btree
    (id ASC NULLS LAST)
    TABLESPACE pg_default;
