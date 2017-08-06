DROP FUNCTION IF EXISTS portal.inserir_assinante_newsletter(email TEXT, nome TEXT);

CREATE OR REPLACE FUNCTION portal.inserir_assinante_newsletter(email TEXT, nome TEXT) RETURNS TABLE(
	flag BOOLEAN,
	mensagem TEXT
)AS $$

BEGIN
	INSERT INTO portal.tb_newsletters (tx_email_assinante, tx_nome_assinante) 
	VALUES (email, nome);
	
	flag := true;
	mensagem := 'Assinante de newsletter cadastrado.';
	RETURN NEXT;

EXCEPTION 
	WHEN not_null_violation THEN 
		flag := false;
		mensagem := 'Campo(s) obrigatório(s) não foram preenchido(s).';
		RETURN NEXT;
		
	WHEN unique_violation THEN 
		flag := false;
		mensagem := 'Este e-mail já está sendo utilizado.';
		RETURN NEXT;
		
	WHEN others THEN 
		flag := false;
		mensagem := 'Ocorreu um erro.';
		RETURN NEXT;
		
END;
$$ LANGUAGE 'plpgsql';