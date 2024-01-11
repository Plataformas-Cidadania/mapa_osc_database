create user r1691506a
    superuser
    createdb
    createrole;

create user t07155479683
    superuser
    createdb
    createrole;

create role "ASTEC-BD";

comment on role "ASTEC-BD" is 'E-pedido 189250';

create role role_mapaosc;

create role grupo_mapaosc;

grant role_mapaosc to grupo_mapaosc;

create role role_mapaosc_rj_consulta;

create user "R677439";

grant "ASTEC-BD" to "R677439";

comment on role "R677439" is 'Raimundo da Rocha E-pedido 189250';

create user "R44260239";

grant "ASTEC-BD" to "R44260239";

comment on role "R44260239" is 'Nilo Luiz Saccaro Júnior E-pedido 189250';

create user carga_mapaosc;

grant role_mapaosc to carga_mapaosc;

create user "jaqueline.fonseca"
    superuser
    createdb
    createrole;

create user r1282027
    superuser
    createdb
    createrole
    replication
    valid until 'infinity';

grant "ASTEC-BD" to r1282027;

comment on role r1282027 is 'Andre Sampaio Zuvanov';

create user r1282027a
    superuser
    createdb
    createrole
    replication
    valid until 'infinity';

grant "ASTEC-BD" to r1282027a;

comment on role r1282027a is 'Andre Sampaio Zuvanov';

create user r1439546;

grant role_mapaosc_rj_consulta to r1439546;

comment on role r1439546 is 'Servidor Erivelton Pires Guedes';

create user r1705296;

grant role_mapaosc_rj_consulta to r1705296;

comment on role r1705296 is 'Servidor Felix Garcia Lopez';

create user "relison.galvao";

grant role_mapaosc_rj_consulta to "relison.galvao";

comment on role "relison.galvao" is 'Bolsista Relison Andrade Galvão (B122692866)';

create user "thiago.ramos"
    superuser
    createdb;

grant role_mapaosc_rj_consulta to "thiago.ramos";

comment on role "thiago.ramos" is 'Thiago Giannini Ramos (B116908948)';

create user "tiago.nascimento";

grant role_mapaosc_rj_consulta to "tiago.nascimento";

comment on role "tiago.nascimento" is 'mapaosc consulta';

create user usr_jenkins_consulta;

grant role_mapaosc_rj_consulta to usr_jenkins_consulta;

comment on role usr_jenkins_consulta is 'Usuário para que o Jenkins possa realizar consultas no banco';

create user usrpublica;

grant role_mapaosc to usrpublica;

grant grupo_mapaosc to usrpublica;

create user "vagner.praia";

grant role_mapaosc_rj_consulta to "vagner.praia";

comment on role "vagner.praia" is 'consulta ao portal_osc2';

create user r1698984a
    superuser
    createdb
    createrole
    replication;

create user "flavio.canhete"
    superuser
    createdb
    createrole
    replication;

comment on role "flavio.canhete" is 'DBA Cast Group';

create user commvault
    superuser
    replication
    valid until 'infinity';

comment on role commvault is 'Usuário do agente de backup Commvault.';

create user usr_jenkins_migrate
    superuser
    createdb
    createrole;

create user usr_inclua_jenks
    superuser
    createdb
    createrole;

create user usr_inclua_apl;

create user usr_catalogo;

create user usr_dbopenproject;

create user t01556174195
    superuser
    createdb
    createrole;

comment on role t01556174195 is 'Wilton Alves de Souza (t01556174195@ipea.gov.br)
';

create user "R78551749153A"
    superuser
    createdb
    createrole;

create user usr_infra
    noinherit;

create user backupservice
    superuser
    createdb
    createrole
    replication
    bypassrls;

create user "B01049221338"
    noinherit;

create user "T05613226199"
    superuser;

create user "R1551095"
    noinherit;

create user "B12065433701"
    createdb;

create user "B109289967"
    noinherit;

create user usr_zabbix
    superuser
    createdb
    createrole
    replication
    bypassrls;

create user "P22433438861"
    noinherit;

create user "B41776273800"
    noinherit;
