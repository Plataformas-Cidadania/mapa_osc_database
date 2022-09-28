create or replace view temp_projetos a deletar as select * from osc.tb_projeto where ft_nome_projeto = 'Representante de OSC'
select * from temp_projetos_a_deletar;

delete from osc.tb_projeto where  (tx_nome_projeto = '' and ft_nome_projeto = 'Representante de OSC') or id_projeto in ( WITH cte AS
                                                                                                                                  (
                                                                                                                                      SELECT
                                                                                                                                          b.id_projeto,b.tx_nome_projeto,b.ft_nome_projeto,
                                                                                                                                          ROW_NUMBER() OVER (
        PARTITION BY b.id_osc,b.tx_nome_projeto,b.cd_status_projeto,dt_data_inicio_projeto,dt_data_fim_projeto,nr_total_beneficiarios,nr_valor_captado_projeto,b.cd_abrangencia_projeto,tx_descricao_projeto
        ORDER BY b.id_osc,b.tx_nome_projeto,b.cd_status_projeto,dt_data_inicio_projeto,dt_data_fim_projeto,nr_total_beneficiarios,nr_valor_captado_projeto,b.cd_abrangencia_projeto,tx_descricao_projeto
        ) AS Row_Number
                                                                                                                                      FROM osc.tb_projeto b
                                                                                                                                               left join syst.dc_status_projeto c on b.cd_status_projeto = c.cd_status_projeto
                                                                                                                                               left join syst.dc_abrangencia_projeto d on b.cd_abrangencia_projeto = d.cd_abrangencia_projeto
                                                                                                                                               left join syst.dc_zona_atuacao_projeto e on b.cd_zona_atuacao_projeto = e.cd_zona_atuacao_projeto
                                                                                                                                               left join spat.ed_municipio f on b.cd_municipio = f.edmu_cd_municipio
                                                                                                                                               left join spat.ed_uf g on b.cd_uf = g.eduf_cd_uf
                                                                                                                                               left join osc.tb_area_atuacao_projeto h on b.id_projeto = h.id_projeto
                                                                                                                                               left join syst.dc_subarea_atuacao i on h.cd_subarea_atuacao = i.cd_subarea_atuacao
                                                                                                                                               left join osc.tb_osc_parceira_projeto r on b.id_projeto = r.id_projeto
                                                                                                                                      where ft_nome_projeto = 'Representante de OSC'
                                                                                                                                  )
                                                                                                                         SELECT id_projeto FROM cte WHERE Row_Number <> 1);
