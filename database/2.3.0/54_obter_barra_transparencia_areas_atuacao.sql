DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_area_atuacao();

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_area_atuacao() RETURNS TABLE (
	id_osc INTEGER, 
	transparencia NUMERIC
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			area_atuacao.id_osc, 
			CAST((
				(CASE WHEN NOT(area_atuacao.tx_nome_area_atuacao IS NULL) OR NOT(area_atuacao.tx_nome_area_atuacao_outra IS NULL) THEN 15 ELSE 0 END)
			) AS NUMERIC(7,2)) 
		FROM 
			portal.vw_osc_area_atuacao AS area_atuacao;
END;

$$ LANGUAGE 'plpgsql';
