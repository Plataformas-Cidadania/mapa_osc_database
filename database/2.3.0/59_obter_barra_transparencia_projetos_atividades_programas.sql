DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_projetos_atividades_programas();

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_projetos_atividades_programas() RETURNS TABLE (
	id_osc INTEGER, 
	transparencia NUMERIC, 
	peso DOUBLE PRECISION
) AS $$ 

DECLARE 
	peso DOUBLE PRECISION;

BEGIN 
	peso := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 7); 
	
	RETURN QUERY 
        SELECT 
			projeto.id_osc, 
			(CAST(SUM(
				(CASE WHEN NOT(projeto.tx_descricao_projeto IS NULL) THEN 5.555555555555556 ELSE 0 END) + 
				(CASE WHEN NOT(projeto.tx_nome_status_projeto IS NULL) THEN 5.555555555555556 ELSE 0 END) + 
				(CASE WHEN NOT(projeto.dt_data_inicio_projeto IS NULL) THEN 5.555555555555556 ELSE 0 END) + 
				(CASE WHEN NOT(projeto.dt_data_fim_projeto IS NULL) THEN 5.555555555555556 ELSE 0 END) + 
				(CASE WHEN NOT(projeto.tx_link_projeto IS NULL) THEN 5.555555555555556 ELSE 0 END) + 
				(CASE WHEN NOT(projeto.nr_total_beneficiarios IS NULL) THEN 5.555555555555556 ELSE 0 END) + 
				(CASE WHEN NOT(projeto.nr_valor_total_projeto IS NULL) THEN 5.555555555555556 ELSE 0 END) + 
				(CASE WHEN NOT(projeto.nr_valor_captado_projeto IS NULL) THEN 5.555555555555556 ELSE 0 END) + 
				(CASE WHEN NOT(projeto.tx_nome_abrangencia_projeto IS NULL) THEN 5.555555555555556 ELSE 0 END) + 
				(CASE WHEN NOT(projeto.tx_nome_zona_atuacao IS NULL) THEN 5.555555555555556 ELSE 0 END) + 
				(CASE WHEN NOT(projeto.tx_metodologia_monitoramento IS NULL) THEN 5.555555555555556 ELSE 0 END) + 
				(CASE WHEN NOT(fonte_recursos.tx_nome_origem_fonte_recursos_projeto IS NULL) THEN 5.555555555555556 ELSE 0 END) + 
				(CASE WHEN NOT(publico_beneficiado.tx_nome_publico_beneficiado IS NULL) THEN 5.555555555555556 ELSE 0 END) + 
				(CASE WHEN NOT(parceira_projeto.tx_nome_osc_parceira_projeto IS NULL) THEN 5.555555555555556 ELSE 0 END) + 
				(CASE WHEN NOT(area_atuacao.tx_nome_area_atuacao_projeto IS NULL) THEN 5.555555555555556 ELSE 0 END) + 
				(CASE WHEN NOT(financiador.tx_nome_financiador IS NULL) THEN 5.555555555555556 ELSE 0 END) + 
				(CASE WHEN NOT(objetivo.tx_nome_objetivo_projeto IS NULL) THEN 5.555555555555556 ELSE 0 END) + 
				(CASE WHEN NOT(objetivo.tx_nome_meta_projeto IS NULL) THEN 5.555555555555556 ELSE 0 END)
			) / COUNT(*) AS NUMERIC(7, 2))), 
			peso 
		FROM 
			portal.vw_osc_projeto AS projeto FULL JOIN 
			portal.vw_osc_fonte_recursos_projeto AS fonte_recursos ON projeto.id_projeto = fonte_recursos.id_projeto FULL JOIN 
			portal.vw_osc_publico_beneficiado_projeto AS publico_beneficiado ON projeto.id_projeto = publico_beneficiado.id_projeto FULL JOIN 
			portal.vw_osc_parceira_projeto AS parceira_projeto ON projeto.id_projeto = parceira_projeto.id_projeto FULL JOIN 
			portal.vw_osc_area_atuacao_projeto AS area_atuacao ON projeto.id_projeto = area_atuacao.id_projeto FULL JOIN 
			portal.vw_osc_financiador_projeto AS financiador ON projeto.id_projeto = financiador.id_projeto FULL JOIN 
			portal.vw_osc_objetivo_projeto AS objetivo ON projeto.id_projeto = objetivo.id_projeto 
		GROUP BY 
			projeto.id_osc;
END;

$$ LANGUAGE 'plpgsql';
