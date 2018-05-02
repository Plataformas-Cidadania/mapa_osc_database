DROP FUNCTION IF EXISTS portal.obter_osc_conselho_fiscal(TEXT);

CREATE OR REPLACE FUNCTION portal.obter_osc_conselho_fiscal(param TEXT) RETURNS TABLE (
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
			id_conselheiro,
			tx_nome_conselheiro,
			ft_nome_conselheiro
		FROM 
			osc.tb_conselho_fiscal
		WHERE 
			id_osc = osc.id_osc;

		IF linha != (null::INTEGER, null::TEXT, null::TEXT)::RECORD THEN 
			resultado := to_jsonb(linha);
		END IF;

		flag := true;
		mensagem := 'Conselho fiscal retornado.';
		
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

SELECT * FROM portal.obter_osc_conselho_fiscal('789809');

