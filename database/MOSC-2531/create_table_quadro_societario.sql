create table syst.dc_qualificacao_socio
(
    cd_qualificacao_socio serial constraint pk_dc_qualificacao_socio primary key,
    tx_qualificacao_socio text not null
);

create table syst.dc_tipo_socio
(
    cd_tipo_socio serial constraint pk_dc_tipo_socio primary key,
    tx_tipo_socio text not null
);

create table osc.tb_quadro_societario
(
    id_quadro_societario    serial constraint pk_tb_quadro_societario primary key,
    id_osc                  integer constraint fk_id_osc_quadro_societario references osc.tb_osc,
    tx_nome_socio           text not null,
    ft_nome_socio           text,
    tx_cpf_socio            text not null,
    ft_cpf_socio            text,
    tx_data_entrada_socio   date,
    ft_data_entrada_socio   text,
    cd_qualificacao_socio   integer not null constraint fk_cd_qualificacao_socio references syst.dc_qualificacao_socio,
    ft_qualificacao_socio   text,
    cd_tipo_socio           integer not null constraint fk_dc_tipo_socio references syst.dc_tipo_socio,
    ft_tipo_socio           text,
    bo_oficial              boolean not null
);

INSERT INTO syst.dc_qualificacao_socio (cd_qualificacao_socio, tx_qualificacao_socio) VALUES (DEFAULT, 'UNICA')

INSERT INTO syst.dc_tipo_socio (cd_tipo_socio, tx_tipo_socio) VALUES (DEFAULT, 'Teste')

INSERT INTO osc.tb_quadro_societario (id_quadro_societario, id_osc, tx_nome_socio, ft_nome_socio, tx_cpf_socio, ft_cpf_socio, tx_data_entrada_socio, ft_data_entrada_socio, cd_qualificacao_socio, ft_qualificacao_socio, cd_tipo_socio, ft_tipo_socio, bo_oficial) VALUES (DEFAULT, 789809, 'Teste', 'teste', '1011111111', 'teste', '2024-09-25', 'teste', 1, 'teste', 1, 'teste', false)