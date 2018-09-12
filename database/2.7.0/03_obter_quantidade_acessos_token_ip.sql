DROP FUNCTION IF EXISTS portal.obter_quantidade_acessos_token_ip(TEXT, TIMESTAMP);

CREATE OR REPLACE FUNCTION portal.obter_quantidade_acessos_token_ip(ip TEXT, data_execucao TIMESTAMP) RETURNS TABLE (
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

	IF linha_token IS NOT null THEN 
        IF linha_token.dt_data_expiracao < data_execucao THEN 
            UPDATE portal.tb_token_ip 
                SET tx_token = token, dt_data_expiracao = data_expericao, nr_quantidade_acessos = (linha_token.nr_quantidade_acessos + 1) 
                RETURNING tx_token, dt_data_expiracao, nr_quantidade_acessos 
                INTO linha_token;
        END IF;
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
