-- auto-generated definition
create database portal_osc2
    with owner postgres;

grant connect, temporary on database portal_osc2 to "ASTEC-BD";

grant connect, temporary on database portal_osc2 to role_mapaosc;

grant connect, temporary on database portal_osc2 to grupo_mapaosc with grant option;

grant connect, temporary on database portal_osc2 to role_mapaosc_rj_consulta;

grant create on database portal_osc2 to "thiago.ramos";

