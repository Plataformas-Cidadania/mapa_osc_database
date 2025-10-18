create table portal.tb_representacao_conselho
(
    id_representacao serial
        constraint pk_tb_representacao_conselho
            primary key,
    
    id_conselho           integer
        constraint fk_id_conselho
            references confocos.tb_conselho,
    
    id_usuario       integer
        constraint fk_id_usuario
            references portal.tb_usuario,

    constraint un_representante_conselho
        unique (id_conselho, id_usuario),

    dt_data_vinculo         timestamp default now()
);

comment on table portal.tb_representacao_conselho is 'Tabela de Representação do Conselho';

comment on constraint pk_tb_representacao_conselho on portal.tb_representacao_conselho is 'Chave primária da Representação';

comment on column portal.tb_representacao_conselho.id_conselho is 'Chave estrangeira (código do Conselho)';

comment on column portal.tb_representacao_conselho.id_usuario is 'Chave estrangeira (código do Usuário)';

comment on constraint un_representante_conselho on portal.tb_representacao_conselho is 'Representante unico';

alter table portal.tb_representacao_conselho
    owner to postgres;

create unique index ix_tb_representacao_conselho
    on portal.tb_representacao_conselho (id_representacao, id_conselho, id_usuario);

INSERT INTO portal.tb_representacao_conselho (id_conselho, id_usuario, dt_data_vinculo)
VALUES (1, 4371, '2025-10-18 11:52:56.000000');