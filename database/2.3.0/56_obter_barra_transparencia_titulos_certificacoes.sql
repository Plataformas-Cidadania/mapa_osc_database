DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_titulos_certificacoes();

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_titulos_certificacoes() RETURNS TABLE (
	id_osc INTEGER, 
	transparencia NUMERIC
) AS $$ 

BEGIN 
	RETURN QUERY 
        SELECT 
			titulos_certificacoes.id_osc, 
			(CAST(SUM(
				(CASE WHEN NOT(titulos_certificacoes.tx_nome_certificado IS NULL) THEN 100 ELSE 0 END)
			) / COUNT(*) AS NUMERIC(7, 2))) 
		FROM 
			portal.vw_osc_certificado AS titulos_certificacoes
		GROUP BY 
			titulos_certificacoes.id_osc;
END;

$$ LANGUAGE 'plpgsql';
