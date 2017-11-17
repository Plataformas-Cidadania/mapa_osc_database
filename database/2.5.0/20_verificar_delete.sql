DROP FUNCTION IF EXISTS portal.verificar_delete(prioridade INTEGER, fontes TEXT[]);

CREATE OR REPLACE FUNCTION portal.verificar_delete(prioridade INTEGER, fontes TEXT[]) RETURNS TABLE(
	flag BOOLEAN
) AS $$

DECLARE 
	fonte TEXT;
	fonte_ajustada TEXT;
	
BEGIN 
	flag := true;
	
	FOREACH fonte IN ARRAY fontes 
	LOOP 
		fonte_ajustada := SUBSTRING(fonte FROM 0 FOR char_length(fonte) - position(' ' in reverse(fonte)) + 1);
		
		IF prioridade > (SELECT COALESCE(MIN(nr_prioridade), 99) FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = fonte OR cd_sigla_fonte_dados = fonte_ajustada) THEN 
			flag := false;
		END IF;
	END LOOP;
	
	RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
