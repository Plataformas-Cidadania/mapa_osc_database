DROP FUNCTION IF EXISTS portal.confirmar_email_usuario(idusuario integer);

CREATE OR REPLACE FUNCTION portal.confirmar_email_usuario(idusuario integer) RETURNS TABLE(
	flag BOOLEAN,
	mensagem TEXT
)AS $$

BEGIN 
	UPDATE 
		portal.tb_usuario 
	SET 
		bo_email_confirmado = true, 
		dt_atualizacao = NOW() 
	WHERE 
		id_usuario = idusuario;
	
	flag := true;
	mensagem := 'E-mail de usuário confirmado.';
	RETURN NEXT;

EXCEPTION 
	WHEN others THEN 
		flag := false;
		mensagem := 'Ocorreu um erro na confirmação de e-mail de usuário no banco de dados.';
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
