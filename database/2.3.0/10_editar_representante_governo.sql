DROP FUNCTION IF EXISTS portal.editar_representante_governo(id INTEGER, email TEXT, senha TEXT, nome TEXT);

CREATE OR REPLACE FUNCTION portal.editar_representante_governo(idusuario INTEGER, email TEXT, senha TEXT, nome TEXT) RETURNS TABLE(
	flag BOOLEAN, 
	mensagem TEXT
)AS $$

DECLARE 
	idosc INTEGER; 

BEGIN 
	IF senha IS NOT NULL THEN 
		UPDATE portal.tb_usuario 
		SET tx_email_usuario = email, tx_senha_usuario = senha, tx_nome_usuario = nome, dt_atualizacao = NOW() 
		WHERE tb_usuario.id_usuario = idusuario; 
	ELSE
		UPDATE portal.tb_usuario 
		SET tx_email_usuario = email, tx_nome_usuario = nome, dt_atualizacao = NOW() 
		WHERE tb_usuario.id_usuario = idusuario; 
	END IF; 
	
	flag := true; 
	mensagem := 'Representante de OSC atualizado.'; 
	RETURN NEXT; 

EXCEPTION 
	WHEN foreign_key_violation THEN 
		flag := false;
		mensagem := 'OSC informada não existe.';
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
