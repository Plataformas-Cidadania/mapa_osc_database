DROP FUNCTION IF EXISTS portal.editar_representante_governo(id INTEGER, email TEXT, senha TEXT, nome TEXT, telefone1 TEXT, telefone2 TEXT, orgao TEXT, dado_institucional TEXT, email_confirmacao TEXT, lista_atualizacao_anual BOOLEAN, lista_atualizacao_trimestral BOOLEAN);

CREATE OR REPLACE FUNCTION portal.editar_representante_governo(idusuario INTEGER, email TEXT, senha TEXT, nome TEXT, telefone1 TEXT, telefone2 TEXT, orgao TEXT, dado_institucional TEXT, email_confirmacao TEXT, lista_atualizacao_anual BOOLEAN, lista_atualizacao_trimestral BOOLEAN) RETURNS TABLE(
	flag BOOLEAN, 
	mensagem TEXT
)AS $$

DECLARE 
	idosc INTEGER; 

BEGIN 
	IF senha IS NOT NULL THEN 
		UPDATE 
			portal.tb_usuario 
		SET 
			tx_email_usuario = email, 
			tx_senha_usuario = senha, 
			tx_nome_usuario = nome, 
			tx_telefone_1 = telefone1, 
			tx_telefone_2 = telefone2, 
			tx_orgao_trabalha = orgao, 
			tx_dado_institucional = dado_institucional, 
			tx_email_confirmacao = email_confirmacao, 
			bo_lista_atualizacao_anual = lista_atualizacao_anual, 
			bo_lista_atualizacao_trimestral = lista_atualizacao_trimestral, 
			dt_atualizacao = NOW() 
		WHERE 
			tb_usuario.id_usuario = idusuario AND 
			(tb_usuario.cd_tipo_usuario = 3 OR tb_usuario.cd_tipo_usuario = 4); 
	ELSE
		UPDATE 
			portal.tb_usuario 
		SET 
			tx_email_usuario = email, 
			tx_nome_usuario = nome, 
			tx_orgao_trabalha = orgao, 
			tx_telefone_1 = telefone1, 
			tx_telefone_2 = telefone2, 
			bo_lista_atualizacao_anual = lista_atualizacao_anual, 
			bo_lista_atualizacao_trimestral = lista_atualizacao_trimestral, 
			dt_atualizacao = NOW() 
		WHERE 
			tb_usuario.id_usuario = idusuario AND 
			(tb_usuario.cd_tipo_usuario = 3 OR tb_usuario.cd_tipo_usuario = 4); 
	END IF; 
	
	flag := true; 
	mensagem := 'Representante de governo atualizado.'; 
	RETURN NEXT; 

EXCEPTION 
	WHEN foreign_key_violation THEN 
		flag := false;
		mensagem := 'Localidade informada não existe.';
		RETURN NEXT;
		
	WHEN not_null_violation THEN 
		flag := false; 
		mensagem := 'Campo(s) obrigatório(s) não preenchido(s).'; 
		RETURN NEXT; 
		
	WHEN unique_violation THEN 
		flag := false; 
		mensagem := 'Unicidade de campo(s) violada.'; 
		RETURN NEXT; 
		
	WHEN others THEN 
		flag := false; 
		mensagem := 'Ocorreu um erro.'; 
		RETURN NEXT; 
		
END;
$$ LANGUAGE 'plpgsql';
