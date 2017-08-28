DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_descricao();

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_descricao() RETURNS TABLE (
	id_osc INTEGER, 
	transparencia NUMERIC
) AS $$ 

BEGIN 
	RETURN QUERY 
        SELECT 
			descricao.id_osc, 
			(CAST(SUM(
				(CASE WHEN NOT(descricao.tx_historico IS NULL) THEN 30 ELSE 0 END) + 
				(CASE WHEN NOT(descricao.tx_missao_osc IS NULL) THEN 10 ELSE 0 END) + 
				(CASE WHEN NOT(descricao.tx_visao_osc IS NULL) THEN 10 ELSE 0 END) + 
				(CASE WHEN NOT(descricao.tx_finalidades_estatutarias IS NULL) THEN 45 ELSE 0 END) + 
				(CASE WHEN NOT(descricao.tx_link_estatuto_osc IS NULL) THEN 5 ELSE 0 END)
			) / COUNT(*) AS NUMERIC(7, 2))) 
		FROM 
			portal.vw_osc_descricao AS descricao 
		GROUP BY 
			descricao.id_osc;
END;

$$ LANGUAGE 'plpgsql';
