DROP FUNCTION IF EXISTS portal.inserir_representante_osc(email TEXT, senha TEXT, nome TEXT, cpf NUMERIC(11, 0), lista_email BOOLEAN, representacao INTEGER[], token TEXT);

CREATE OR REPLACE FUNCTION portal.inserir_representante_osc(email TEXT, senha TEXT, nome TEXT, cpf NUMERIC(11, 0), lista_email BOOLEAN, representacao INTEGER[], token TEXT) RETURNS TABLE(
	flag BOOLEAN,
	mensagem TEXT
)AS $$

DECLARE
	idusuario INTEGER;
	idosc INTEGER;

BEGIN 
	INSERT INTO portal.tb_usuario(cd_tipo_usuario, tx_email_usuario, tx_senha_usuario, tx_nome_usuario, nr_cpf_usuario, bo_lista_email, bo_ativo, dt_cadastro, dt_atualizacao) 
	VALUES (2, email, senha, nome, cpf, lista_email, false, NOW(), NOW()) 
	RETURNING id_usuario INTO idusuario;
	
	DELETE FROM portal.tb_token 
	WHERE tb_token.id_usuario = idusuario;
	
	INSERT INTO portal.tb_token(id_usuario, tx_token, dt_data_expiracao_token) 
	VALUES (idusuario, token, (NOW() + (30 * interval '1 day'))::DATE);
	
	FOREACH idosc IN ARRAY representacao LOOP 
		INSERT INTO portal.tb_representacao(id_osc, id_usuario) 
		VALUES (idosc, idusuario); 
	END LOOP;
	
	flag := true;
	mensagem := 'Representante de OSC criado.';
	RETURN NEXT;

EXCEPTION 
	WHEN foreign_key_violation THEN 
		flag := false;
		mensagem := 'OSC(s) informada não existe.';
		RETURN NEXT;

	WHEN not_null_violation THEN 
		flag := false;
		mensagem := 'Campo(s) obrigatório(s) não foram preenchido(s).';
		RETURN NEXT;

	WHEN unique_violation THEN 
		flag := false;
		mensagem := 'Este CPF e/ou e-mail já está(ão) sendo utilizado(s).';
		RETURN NEXT;

	WHEN others THEN 
		flag := false;
		mensagem := 'Ocorreu um erro.';
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
