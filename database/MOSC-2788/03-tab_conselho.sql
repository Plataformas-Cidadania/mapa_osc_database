
create sequence confocos.tb_conselho_id_conselho_seq;

alter sequence confocos.tb_conselho_id_conselho_seq owner to postgres;


create table confocos.tb_conselho
(
    id_conselho      integer default nextval('confocos.tb_conselho_id_conselho_seq'::regclass) not null
        constraint tb_conselho_pk
            primary key,
    tx_nome_conselho                    text,
    tx_ato_legal                        text,
    tx_website                          text,
    bo_conselho_ativo                   boolean not null,

    cd_nivel_federativo           integer
        constraint tb_conselho_dc_nivel_federativo_fk
            references syst.dc_nivel_federativo,

    cd_tipo_abrangencia           integer
        constraint tb_conselho_dc_abrangencia_conselho_fk
            references syst.dc_abrangencia_conselho
);

alter table confocos.tb_conselho
    owner to postgres;

create unique index ix_tb_conselho
    on confocos.tb_conselho (id_conselho);