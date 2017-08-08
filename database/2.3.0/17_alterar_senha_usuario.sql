DROP FUNCTION IF EXISTS portal.alterar_senha_usuario(id INTEGER, senha TEXT);

CREATE OR REPLACE FUNCTION portal.alterar_senha_usuario(id INTEGER, senha TEXT) RETURNS TABLE(
	flag BOOLEAN,
	mensagem TEXT
)AS $$

BEGIN
	UPDATE
		portal.tb_usuario
	SET
		tx_senha_usuario = senha,
		bo_ativo = true,
		dt_atualizacao = NOW()
	WHERE
		tb_usuario.id_usuario = id;

	flag := true;
	mensagem := 'Senha de usuário alterada.';
	RETURN NEXT;

EXCEPTION
	WHEN not_null_violation THEN
		flag := false;
		mensagem := 'Campo(s) obrigatório(s) não preenchido(s) na alteração da senha de usuário no banco de dados.';
		RETURN NEXT;
		
	WHEN unique_violation THEN
		flag := false;
		mensagem := 'Dado(s) único(s) violado(s) na alteração da senha de usuário no banco de dados.';
		RETURN NEXT;
		
	WHEN others THEN
		flag := false;
		mensagem := 'Ocorreu um erro na alteração da senha de usuário no banco de dados.';
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
