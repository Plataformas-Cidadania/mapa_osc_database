DROP FUNCTION IF EXISTS portal.excluir_recursos_osc(idosc INTEGER);

CREATE OR REPLACE FUNCTION portal.excluir_recursos_osc(idosc INTEGER) RETURNS TABLE(
	flag BOOLEAN, 
	mensagem TEXT
)AS $$

BEGIN 
	DELETE FROM 
		osc.tb_recursos_osc 
	WHERE 
		id_recursos_osc = idosc;
	
	flag := true;
	mensagem := 'Recursos de OSC excluído.';
	RETURN NEXT;

EXCEPTION 
	WHEN not_null_violation THEN
		flag := false;
		mensagem := 'Campo(s) obrigatório(s) não preenchido(s) na exclusão de recursos de OSC no banco de dados.';
		RETURN NEXT;
		
	WHEN unique_violation THEN
		flag := false;
		mensagem := 'Dado(s) único(s) violado(s) na exclusão de recursos de OSC no banco de dados.';
		RETURN NEXT;
		
	WHEN others THEN 
		flag := false;
		mensagem := 'Ocorreu um erro na exclusão de recursos de OSC no banco de dados.';
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
