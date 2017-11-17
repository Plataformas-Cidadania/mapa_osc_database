DROP FUNCTION IF EXISTS portal.editar_representante_osc(idusuario INTEGER, email TEXT, senha TEXT, nome TEXT, representacao_insert INTEGER[], representacao_delete INTEGER[]);

CREATE OR REPLACE FUNCTION portal.editar_representante_osc(idusuario INTEGER, email TEXT, senha TEXT, nome TEXT, representacao_insert INTEGER[], representacao_delete INTEGER[]) RETURNS TABLE(
	flag BOOLEAN, 
	mensagem TEXT
)AS $$

DECLARE 
	idosc INTEGER; 

BEGIN 
	IF (senha = '') IS NOT false THEN 
		UPDATE 
			portal.tb_usuario 
		SET 
			tx_email_usuario = email, 
			tx_nome_usuario = nome, 
			dt_atualizacao = NOW() 
		WHERE 
			tb_usuario.id_usuario = idusuario AND 
			tb_usuario.cd_tipo_usuario = 2; 
			
	ELSE 
		UPDATE 
			portal.tb_usuario 
		SET 
			tx_email_usuario = email, 
			tx_senha_usuario = senha, 
			tx_nome_usuario = nome, 
			dt_atualizacao = NOW() 
		WHERE 
			tb_usuario.id_usuario = idusuario AND 
			tb_usuario.cd_tipo_usuario = 2; 
		
	END IF; 
	
	FOREACH idosc IN ARRAY representacao_insert LOOP 
		INSERT INTO portal.tb_representacao(id_usuario, id_osc) VALUES (idusuario, idosc); 
	END LOOP; 
	
	FOREACH idosc IN ARRAY representacao_delete LOOP 
		DELETE FROM portal.tb_representacao WHERE id_usuario = idusuario AND id_osc = idosc; 
	END LOOP; 
	
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
