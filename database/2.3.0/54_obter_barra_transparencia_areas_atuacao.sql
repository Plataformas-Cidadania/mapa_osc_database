DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_area_atuacao();

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_area_atuacao() RETURNS TABLE (
	id_osc INTEGER, 
	transparencia NUMERIC, 
	peso DOUBLE PRECISION
) AS $$ 

DECLARE 
	peso DOUBLE PRECISION;

BEGIN 
	peso := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 2); 
	
	RETURN QUERY 
        SELECT 
			area_atuacao.id_osc, 
			(CAST(SUM(
				(CASE WHEN NOT(area_atuacao.tx_nome_area_atuacao IS NULL) OR NOT(area_atuacao.tx_nome_area_atuacao_outra IS NULL) THEN 100 ELSE 0 END)
			) / COUNT(*) AS NUMERIC(7, 2))), 
			peso 
		FROM 
			portal.vw_osc_area_atuacao AS area_atuacao 
		GROUP BY 
			area_atuacao.id_osc;
END;

$$ LANGUAGE 'plpgsql';
