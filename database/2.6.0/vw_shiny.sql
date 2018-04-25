
DROP MATERIALIZED VIEW IF EXISTS graph.vw_shiny;

CREATE MATERIALIZED VIEW graph.vw_shiny AS
SELECT p.id_osc,
    p.tx_razao_social_osc,
    p.tx_nome_fantasia_osc,
    p.cd_natureza_juridica_osc,
    aa.tx_nome_natureza_juridica,
    p.dt_fundacao_osc,
    cc.edmu_nm_municipio,
    dd.eduf_sg_uf,
    p.cd_classe_atividade_economica_osc,
    ff.tx_nome_classe_atividade_economica,
    a.cd_area_atuacao,
    d.tx_nome_area_atuacao,
    a.cd_subarea_atuacao,
    y.tx_nome_subarea_atuacao,
    v.nr_trabalhadores_vinculo,
    v.nr_trabalhadores_deficiencia,
    v.nr_trabalhadores_voluntarios,
    q.id_projeto,
    q.tx_nome_projeto,
    gg.tx_nome_status_projeto,
    q.dt_data_inicio_projeto,
    q.dt_data_fim_projeto,
    q.nr_total_beneficiarios,
    q.nr_valor_total_projeto,
    q.nr_valor_captado_projeto,
    q.tx_descricao_projeto,
    hh.tx_nome_abrangencia_projeto,
    ii.tx_nome_zona_atuacao,
    q.ft_identificador_projeto_externo,
    r.cd_certificado,
    s.tx_nome_certificado,
    t.tx_cargo_dirigente,
    t.tx_nome_dirigente,
    c.tx_nome_conselho,
    e.tx_nome_tipo_participacao,
    m.dt_data_inicio_conselho,
    m.dt_data_fim_conselho,
    g.tx_nome_periodicidade_reuniao_conselho,
    h.tx_nome_conferencia,
    l.dt_ano_realizacao,
    j.tx_nome_forma_participacao_conferencia,
    k.tx_nome_participacao_social_outra,
    z.cd_fonte_recursos_osc,
    z.dt_ano_recursos_osc,
    z.nr_valor_recursos_osc,
    w.tx_nome_fonte_recursos_osc,
    st_y(bb.geo_localizacao) AS lat,
    st_x(bb.geo_localizacao) AS lon,
    jj.tx_codigo_meta_projeto,
    kk.tx_codigo_objetivo_projeto
   FROM osc.tb_osc
     JOIN osc.tb_dados_gerais p ON p.id_osc = tb_osc.id_osc
     LEFT JOIN osc.tb_localizacao bb ON p.id_osc = bb.id_osc
     LEFT JOIN osc.tb_projeto q ON p.id_osc = q.id_osc
     LEFT JOIN osc.tb_relacoes_trabalho v ON p.id_osc = v.id_osc
     LEFT JOIN osc.tb_certificado r ON p.id_osc = r.id_osc
     LEFT JOIN syst.dc_certificado s ON r.cd_certificado = s.cd_certificado
     LEFT JOIN osc.tb_governanca t ON p.id_osc = t.id_osc
     LEFT JOIN osc.tb_area_atuacao a ON p.id_osc = a.id_osc
     LEFT JOIN syst.dc_area_atuacao d ON a.cd_area_atuacao = d.cd_area_atuacao
     LEFT JOIN syst.dc_subarea_atuacao y ON a.cd_subarea_atuacao = y.cd_subarea_atuacao
     LEFT JOIN osc.tb_recursos_osc z ON p.id_osc = z.id_osc
     LEFT JOIN syst.dc_fonte_recursos_osc w ON z.cd_fonte_recursos_osc = w.cd_fonte_recursos_osc
     LEFT JOIN osc.tb_participacao_social_conselho m ON p.id_osc = m.id_osc
     LEFT JOIN syst.dc_conselho c ON m.cd_conselho = c.cd_conselho
     LEFT JOIN syst.dc_tipo_participacao e ON m.cd_tipo_participacao = e.cd_tipo_participacao
     LEFT JOIN syst.dc_periodicidade_reuniao_conselho g ON m.cd_periodicidade_reuniao_conselho = g.cd_periodicidade_reuniao_conselho
     LEFT JOIN osc.tb_participacao_social_conferencia l ON p.id_osc = l.id_osc
     LEFT JOIN syst.dc_conferencia h ON l.cd_conferencia = h.cd_conferencia
     LEFT JOIN syst.dc_forma_participacao_conferencia j ON l.cd_forma_participacao_conferencia = j.cd_forma_participacao_conferencia
     LEFT JOIN osc.tb_participacao_social_outra k ON p.id_osc = k.id_osc
     LEFT JOIN syst.dc_natureza_juridica aa ON p.cd_natureza_juridica_osc = aa.cd_natureza_juridica
     LEFT JOIN spat.ed_municipio cc ON cc.edmu_cd_municipio = bb.cd_municipio
     LEFT JOIN spat.ed_uf dd ON dd.eduf_cd_uf = cc.eduf_cd_uf::numeric
     LEFT JOIN syst.dc_classe_atividade_economica ff ON ff.cd_classe_atividade_economica::text = p.cd_classe_atividade_economica_osc::text
     LEFT JOIN syst.dc_status_projeto gg ON gg.cd_status_projeto = q.cd_status_projeto
     LEFT JOIN syst.dc_abrangencia_projeto hh ON hh.cd_abrangencia_projeto = q.cd_abrangencia_projeto
     LEFT JOIN syst.dc_zona_atuacao_projeto ii ON ii.cd_zona_atuacao_projeto = q.cd_zona_atuacao_projeto
     LEFT JOIN osc.tb_objetivo_osc ods ON p.id_osc = ods.id_osc
     LEFT JOIN syst.dc_meta_projeto jj ON ods.cd_meta_osc = jj.cd_meta_projeto
     LEFT JOIN syst.dc_objetivo_projeto kk ON jj.cd_objetivo_projeto = kk.cd_objetivo_projeto
  WHERE p.id_osc <> 789809 AND p.id_osc <> 987654 AND tb_osc.bo_osc_ativa;
