alter table osc.tb_osc
    add cd_stituacao_cadastral integer
        constraint tb_osc_dc_situacao_cadastral_fk
            references syst.dc_situacao_cadastral;

alter table osc.tb_dados_gerais
    drop column dc_situacao_cadastral;