create table syst.dc_situacao_cadastral
(
    cd_situacao_cadastral      integer default nextval('syst.dc_situacao_cadastral_cd_situacao_cadastral_seq')
        constraint dc_situacao_cadastral_pk
            primary key,
    tx_nome_situacao_cadastral text
);
