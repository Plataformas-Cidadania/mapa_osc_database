DROP FUNCTION IF EXISTS portal.inserir_log_atualizacao(nometabela TEXT, identificador NUMERIC, fontedados TEXT, dataatualizacao TIMESTAMP, dadoanterior JSON, dadoposterior JSON);

CREATE OR REPLACE FUNCTION portal.inserir_log_atualizacao(nometabela TEXT, identificador NUMERIC, fontedados TEXT, dataatualizacao TIMESTAMP, dadoanterior JSON, dadoposterior JSON) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$

BEGIN 
	INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, tx_fonte_dados, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
	VALUES (nometabela, identificador, fontedados, dataatualizacao, dadoanterior, dadoposterior);
	
	flag := true;
	mensagem := 'Log de alteração de dados inserido.';
	RETURN NEXT;
	
EXCEPTION 
	WHEN others THEN 
		flag := false;
		mensagem := 'Ocorreu um erro.';
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, identificador, dataatualizacao::TIMESTAMP, errolog) AS a;
		RETURN NEXT;
		
END;
$$ LANGUAGE 'plpgsql';
