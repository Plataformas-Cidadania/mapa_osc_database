DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_relacoes_trabalho_governanca(INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_relacoes_trabalho_governanca(osc INTEGER) RETURNS TABLE (
	pontuacao DOUBLE PRECISION
) AS $$ 

DECLARE 
	peso_campo DOUBLE PRECISION;

BEGIN 
	peso_campo := 100.0 / 5.0;
	
	RETURN QUERY 
        SELECT 
			SUM(
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_governanca WHERE id_osc = osc AND tx_nome_dirigente IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_conselho_fiscal WHERE id_osc = osc AND tx_nome_conselheiro IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN relacoes_trabalho.nr_trabalhadores_vinculo IS NOT null THEN peso_campo ELSE 0 END) + 
				(CASE WHEN relacoes_trabalho.nr_trabalhadores_deficiencia IS NOT null THEN peso_campo ELSE 0 END) + 
				(CASE WHEN relacoes_trabalho.nr_trabalhadores_voluntarios IS NOT null THEN peso_campo ELSE 0 END)
			)
		FROM 
			osc.tb_relacoes_trabalho AS relacoes_trabalho 
		WHERE 
			relacoes_trabalho.id_osc = osc;
END;

$$ LANGUAGE 'plpgsql';
