DROP FUNCTION IF EXISTS portal.desativar_usuario(idusuario integer);

CREATE OR REPLACE FUNCTION portal.desativar_usuario(idusuario integer) RETURNS TABLE(
	flag BOOLEAN,
	mensagem TEXT
)AS $$

BEGIN 
	UPDATE 
		portal.tb_usuario 
	SET 
		bo_ativo = false, 
		dt_atualizacao = NOW() 
	WHERE 
		id_usuario = idusuario;
	
	flag := true;
	mensagem := 'Usuário desativado.';
	RETURN NEXT;

EXCEPTION 
	WHEN others THEN 
		flag := false;
		mensagem := 'Ocorreu um erro na desativação do usuário no banco de dados.';
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
