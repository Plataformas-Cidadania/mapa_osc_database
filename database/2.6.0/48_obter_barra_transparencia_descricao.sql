DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_descricao(INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_descricao(osc INTEGER) RETURNS TABLE (
	pontuacao DOUBLE PRECISION
) AS $$ 

DECLARE 
	peso_campo DOUBLE PRECISION;

BEGIN 
	peso_campo := 100.0 / 5.0;
	
	RETURN QUERY 
        SELECT 
			SUM(
				(CASE WHEN dados_gerais.tx_historico IS NOT null THEN peso_campo ELSE 0 END) + 
				(CASE WHEN dados_gerais.tx_missao_osc IS NOT null THEN peso_campo ELSE 0 END) + 
				(CASE WHEN dados_gerais.tx_visao_osc IS NOT null THEN peso_campo ELSE 0 END) + 
				(CASE WHEN dados_gerais.tx_finalidades_estatutarias IS NOT null THEN peso_campo ELSE 0 END) + 
				(CASE WHEN dados_gerais.tx_link_estatuto_osc IS NOT null THEN peso_campo ELSE 0 END)
			) 
		FROM 
			osc.tb_dados_gerais AS dados_gerais 
		WHERE 
			dados_gerais.id_osc = osc;
END;

$$ LANGUAGE 'plpgsql';
