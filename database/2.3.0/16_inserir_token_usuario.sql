DROP FUNCTION IF EXISTS portal.inserir_token_usuario(idusuario INTEGER, token TEXT, dataexpiracao DATE);

CREATE OR REPLACE FUNCTION portal.inserir_token_usuario(idusuario INTEGER, token TEXT, dataexpiracao DATE) RETURNS TABLE(
	flag BOOLEAN,
	mensagem TEXT
)AS $$

BEGIN
	IF (SELECT EXISTS(SELECT true FROM portal.tb_token WHERE tb_token.id_usuario = id_usuario)) THEN 
		DELETE FROM portal.tb_token 
		WHERE tb_token.id_usuario = idusuario;
	END IF;

	INSERT INTO portal.tb_token(id_usuario, tx_token, dt_data_expiracao_token) 
	VALUES (idusuario, token, dataexpiracao);
	
	flag := true;
	mensagem := 'Token de usuário criado.';
	RETURN NEXT;

EXCEPTION 
	WHEN not_null_violation THEN 
		flag := false;
		mensagem := 'Campo(s) obrigatório(s) não foram preenchido(s) na gravação do token no banco de dados.';
		RETURN NEXT;
		
	WHEN unique_violation THEN 
		flag := false;
		mensagem := 'Dado(s) único(s) violado(s) na gravação do token no banco de dados.';
		RETURN NEXT;
		
	WHEN others THEN 
		flag := false;
		mensagem := 'Ocorreu um erro na gravação do token no banco de dados.';
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
