-- auto-generated definition
create table tb_n_recurso_osc_ano
(
    id_osc                       integer not null
        constraint tb_n_recurso_osc_ano_tb_osc__fk
            references osc.tb_osc
            on delete cascade,
    ano                          integer not null,
    ft_nao_possui                text,
    cd_origem_fonte_recursos_osc integer not null
        constraint tb_n_recurso_ano_origem_osc_fk
            references syst.dc_origem_fonte_recursos_osc,
    constraint tb_n_recurso_osc_ano_pk
        primary key (id_osc, ano, cd_origem_fonte_recursos_osc)
);

comment on table tb_n_recurso_osc_ano is 'Armazena os anos que a osc teve recurso';

comment on column tb_n_recurso_osc_ano.id_osc is 'Contem o id da osc';

comment on column tb_n_recurso_osc_ano.ano is 'ano do que houve algum recurso';

comment on column tb_n_recurso_osc_ano.ft_nao_possui is 'Fonte da informaçao de nao possui recurso no ano';

alter table tb_n_recurso_osc_ano
    owner to postgres;

----Pega todas as oscs que não tiveram nenhum recurso no ano e insere na tabela tb_n_recurso_ano colocando um registro pra cada origem---------------------------------------------------
SELECT A.id_osc, "substring"(A.dt_ano_recursos_osc::text, 1, 4)::integer as ano, B.cd_origem_fonte_recursos_osc
from osc.tb_recursos_osc A, syst.dc_origem_fonte_recursos_osc B
where A.cd_origem_fonte_recursos_osc is null and A.cd_fonte_recursos_osc is null and A.bo_nao_possui;

insert into osc.tb_n_recurso_osc_ano (id_osc, ano, ft_nao_possui, cd_origem_fonte_recursos_osc)
SELECT A.id_osc, "substring"(A.dt_ano_recursos_osc::text, 1, 4)::integer as ano, A.ft_nao_possui, B.cd_origem_fonte_recursos_osc
from osc.tb_recursos_osc A, syst.dc_origem_fonte_recursos_osc B
where A.cd_origem_fonte_recursos_osc is null and A.cd_fonte_recursos_osc is null and A.bo_nao_possui;
----------------------------------------------------------------------------------------------------------

------------------ Pega todas as oscs que tiveram recursos no ano de uma determinada origem---------------
SELECT id_osc as osc, "substring"(dt_ano_recursos_osc::text, 1, 4):: integer as ano, ft_nao_possui as ft, cd_origem_fonte_recursos_osc
FROM osc.tb_recursos_osc
WHERE bo_nao_possui and cd_origem_fonte_recursos_osc is not null;
order by id_osc, dt_ano_recursos_osc, cd_origem_fonte_recursos_osc;

insert into osc.tb_n_recurso_osc_ano (id_osc, ano, ft_nao_possui, cd_origem_fonte_recursos_osc )
SELECT id_osc as osc, "substring"(dt_ano_recursos_osc::text, 1, 4):: integer as ano, ft_nao_possui as ft, cd_origem_fonte_recursos_osc
FROM osc.tb_recursos_osc
WHERE bo_nao_possui and cd_origem_fonte_recursos_osc is not null;
-------------------------------------------------------------------------------

DELETE FROM osc.tb_recursos_osc WHERE nr_valor_recursos_osc is NULL;

alter table osc.tb_recursos_osc drop column bo_nao_possui;

alter table osc.tb_recursos_osc drop column ft_nao_possui;

drop index osc.un_recursos_osc;

alter table osc.tb_recursos_osc drop constraint un_recursos_osc;

alter table osc.tb_recursos_osc drop column cd_origem_fonte_recursos_osc;

alter table osc.tb_recursos_osc
	add constraint un_recursos_osc
		unique (id_osc, cd_fonte_recursos_osc, dt_ano_recursos_osc);