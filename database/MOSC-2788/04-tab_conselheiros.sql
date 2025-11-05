
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
            references confocos.tb_conselho
);

alter table confocos.tb_conselheiro
    owner to postgres;

create unique index ix_tb_conselheiro
    on confocos.tb_conselheiro (id_conselheiro);


INSERT INTO confocos.tb_conselheiro (id_conselheiro, tx_nome_conselheiro, tx_orgao_origem, cd_identificador_orgao,
                                     dt_data_vinculo, dt_data_final_vinculo, bo_conselheiro_ativo, bo_eh_governamental,
                                     id_conselho)
VALUES (DEFAULT, 'Teste', 'IPEA', null, '2025-10-18 10:38:06.000000', null, true, true, 1);


grant select on confocos.tb_conselheiro to "ASTEC-BD";

grant delete, insert, select, trigger, update on confocos.tb_conselheiro to role_mapaosc;

grant delete, insert, select, trigger, update on confocos.tb_conselheiro to grupo_mapaosc with grant option;

grant select on confocos.tb_conselheiro to role_mapaosc_rj_consulta;

grant delete, insert, references, select, trigger, truncate, update on confocos.tb_conselheiro to "thiago.ramos";

grant select on confocos.tb_conselheiro to "murilo.junqueira";

grant delete, insert, select, update on confocos.tb_conselheiro to usr_manutencao_mapa;

grant delete, insert, references, select, trigger, truncate, update on confocos.tb_conselheiro to usr_etl;