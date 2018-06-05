DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_espacos_participacao_social(INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_espacos_participacao_social(osc INTEGER) RETURNS TABLE (
	pontuacao DOUBLE PRECISION
) AS $$ 

DECLARE 
	peso_campo DOUBLE PRECISION;

BEGIN  
	peso_campo := 100.0 / 10.0;
	
	RETURN QUERY 
        SELECT 
			SUM(
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_participacao_social_conselho WHERE id_osc = osc AND cd_conselho IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_participacao_social_conselho WHERE id_osc = osc AND cd_tipo_participacao IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_participacao_social_conselho WHERE id_osc = osc AND cd_periodicidade_reuniao_conselho IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_participacao_social_conselho WHERE id_osc = osc AND dt_data_inicio_conselho IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_participacao_social_conselho WHERE id_osc = osc AND dt_data_fim_conselho IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_representante_conselho WHERE id_osc = osc AND tx_nome_representante_conselho IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_participacao_social_conferencia WHERE id_osc = osc AND cd_conferencia IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_participacao_social_conferencia WHERE id_osc = osc AND dt_ano_realizacao IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_participacao_social_conferencia WHERE id_osc = osc AND cd_forma_participacao_conferencia IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_participacao_social_outra WHERE id_osc = osc AND tx_nome_participacao_social_outra IS NOT null) THEN peso_campo ELSE 0 END)
			);
END;

$$ LANGUAGE 'plpgsql';
