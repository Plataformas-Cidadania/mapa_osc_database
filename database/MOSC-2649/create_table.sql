create table portal.tb_termos
(
    id_termo bigserial
        constraint pk_tb_termos
            primary key,
    tx_nome   text not null
);


create table portal.tb_assinatura_termos
(
    id_assinatura    bigserial
        constraint pk_tb_assinatura_termo
            primary key,
    id_representacao bigint not null
        constraint tb_assinatura_termo_tb_representacao_id_representacao_fk
            references portal.tb_representacao,
    id_termos        bigint not null
        constraint tb_assinatura_termo_tb_termos_id_termos_fk
            references portal.tb_termos (id_termo),
    constraint tb_assinatura_termo_unique
        unique (id_termos, id_representacao)
);

