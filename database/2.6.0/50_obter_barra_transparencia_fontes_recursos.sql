DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_fontes_recursos(osc INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_fontes_recursos(osc INTEGER) RETURNS TABLE (
	pontuacao DOUBLE PRECISION
) AS $$ 

DECLARE 
	peso_campo DOUBLE PRECISION;

BEGIN 
	peso_campo := 100.0 / 4.0;
	
	RETURN QUERY 
        SELECT 
			SUM(
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_recursos_osc JOIN syst.dc_fonte_recursos_osc ON tb_recursos_osc.cd_fonte_recursos_osc = dc_fonte_recursos_osc.cd_fonte_recursos_osc WHERE tb_recursos_osc.id_osc = osc AND tb_recursos_osc.cd_origem_fonte_recursos_osc = 1) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_recursos_osc JOIN syst.dc_fonte_recursos_osc ON tb_recursos_osc.cd_fonte_recursos_osc = dc_fonte_recursos_osc.cd_fonte_recursos_osc WHERE tb_recursos_osc.id_osc = osc AND tb_recursos_osc.cd_origem_fonte_recursos_osc = 2) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_recursos_osc JOIN syst.dc_fonte_recursos_osc ON tb_recursos_osc.cd_fonte_recursos_osc = dc_fonte_recursos_osc.cd_fonte_recursos_osc WHERE tb_recursos_osc.id_osc = osc AND tb_recursos_osc.cd_origem_fonte_recursos_osc = 3) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_recursos_osc JOIN syst.dc_fonte_recursos_osc ON tb_recursos_osc.cd_fonte_recursos_osc = dc_fonte_recursos_osc.cd_fonte_recursos_osc WHERE tb_recursos_osc.id_osc = osc AND tb_recursos_osc.cd_origem_fonte_recursos_osc = 4) THEN peso_campo ELSE 0 END)
			);
END;

$$ LANGUAGE 'plpgsql';
