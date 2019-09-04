ALTER TABLE osc.tb_dados_gerais  DISABLE TRIGGER ALL ;

update osc.tb_dados_gerais  set
cd_classe_atividade_economica_OSC = '0' || cd_classe_atividade_economica_OSC
where length(cd_classe_atividade_economica_OSC)=4 ;

ALTER TABLE osc.tb_dados_gerais  ENABLE TRIGGER ALL ;

select refreshallmaterializedviewsc('osc');
select refreshallmaterializedviewsc('portal');

