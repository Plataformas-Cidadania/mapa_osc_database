
DROP FUNCTION IF EXISTS portal.verificar_acesso_ip(TEXT);

CREATE OR REPLACE FUNCTION portal.verificar_acesso_ip(ip TEXT) RETURNS TABLE (
	resultado JSONB,
	mensagem TEXT,
	flag BOOLEAN
) AS $$ 

DECLARE
	data_execucao TIMESTAMP;
	data_expericao TIMESTAMP;
	quantiade_limite_acesso INTEGER;
	tb_acesso_ip RECORD;

BEGIN
	data_execucao := now();
	data_expericao := (data_execucao + interval '1' day)::TIMESTAMP;
	quantiade_limite_acesso := 100;

	resultado := null;
	flag := false;

	SELECT INTO tb_acesso_ip dt_data_expiracao, nr_quantidade_acessos
		FROM portal.tb_acesso_ip
		WHERE tx_ip = ip;
	
	IF tb_acesso_ip IS NOT null THEN
		IF tb_acesso_ip.dt_data_expiracao > data_execucao THEN
			IF quantiade_limite_acesso > tb_acesso_ip.nr_quantidade_acessos THEN
				UPDATE portal.tb_acesso_ip
					SET nr_quantidade_acessos = (nr_quantidade_acessos + 1)
					WHERE tx_ip = ip
					RETURNING dt_data_expiracao, nr_quantidade_acessos
					INTO tb_acesso_ip;
				
				flag := true;
			END IF;

		ELSE 
			UPDATE portal.tb_acesso_ip
				SET dt_data_expiracao = data_expericao, nr_quantidade_acessos = 1
				WHERE tx_ip = ip
				RETURNING dt_data_expiracao, nr_quantidade_acessos
				INTO tb_acesso_ip;
			flag := true;

        END IF;

	ELSE 
		RAISE NOTICE '%', 10;
		INSERT INTO portal.tb_acesso_ip (tx_ip, dt_data_expiracao, nr_quantidade_acessos) 
			VALUES (ip, data_expericao, 1) 
			RETURNING dt_data_expiracao, nr_quantidade_acessos 
			INTO tb_acesso_ip;
		flag := true;
	END IF;

	IF flag THEN 
		resultado := TO_JSONB(tb_acesso_ip);
		mensagem := 'Acesso autorizado.';
	ELSE 
		mensagem := 'Acesso não autorizado.';
	END IF;

	RETURN NEXT;

EXCEPTION
	WHEN others THEN 
		RAISE NOTICE '%', SQLERRM;
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;

$$ LANGUAGE 'plpgsql';