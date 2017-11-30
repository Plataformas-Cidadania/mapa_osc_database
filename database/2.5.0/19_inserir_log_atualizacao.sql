DROP FUNCTION IF EXISTS portal.inserir_log_atualizacao(nome_tabela TEXT, osc INTEGER, fonte_dados TEXT, data_atualizacao TIMESTAMP, dado_anterior JSON, dado_posterior JSON, id_carga INTEGER);

CREATE OR REPLACE FUNCTION portal.inserir_log_atualizacao(nome_tabela TEXT, osc INTEGER, fonte_dados TEXT, data_atualizacao TIMESTAMP, dado_anterior JSON, dado_posterior JSON, id_carga INTEGER) RETURNS TABLE(
	mensagem TEXT,
	flag BOOLEAN
)AS $$

BEGIN 
	INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, tx_fonte_dados, dt_alteracao, tx_dado_anterior, tx_dado_posterior)
	VALUES (nome_tabela, osc, fonte_dados, data_atualizacao, dado_anterior, dado_posterior);
	
	flag := true;
	mensagem := 'Log de alteração de dados inserido.';
	RETURN NEXT;
	
EXCEPTION
	WHEN others THEN
		flag := false;
		mensagem := 'Ocorreu um erro.';
		
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte_dados, osc, data_atualizacao::TIMESTAMP, true, id_carga) AS a;
		RETURN NEXT;
		
END;
$$ LANGUAGE 'plpgsql';
