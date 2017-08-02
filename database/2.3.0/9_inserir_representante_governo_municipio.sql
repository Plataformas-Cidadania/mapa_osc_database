DROP FUNCTION IF EXISTS portal.inserir_representante_governo_municipio(tipo_usuario INTEGER, email TEXT, senha TEXT, nome TEXT, cpf NUMERIC(11, 0), municipio INTEGER, lista_email BOOLEAN, token TEXT);

CREATE OR REPLACE FUNCTION portal.inserir_representante_governo_municipio(tipo_usuario INTEGER, email TEXT, senha TEXT, nome TEXT, cpf NUMERIC(11, 0), municipio INTEGER, lista_email BOOLEAN, token TEXT) RETURNS TABLE(
	flag BOOLEAN, 
	mensagem TEXT
)AS $$

DECLARE
	idusuario INTEGER;

BEGIN 
	INSERT INTO portal.tb_usuario (cd_tipo_usuario, tx_email_usuario, tx_senha_usuario, tx_nome_usuario, nr_cpf_usuario, cd_municipio, bo_lista_email, bo_ativo, dt_cadastro, dt_atualizacao) 
	VALUES (tipo_usuario, email, senha, nome, cpf, municipio, lista_email, false, NOW(), NOW()) 
	RETURNING id_usuario INTO idusuario;
	
	INSERT INTO portal.tb_token(id_usuario, tx_token, dt_data_expiracao_token) 
	VALUES (idusuario, token, (NOW() + (30 * interval '1 day'))::DATE);
	
	flag := true;
	mensagem := 'Representante de governo criado.';
	RETURN NEXT;

EXCEPTION 
	WHEN foreign_key_violation THEN 
		flag := false;
		mensagem := 'Código do município informado não existe.';
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
