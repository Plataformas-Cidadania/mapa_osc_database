DROP FUNCTION IF EXISTS portal.verificar_dado(dado_anterior TEXT, fonte_dado_anterior TEXT, dado_posterior TEXT, dado_posterior_prioridade INTEGER, nullvalido BOOLEAN);

CREATE OR REPLACE FUNCTION portal.verificar_dado(dado_anterior TEXT, fonte_dado_anterior TEXT, dado_posterior TEXT, dado_posterior_prioridade INTEGER, nullvalido BOOLEAN) RETURNS TABLE(
	flag BOOLEAN
) AS $$

DECLARE 
	fonte_ajustada TEXT;

BEGIN 
	flag := false;
	
	IF (
		(nullvalido = true AND dado_anterior <> dado_posterior) 
		OR (nullvalido = false AND dado_anterior <> dado_posterior AND (dado_posterior::TEXT = '') IS FALSE)
	) AND (
		fonte_dado_anterior IS null 
		OR dado_posterior_prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = fonte_dado_anterior)
	) THEN 
		flag := true;
	END IF;
	
	RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
