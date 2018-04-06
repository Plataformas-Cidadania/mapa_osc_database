DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_titulos_certificacoes(INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_titulos_certificacoes(osc INTEGER) RETURNS TABLE (
	pontuacao DOUBLE PRECISION
) AS $$ 

DECLARE 
	peso_campo DOUBLE PRECISION;

BEGIN 
	peso_campo := 100.0 / 1.0;
	
	RETURN QUERY 
        SELECT 
			(CASE WHEN EXISTS(SELECT * FROM osc.tb_certificado WHERE id_osc = osc) THEN peso_campo ELSE 0 END);
END;

$$ LANGUAGE 'plpgsql';
