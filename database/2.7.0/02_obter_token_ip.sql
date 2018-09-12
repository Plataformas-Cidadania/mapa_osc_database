DROP FUNCTION IF EXISTS portal.obter_token_ip(TEXT, TEXT, TIMESTAMP);

CREATE OR REPLACE FUNCTION portal.obter_token_ip(ip TEXT, token TEXT, data_execucao TIMESTAMP) RETURNS TABLE (
	resultado JSONB,
	mensagem TEXT,
	flag BOOLEAN
) AS $$ 

DECLARE 
	data_expericao TIMESTAMP;
	linha_token RECORD;

BEGIN 
	data_expericao := (data_execucao + interval '1' day)::TIMESTAMP;
	resultado := null;
	
	SELECT INTO linha_token tx_token, dt_data_expiracao, nr_quantidade_acessos 
		FROM portal.tb_token_ip 
		WHERE tx_ip = ip;
	
	IF linha_token IS null THEN 
		INSERT INTO portal.tb_token_ip (tx_ip, tx_token, dt_data_expiracao, nr_quantidade_acessos) 
			VALUES (ip, token, data_expericao, 0) 
			RETURNING tx_token, dt_data_expiracao, nr_quantidade_acessos 
			INTO linha_token;
	
	ELSIF linha_token.dt_data_expiracao < data_execucao THEN 
		UPDATE portal.tb_token_ip 
			SET tx_token = token, dt_data_expiracao = data_expericao, nr_quantidade_acessos = (linha_token.nr_quantidade_acessos + 1) 
			RETURNING tx_token, dt_data_expiracao, nr_quantidade_acessos 
			INTO linha_token;
	END IF;
	
	resultado := TO_JSONB(linha_token);
	mensagem := 'Token retornado.';
	flag := true;
	
	RETURN NEXT;
	
EXCEPTION
	WHEN others THEN 
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_token_ip(
	1::TEXT, 
	123::TEXT, 
	now()::TIMESTAMP
);
