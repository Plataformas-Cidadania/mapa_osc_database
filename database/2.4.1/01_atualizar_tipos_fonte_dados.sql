DELETE FROM syst.dc_fonte_dados 
WHERE cd_sigla_fonte_dados = 'Representate' OR cd_sigla_fonte_dados = 'Representante';

INSERT INTO syst.dc_fonte_dados (cd_sigla_fonte_dados, tx_nome_fonte_dados, tx_descricao_fonte_dados, tx_referencia_fonte_dados) 
VALUES (
	'Representante de OSC',
	'Representante de Organização da Sociedade Cívil',
	'Dado inserido por um representante de Organização da Sociedade Cívil no Mapa da Organização da Sociedade Cívil',
	null
);

INSERT INTO syst.dc_fonte_dados (cd_sigla_fonte_dados, tx_nome_fonte_dados, tx_descricao_fonte_dados, tx_referencia_fonte_dados) 
VALUES (
	'Representante de Governo Estadual',
	'Representante de Governo Estadual',
	'Dados inserido por representante de governo estadual',
	null
);

INSERT INTO syst.dc_fonte_dados (cd_sigla_fonte_dados, tx_nome_fonte_dados, tx_descricao_fonte_dados, tx_referencia_fonte_dados) 
VALUES (
	'Representante de Governo Municipal',
	'Representante de Governo Municipal',
	'Dados inserido por representante de governo municipal',
	null
);

INSERT INTO syst.dc_fonte_dados (cd_sigla_fonte_dados, tx_nome_fonte_dados, tx_descricao_fonte_dados, tx_referencia_fonte_dados) 
VALUES (
	'Administrador',
	'Administrador do Sistema',
	'Dado inserido por um representante de Organização da Sociedade Cívil no Mapa da Organização da Sociedade Cívil',
	null
);

INSERT INTO syst.dc_fonte_dados (cd_sigla_fonte_dados, tx_nome_fonte_dados, tx_descricao_fonte_dados, tx_referencia_fonte_dados) 
VALUES (
	'Galileo',
	'Galileo',
	'Dado originado pelo sistema de georreferenciamento Galileo',
	null
);

INSERT INTO syst.dc_fonte_dados (cd_sigla_fonte_dados, tx_nome_fonte_dados, tx_descricao_fonte_dados, tx_referencia_fonte_dados) 
VALUES (
	'MS/AS',
	'MS/AS',
	'',
	null
);

INSERT INTO syst.dc_fonte_dados (cd_sigla_fonte_dados, tx_nome_fonte_dados, tx_descricao_fonte_dados, tx_referencia_fonte_dados) 
VALUES (
	'SICONV',
	'SICONV - Sistema de Convênios',
	'O Sistema de Convênios (Siconv) foi criado em 2008 para administrar as transferências voluntárias de recursos da União nos convênios firmados com estados, municípios, Distrito Federal e também com as entidades privadas sem fins lucrativos. Entre as vantagens desta ferramenta está a agilidade na efetivação dos contratos, a transparência do repasse do dinheiro público e a qualificação da gestão financeira.',
	'http://www.planejamento.gov.br/servicos/servicos-do-mp/siconv-sistema-de-convenios'
);
