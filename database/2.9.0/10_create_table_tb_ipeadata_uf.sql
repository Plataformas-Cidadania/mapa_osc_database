create table ipeadata.tb_ipeadata_uf
(
   id_ipeadata_uf  serial     not null
       constraint pk_tb_ipeadata_uf
           primary key,
   cd_uf numeric(7) not null
       constraint fk_cd_uf
           references spat.ed_uf,
   nr_ano       integer,
   cd_indice    integer
       constraint fk_cd_indice_uf
           references ipeadata.tb_indice1,
   nr_valor     double precision
);
alter table ipeadata.tb_ipeadata_uf
   owner to i3geo;
create index ix_ipeadata_uf
   on ipeadata.tb_ipeadata_uf (cd_uf, cd_indice);