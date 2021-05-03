--TB_OSC_PARCEITA_PROJETO
alter table osc.tb_osc_parceira_projeto drop constraint fk_tb_projeto;

alter table osc.tb_osc_parceira_projeto
	add constraint fk_tb_projeto
		foreign key (id_projeto) references osc.tb_projeto
			on delete cascade;

--TB_AREA-ATUACAO_PROJETO
alter table osc.tb_area_atuacao_projeto drop constraint fk_id_projeto;

alter table osc.tb_area_atuacao_projeto
	add constraint fk_id_projeto
		foreign key (id_projeto) references osc.tb_projeto
			on delete cascade;

--TB_FINANCIADOR_PROJETO
alter table osc.tb_financiador_projeto drop constraint fk_id_projeto;

alter table osc.tb_financiador_projeto
	add constraint fk_id_projeto
		foreign key (id_projeto) references osc.tb_projeto
			on delete cascade;

--TB_OBJETIVO_PROJETO
alter table osc.tb_objetivo_projeto drop constraint fk_id_projeto;

alter table osc.tb_objetivo_projeto
	add constraint fk_id_projeto
		foreign key (id_projeto) references osc.tb_projeto
			on delete cascade;

--TB_PUBLICO_BENEFICIADO_PROJETO
alter table osc.tb_publico_beneficiado_projeto drop constraint fk_id_projeto;

alter table osc.tb_publico_beneficiado_projeto
	add constraint fk_id_projeto
		foreign key (id_projeto) references osc.tb_projeto
			on delete cascade;

--TB_LOCALIZACAO_PROJETO
alter table osc.tb_localizacao_projeto drop constraint fk_id_projeto;

alter table osc.tb_localizacao_projeto
	add constraint fk_id_projeto
		foreign key (id_projeto) references osc.tb_projeto
			on delete cascade;

--TB_TIPO_PARCERIA_PROJETO
alter table osc.tb_tipo_parceria_projeto drop constraint fk_id_projeto;

alter table osc.tb_tipo_parceria_projeto
	add constraint fk_id_projeto
		foreign key (id_projeto) references osc.tb_projeto
			on delete cascade;


--TB_FONTE_RECURSO_PROJETO
alter table osc.tb_fonte_recursos_projeto drop constraint fk_id_projeto;

alter table osc.tb_fonte_recursos_projeto
	add constraint fk_id_projeto
		foreign key (id_projeto) references osc.tb_projeto
			on delete cascade;