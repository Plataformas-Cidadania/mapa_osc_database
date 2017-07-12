DROP FUNCTION IF EXISTS portal.inserir_representante_governo(tipo_usuario INTEGER, email TEXT, senha TEXT, nome TEXT, cpf NUMERIC(11, 0), localidade INTEGER, lista_email BOOLEAN, token TEXT);

CREATE OR REPLACE FUNCTION portal.inserir_representante_governo(tipo_usuario INTEGER, email TEXT, senha TEXT, nome TEXT, cpf NUMERIC(11, 0), localidade INTEGER, lista_email BOOLEAN, token TEXT) RETURNS TABLE(
	status BOOLEAN, 
	mensagem TEXT
)AS $$

DECLARE
	idusuario INTEGER;

BEGIN
	IF tipo_usuario = 4 THEN 
		INSERT INTO 
			portal.tb_usuario (cd_tipo_usuario, tx_email_usuario, tx_senha_usuario, tx_nome_usuario, nr_cpf_usuario, cd_uf, bo_lista_email, bo_ativo, dt_cadastro, dt_atualizacao) 
		VALUES 
			(tipo_usuario, email, senha, nome, cpf, localidade, lista_email, false, NOW(), NOW()) 
		RETURNING id_usuario INTO idusuario;
	ELSIF tipo_usuario = 3 THEN 
		INSERT INTO 
			portal.tb_usuario (cd_tipo_usuario, tx_email_usuario, tx_senha_usuario, tx_nome_usuario, nr_cpf_usuario, cd_municipio, bo_lista_email, bo_ativo, dt_cadastro, dt_atualizacao) 
		VALUES 
			(tipo_usuario, email, senha, nome, cpf, localidade, lista_email, false, NOW(), NOW()) 
		RETURNING id_usuario INTO idusuario;
	ELSE 
		status := false;
		mensagem := 'Tipo de usuário inválido.';
		RETURN NEXT;
	END IF;
	
	PERFORM portal.inserir_token_usuario(idusuario::INTEGER, token::TEXT, (NOW() + (30 * interval '1 day'))::DATE);
	
	status := true;
	mensagem := 'Representante criado.';
	RETURN NEXT;

EXCEPTION 
	WHEN foreign_key_violation THEN 
		status := false;
		mensagem := 'Código do estado ou município informado não existe.';
		RETURN NEXT;
	
	WHEN not_null_violation THEN 
		status := false;
		mensagem := 'Campo(s) obrigatório(s) não foram preenchido(s).';
		RETURN NEXT;
	
	WHEN unique_violation THEN 
		status := false;
		mensagem := 'Este CPF e/ou e-mail já está(ão) sendo utilizado(s).';
		RETURN NEXT;

	WHEN others THEN 
		status := false;
		mensagem := 'Ocorreu um erro.';
		RETURN NEXT;
	
END;
$$ LANGUAGE 'plpgsql';