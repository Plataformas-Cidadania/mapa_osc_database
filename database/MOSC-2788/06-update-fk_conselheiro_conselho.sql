alter table confocos.tb_conselheiro
    add constraint tb_conselheiro_tb_consellho_fk
        foreign key (id_conselho) references confocos.tb_conselheiro (id_conselho);