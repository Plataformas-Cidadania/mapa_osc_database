DO $$ 
BEGIN 
	UPDATE syst.dc_tipo_usuario 
	SET tx_nome_tipo_usuario = 'Administrador' 
	WHERE cd_tipo_usuario = 1;

	UPDATE syst.dc_tipo_usuario 
	SET tx_nome_tipo_usuario = 'Representante de OSC' 
	WHERE cd_tipo_usuario = 2;

	INSERT INTO syst.dc_tipo_usuario (cd_tipo_usuario, tx_nome_tipo_usuario) 
	VALUES (3, 'Representante de Governo Municipal');

	INSERT INTO syst.dc_tipo_usuario (cd_tipo_usuario, tx_nome_tipo_usuario) 
	VALUES (4, 'Representante de Governo Estadual');

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
