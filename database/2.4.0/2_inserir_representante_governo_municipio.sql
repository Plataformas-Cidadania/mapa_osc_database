DROP FUNCTION IF EXISTS portal.inserir_representante_governo_municipio(tipo_usuario INTEGER, email TEXT, senha TEXT, nome TEXT, cpf NUMERIC(11, 0), telefone1 TEXT, telefone2 TEXT, orgao TEXT, dado_institucional TEXT, email_confirmacao TEXT, municipio INTEGER, lista_email BOOLEAN, lista_atualizacao_anual BOOLEAN, lista_atualizacao_trimestral BOOLEAN, token TEXT);

CREATE OR REPLACE FUNCTION portal.inserir_representante_governo_municipio(tipo_usuario INTEGER, email TEXT, senha TEXT, nome TEXT, cpf NUMERIC(11, 0), telefone1 TEXT, telefone2 TEXT, orgao TEXT, dado_institucional TEXT, email_confirmacao TEXT, municipio INTEGER, lista_email BOOLEAN, lista_atualizacao_anual BOOLEAN, lista_atualizacao_trimestral BOOLEAN, token TEXT) RETURNS TABLE(
	flag BOOLEAN, 
	mensagem TEXT
)AS $$

DECLARE
	idusuario INTEGER;

BEGIN 
	INSERT INTO portal.tb_usuario (cd_tipo_usuario, tx_email_usuario, tx_senha_usuario, tx_nome_usuario, nr_cpf_usuario, tx_telefone_1, tx_telefone_2, tx_orgao_trabalha, tx_dado_institucional, tx_email_confirmacao, cd_municipio, bo_lista_email, bo_lista_atualizacao_anual, bo_lista_atualizacao_trimestral, bo_ativo, dt_cadastro, dt_atualizacao) 
	VALUES (tipo_usuario, email, senha, nome, cpf, telefone1, telefone2, orgao, dado_institucional, email_confirmacao, municipio, lista_email, lista_atualizacao_anual, lista_atualizacao_trimestral, false, NOW(), NOW()) 
	RETURNING id_usuario INTO idusuario;
	
	INSERT INTO portal.tb_token(id_usuario, tx_token, dt_data_expiracao_token) 
	VALUES (idusuario, token, (NOW() + (30 * interval '1 day'))::DATE);
	
	IF lista_email THEN 
		IF (SELECT NOT EXISTS(SELECT true FROM portal.tb_newsletters WHERE tx_email_assinante = email)) THEN 
			INSERT INTO portal.tb_newsletters (tx_email_assinante, tx_nome_assinante) 
			VALUES (email, nome);
		END IF;
	END IF;
	
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
