CREATE TYPE perfil AS ENUM('membro_ou_representante_osc', 'gestor_ou_servidor_publico', 'pesquisador_ou_estudante', 'jornalista_ou_midia','outros');
create table portal.tb_dados_perfil_de_acesso
(
    id                           serial primary key,
    tipo_perfil                  perfil,
    endereco_ip                  text,
    updated_at                   TIMESTAMP,
    created_at                   TIMESTAMP
);

comment on table portal.tb_dados_perfil_de_acesso is 'Armazeda informações de acesso ao mapa. Serão analizadas e usadas para personalizar a experiencia do cliente no mapa';

alter table portal.tb_dados_perfil_de_acesso
    owner to postgres;