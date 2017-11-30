DROP FUNCTION IF EXISTS portal.inserir_log_atualizacao(nometabela TEXT, osc INTEGER, fontedados TEXT, dataatualizacao TIMESTAMP, dadoanterior JSON, dadoposterior JSON, id_carga INTEGER);

CREATE OR REPLACE FUNCTION portal.inserir_log_atualizacao(nometabela TEXT, osc INTEGER, fontedados TEXT, dataatualizacao TIMESTAMP, dadoanterior JSON, dadoposterior JSON, id_carga INTEGER) RETURNS TABLE(
	mensagem TEXT,
	flag BOOLEAN
)AS $$

DECLARE
	operacao TEXT;

BEGIN
	operacao := 'portal.inserir_log_atualizacao(' || nometabela::TEXT || ', ' || osc::TEXT || ', ' || fontedados::TEXT || ', ' || dataatualizacao::TEXT || ', ' || dadoanterior::TEXT || ', ' || dadoposterior::TEXT ||', ' || id_carga::TEXT || ')';

	INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, tx_fonte_dados, dt_alteracao, tx_dado_anterior, tx_dado_posterior, id_carga)
	VALUES (nometabela, osc, fontedados, dataatualizacao, dadoanterior, dadoposterior, id_carga);

	flag := true;
	mensagem := 'Log de alteração de dados inserido.';
	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;
		mensagem := 'Ocorreu um erro.';

		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, osc, dataatualizacao::TIMESTAMP, TRUE, id_carga) AS a;
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
