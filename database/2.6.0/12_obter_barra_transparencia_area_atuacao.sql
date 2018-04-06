DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_area_atuacao();

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_area_atuacao() RETURNS TABLE (
	id_osc INTEGER, 
	transparencia NUMERIC, 
	peso DOUBLE PRECISION
) AS $$ 

DECLARE 
	peso_segmento DOUBLE PRECISION;
	peso_campo DOUBLE PRECISION;

BEGIN 
	peso_segmento := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 2); 
	peso_campo := 100.0 / 2.0;
	
	RETURN QUERY 
        SELECT 
		area_atuacao.id_osc, 
		(CAST(SUM(
			(CASE WHEN NOT(area_atuacao.tx_nome_area_atuacao IS NULL) OR NOT(area_atuacao.tx_nome_area_atuacao_outra IS NULL) THEN peso_campo ELSE 0 END) + 
			(CASE WHEN NOT(dados_gerais.cd_atividade_economica_osc IS NULL) THEN peso_campo ELSE 0 END)
		) / COUNT(*) AS NUMERIC(7, 2))), 
		peso_segmento 
	FROM 
		portal.vw_osc_area_atuacao AS area_atuacao 
	FULL JOIN 
		portal.vw_osc_dados_gerais AS dados_gerais 
	ON 
		area_atuacao.id_osc = dados_gerais.id_osc 
	GROUP BY 
		area_atuacao.id_osc;
END;

$$ LANGUAGE 'plpgsql';
