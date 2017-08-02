DROP FUNCTION IF EXISTS portal.atualizar_representante(id INTEGER, email TEXT, senha TEXT, nome TEXT, representacao INTEGER[]);

CREATE OR REPLACE FUNCTION portal.atualizar_representante(id INTEGER, email TEXT, senha TEXT, nome TEXT, representacao INTEGER[]) RETURNS TABLE(
	status BOOLEAN, 
	mensagem TEXT,
	nova_representacao []
)AS $$

BEGIN 
	IF senha IS NOT NULL THEN
		UPDATE 
			portal.tb_usuario 
		SET 
			tx_email_usuario = email, 
			tx_senha_usuario = senha, 
			tx_nome_usuario = nome, 
			dt_atualizacao = NOW() 
		WHERE 
			tb_usuario.id_usuario = id; 
	ELSE
		UPDATE 
			portal.tb_usuario 
		SET 
			tx_email_usuario = email, 
			tx_nome_usuario = nome, 
			dt_atualizacao = NOW() 
		WHERE 
			tb_usuario.id_usuario = id; 
	END IF; 
	
	FOREACH id_osc_insert IN ARRAY representacao 
	LOOP 
		BEGIN 
			INSERT INTO portal.tb_representacao(id_osc, id_usuario) VALUES (id_osc_insert, id); 
			nova_representacao := array_append(nova_representacao, id_osc_insert); 
		EXCEPTION WHEN unique_violation THEN 
			RAISE NOTICE 'ERROR: unique_violation for id_usuario = % and id_osc = %', id, id_osc_insert; 
		END; 
	END LOOP; 
	
	FOR id_representacao_delete IN 
		SELECT id_representacao FROM portal.tb_representacao WHERE id_usuario = id AND id_osc <> ALL(representacao) 
	LOOP 
		DELETE FROM portal.tb_representacao WHERE id_representacao = id_representacao_delete; 
	END LOOP;
	
	status := true; 
	mensagem := 'Usuário atualizado';
	RETURN NEXT; 

EXCEPTION 
	WHEN not_null_violation THEN 
		status := false; 
		mensagem := 'Campo(s) obrigatório(s) não preenchido(s)'; 
		RETURN NEXT; 

	WHEN unique_violation THEN 
		status := false; 
		mensagem := 'Unicidade de campo(s) violada'; 
		RETURN NEXT; 

	WHEN others THEN 
		status := false; 
		mensagem := 'Ocorreu um erro'; 
		RETURN NEXT; 

END;

$$ LANGUAGE 'plpgsql';
