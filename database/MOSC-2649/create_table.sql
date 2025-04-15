create table portal.tb_termo
(
    id_termo bigserial
        constraint pk_tb_termos
            primary key,
    tx_nome   text not null
);


create table portal.tb_assinatura_termo
(
    id_assinatura    bigserial
        constraint pk_tb_assinatura_termo
            primary key,
    id_representacao bigint not null
        constraint tb_assinatura_termo_tb_representacao_id_representacao_fk
            references portal.tb_representacao,
    id_termo        bigint not null
        constraint tb_assinatura_termo_tb_termos_id_termos_fk
            references portal.tb_termo (id_termo),
    constraint tb_assinatura_termo_unique
        unique (id_termo, id_representacao)
);


alter table portal.tb_assinatura_termo
    add dt_assinatura_termo DATE default now();
