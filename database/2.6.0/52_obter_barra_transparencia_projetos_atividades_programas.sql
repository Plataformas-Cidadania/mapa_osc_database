DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_projetos_atividades_programas(INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_projetos_atividades_programas(osc INTEGER) RETURNS TABLE (
	pontuacao DOUBLE PRECISION
) AS $$ 

DECLARE 
	peso_campo DOUBLE PRECISION;

BEGIN 
	peso_campo := 100.0 / 10.0;

	RETURN QUERY 
        SELECT 
			SUM(
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_projeto WHERE id_osc = osc AND tx_descricao_projeto IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_projeto WHERE id_osc = osc AND cd_status_projeto IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_projeto WHERE id_osc = osc AND dt_data_inicio_projeto IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_projeto WHERE id_osc = osc AND dt_data_fim_projeto IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_projeto WHERE id_osc = osc AND nr_valor_total_projeto IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_projeto WHERE id_osc = osc AND nr_valor_captado_projeto IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_projeto WHERE id_osc = osc AND cd_abrangencia_projeto IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_projeto WHERE id_osc = osc AND cd_zona_atuacao_projeto IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_fonte_recursos_projeto JOIN osc.tb_projeto ON tb_fonte_recursos_projeto.id_projeto = tb_projeto.id_projeto WHERE tb_projeto.id_osc = osc AND tb_fonte_recursos_projeto.cd_origem_fonte_recursos_projeto IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_objetivo_projeto JOIN osc.tb_projeto ON tb_objetivo_projeto.id_projeto = tb_projeto.id_projeto WHERE tb_projeto.id_osc = osc AND tb_objetivo_projeto.cd_meta_projeto IS NOT null) THEN peso_campo ELSE 0 END)
			);
END;

$$ LANGUAGE 'plpgsql';
