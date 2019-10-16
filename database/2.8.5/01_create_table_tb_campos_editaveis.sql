create table if not exists syst.tb_campos_editaveis
(
	id_campo serial not null
		constraint tb_campos_editaveis_pk
			primary key,
	nome_campo text,
	editavel boolean default false
);

alter table syst.tb_campos_editaveis owner to i3geo;