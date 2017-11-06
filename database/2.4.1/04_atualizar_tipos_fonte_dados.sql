DO $$ 
BEGIN 
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
		'Dado inserido por um administrador do sistema',
		null
	);

	INSERT INTO syst.dc_fonte_dados (cd_sigla_fonte_dados, tx_nome_fonte_dados, tx_descricao_fonte_dados, tx_referencia_fonte_dados) 
	VALUES (
		'Galileo',
		'Galileo',
		'Dado originado pelo sistema de georreferenciamento Galileo',
		null
	);
	/*
	INSERT INTO syst.dc_fonte_dados (cd_sigla_fonte_dados, tx_nome_fonte_dados, tx_descricao_fonte_dados, tx_referencia_fonte_dados) 
	VALUES (
		'MS/AS',
		'MS/AS',
		'',
		null
	);
	*/

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
