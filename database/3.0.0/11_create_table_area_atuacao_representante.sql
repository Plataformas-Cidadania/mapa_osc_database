create table osc.tb_area_atuacao_representante
(
    id_area_atuacao    serial  not null
        constraint pk_tb_area_atuacao_representante
            primary key,
    id_osc             integer not null
        constraint fk_id_osc
            references osc.tb_osc,
    cd_area_atuacao    integer not null
        constraint fk_cd_area_area_atuacao
            references syst.dc_area_atuacao,
    cd_subarea_atuacao integer
        constraint fk_cd_subarea_area_atuacao
            references syst.dc_subarea_atuacao,
    tx_nome_outra      text
);

comment on table osc.tb_area_atuacao_representante is 'Tabela de área de atuação declarada pelo Representante';

comment on column osc.tb_area_atuacao_representante.id_area_atuacao is 'Identificador da área de atuação declarada pelo Representante';

comment on constraint pk_tb_area_atuacao_representante on osc.tb_area_atuacao_representante is 'Chave primária da tabela área de atuação';

comment on column osc.tb_area_atuacao_representante.id_osc is 'Identificador da OSC';

comment on column osc.tb_area_atuacao_representante.cd_area_atuacao is 'Código da área de atuação declarada pelo Representante';

comment on column osc.tb_area_atuacao_representante.cd_subarea_atuacao is 'Código da subárea de atuação declarada pelo Representante';

alter table osc.tb_area_atuacao
    owner to postgres;

create unique index ix_tb_area_atuacao_representante
    on osc.tb_area_atuacao_representante (id_area_atuacao, id_osc, cd_area_atuacao, cd_subarea_atuacao);