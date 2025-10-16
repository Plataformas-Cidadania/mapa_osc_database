
create table confocos.tb_conselheiro
(
    id_conselheiro             serial
        constraint tb_conselheiro_pk
            primary key,
    tx_nome_conselheiro     text,
    tx_orgao_origem         text,
    cd_identificador_orgao    numeric(14) null,
    dt_data_vinculo         timestamp null,
    dt_data_final_vinculo   timestamp null,
    bo_conselheiro_ativo    boolean not null,
    bo_eh_governamental     boolean not null,

    id_conselho             integer
        constraint tb_conselheiro_tb_consellho_fk
            references confocos.tb_conselheiro
);

alter table confocos.tb_conselheiro
    owner to postgres;

create unique index ix_tb_conselheiro
    on confocos.tb_conselheiro (id_conselheiro);