
create sequence syst.dc_nivel_federativo_cd_nivel_federativo_seq;

alter sequence syst.dc_nivel_federativo_cd_nivel_federativo_seq owner to postgres;



create table syst.dc_nivel_federativo
(
    cd_nivel_federativo      integer default nextval('syst.dc_nivel_federativo_cd_nivel_federativo_seq'::regclass) not null
        constraint dc_nivel_federativo_pk
            primary key,
    tx_nome_nivel_federativo text
);

alter table syst.dc_situacao_cadastral
    owner to postgres;

