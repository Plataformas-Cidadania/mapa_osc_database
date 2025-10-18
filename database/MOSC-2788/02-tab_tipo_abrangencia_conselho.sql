
create sequence syst.dc_abrangencia_conselho_cd_tipo_abrangencia_seq;

alter sequence syst.dc_abrangencia_conselho_cd_tipo_abrangencia_seq owner to postgres;



create table syst.dc_abrangencia_conselho
(
    cd_tipo_abrangencia      integer default nextval('syst.dc_abrangencia_conselho_cd_tipo_abrangencia_seq'::regclass) not null
        constraint dc_abrangencia_conselho_pk
            primary key,
    tx_nome_abrangencia text
);

alter table syst.dc_abrangencia_conselho
    owner to postgres;


INSERT INTO syst.dc_abrangencia_conselho (cd_tipo_abrangencia, tx_nome_abrangencia)
VALUES (DEFAULT, 'Governamental');