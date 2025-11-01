create table confocos.tb_documento_conselho
(
    id_documento_conselho         serial
        constraint tb_documento_conselho_pk
            primary key,
    tx_titulo_documento    text,
    tx_imagem_capa         text,
    tx_caminho_arquivo     text,
    tx_tipo_arquivo        text,
    tx_url_externa         text,
    dt_data_cadastro       timestamp,
    id_conselho            integer
        constraint tb_documento_conselho_tb_consellho_fk
            references confocos.tb_conselho
);

alter table confocos.tb_documento_conselho
    owner to postgres;

create unique index ix_tb_documento_conselho
    on confocos.tb_documento_conselho (id_documento_conselho);


INSERT INTO confocos.tb_documento_conselho (id_documento_conselho, tx_titulo_documento, tx_imagem_capa,
                                            tx_caminho_arquivo, tx_tipo_arquivo, tx_url_externa, dt_data_cadastro,
                                            id_conselho)
VALUES (DEFAULT, 'teste', 'teste.jpg', '/usuario/teste/documento.pdf', 'pdf', 'https://url.documento.teste.com.br',
        '2025-11-01 11:03:56.000000', 1);