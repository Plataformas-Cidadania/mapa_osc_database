DROP FUNCTION IF EXISTS portal.excluir_token_usuario(idtoken INTEGER);

CREATE OR REPLACE FUNCTION portal.excluir_token_usuario(idtoken INTEGER) RETURNS TABLE(
	flag BOOLEAN,
	mensagem TEXT
)AS $$

BEGIN 
	DELETE FROM 
		portal.tb_token 
	WHERE 
		id_token = idtoken;
	
	flag := true;
	mensagem := 'Token de usuário excluído.';
	RETURN NEXT;

EXCEPTION
	WHEN not_null_violation THEN
		flag := false;
		mensagem := 'Campo(s) obrigatório(s) não preenchido(s) na exclusão de token de usuário no banco de dados.';
		RETURN NEXT;
		
	WHEN unique_violation THEN
		flag := false;
		mensagem := 'Dado(s) único(s) violado(s) na exclusão de token de usuário no banco de dados.';
		RETURN NEXT;
		
	WHEN others THEN
		flag := false;
		mensagem := 'Ocorreu um erro na exclusão de token de usuário no banco de dados.';
		RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
