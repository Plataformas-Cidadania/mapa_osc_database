DROP FUNCTION IF EXISTS portal.inserir_edital(orgao TEXT, programa TEXT, areainteresse TEXT, dtvencimento DATE, link TEXT, numerochamada TEXT);

CREATE OR REPLACE FUNCTION portal.inserir_edital(orgao TEXT, programa TEXT, areainteresse TEXT, dtvencimento DATE, link TEXT, numerochamada TEXT) RETURNS TABLE(
	flag BOOLEAN,
	mensagem TEXT
)AS $$

BEGIN
	INSERT INTO 
		portal.tb_edital(tx_orgao, tx_programa, tx_area_interesse_edital, dt_vencimento, tx_link_edital, tx_numero_chamada) 
	VALUES 
		(orgao, programa, areainteresse, dtvencimento, link, numerochamada);
	
	flag := true;
	mensagem := 'Edital criado.';
	RETURN NEXT;

EXCEPTION
	WHEN not_null_violation THEN
		flag := false;
		mensagem := 'Campo(s) obrigat�rio(s) n�o preenchido(s) na grava��o de edital no banco de dados.';
		RETURN NEXT;
		
	WHEN unique_violation THEN
		flag := false;
		mensagem := 'Dado(s) �nico(s) violado(s) na grava��o de edital  no banco de dados.';
		RETURN NEXT;
		
	WHEN others THEN
		flag := false;
		mensagem := 'Ocorreu um erro na grava��o de edital no banco de dados.';
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
