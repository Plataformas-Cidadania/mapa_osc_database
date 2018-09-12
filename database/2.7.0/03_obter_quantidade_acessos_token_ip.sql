DROP FUNCTION IF EXISTS portal.obter_quantidade_acessos_token_ip(TEXT);

CREATE OR REPLACE FUNCTION portal.obter_quantidade_acessos_token_ip(ip TEXT) RETURNS TABLE (
	resultado JSONB,
	mensagem TEXT,
	flag BOOLEAN
) AS $$ 

DECLARE
	data_execucao TIMESTAMP;
	quantiade_limite_acesso INTEGER;
	linha_token RECORD;

BEGIN 
	data_execucao := now();
	quantiade_limite_acesso := 100;
	resultado := null;

	SELECT INTO linha_token tx_token, dt_data_expiracao, nr_quantidade_acessos 
		FROM portal.tb_token_ip 
		WHERE tx_ip = ip;

	IF linha_token IS NOT null THEN 
        IF linha_token.dt_data_expiracao > data_execucao THEN 
			IF quantiade_limite_acesso > linha_token.nr_quantidade_acessos THEN 
				UPDATE portal.tb_token_ip 
					SET nr_quantidade_acessos = (nr_quantidade_acessos + 1);

				resultado := TO_JSONB(linha_token);
				mensagem := 'Token retornado.';
				flag := true;

			ELSE
				mensagem := 'Este IP atingiu o limite de acessos permitidos.';
				flag := false;
			END IF;

		ELSE
			mensagem := 'O token deste IP expirou.';
			flag := false;
        END IF;

	ELSE 
		mensagem := 'Este IP não possui token.';
		flag := false;
	END IF;

	RETURN NEXT;

EXCEPTION
	WHEN others THEN 
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;

$$ LANGUAGE 'plpgsql';
