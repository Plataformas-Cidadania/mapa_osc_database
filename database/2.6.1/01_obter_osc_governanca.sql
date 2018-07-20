DROP FUNCTION IF EXISTS portal.obter_osc_governanca(TEXT);

CREATE OR REPLACE FUNCTION portal.obter_osc_governanca(param TEXT) RETURNS TABLE (
	resultado JSONB,
	mensagem TEXT,
	flag BOOLEAN
) AS $$ 

DECLARE
	linha RECORD;
	osc RECORD;

BEGIN 
	resultado := null;

	SELECT INTO osc * FROM osc.tb_osc WHERE (id_osc = param::INTEGER OR tx_apelido_osc = param) AND bo_osc_ativa;
	
	IF osc.id_osc IS NOT null THEN 		
		SELECT INTO linha
			array_agg(a) AS array 
		FROM (
			SELECT 
				tb_governanca.id_dirigente,
				tb_governanca.tx_cargo_dirigente,
				tb_governanca.ft_cargo_dirigente,
				tb_governanca.tx_nome_dirigente,
				tb_governanca.ft_nome_dirigente
			FROM 
				osc.tb_governanca
			WHERE 
				tb_governanca.id_osc = osc.id_osc
		) a;

		IF ARRAY_LENGTH(linha.array, 1) > 0 THEN 
			resultado := to_jsonb(linha.array);
		END IF;

		flag := true;
		mensagem := 'Governança retornada.';
		
	ELSE 
		flag := false;
		mensagem := 'OSC não encontrada.';
	END IF;

	RETURN NEXT;
	
EXCEPTION
	WHEN others THEN 
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;
$$ LANGUAGE 'plpgsql';
