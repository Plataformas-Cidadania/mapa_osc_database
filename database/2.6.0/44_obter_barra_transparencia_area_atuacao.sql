DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_area_atuacao(INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_area_atuacao(osc INTEGER) RETURNS TABLE (
	pontuacao DOUBLE PRECISION
) AS $$ 

DECLARE 
	peso_campo DOUBLE PRECISION;

BEGIN 
	peso_campo := 100.0 / 2.0;
	
	RETURN QUERY 
        SELECT 
			SUM(
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_area_atuacao WHERE id_osc = osc) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN dados_gerais.cd_classe_atividade_economica_osc IS NOT null THEN peso_campo ELSE 0 END)
			)
		FROM 
			osc.tb_dados_gerais AS dados_gerais 
		WHERE  
			dados_gerais.id_osc = osc;
END;

$$ LANGUAGE 'plpgsql';
