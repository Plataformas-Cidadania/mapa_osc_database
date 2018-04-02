DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_projetos_atividades_programas();

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_projetos_atividades_programas() RETURNS TABLE (
	id_osc INTEGER, 
	transparencia NUMERIC, 
	peso DOUBLE PRECISION
) AS $$ 

DECLARE 
	peso_segmento DOUBLE PRECISION;
	peso_campo DOUBLE PRECISION;

BEGIN 
	peso_segmento := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 7);
	peso_campo := 100 / 11;

	RETURN QUERY 
        SELECT 
			projeto.id_osc, 
			(
				CASE WHEN (osc.bo_nao_possui_projeto IS true) THEN 100.0 ELSE (
					CAST(SUM(
						(CASE WHEN NOT(projeto.tx_descricao_projeto IS NULL) THEN peso_campo ELSE 0 END) + 
						(CASE WHEN NOT(projeto.tx_nome_status_projeto IS NULL) THEN peso_campo ELSE 0 END) + 
						(CASE WHEN NOT(projeto.dt_data_inicio_projeto IS NULL) THEN peso_campo ELSE 0 END) + 
						(CASE WHEN NOT(projeto.dt_data_fim_projeto IS NULL) THEN peso_campo ELSE 0 END) + 
						(CASE WHEN NOT(projeto.nr_valor_total_projeto IS NULL) THEN peso_campo ELSE 0 END) + 
						(CASE WHEN NOT(projeto.nr_valor_captado_projeto IS NULL) THEN peso_campo ELSE 0 END) + 
						(CASE WHEN NOT(projeto.tx_nome_abrangencia_projeto IS NULL) THEN peso_campo ELSE 0 END) + 
						(CASE WHEN NOT(projeto.tx_nome_zona_atuacao IS NULL) THEN peso_campo ELSE 0 END) + 
						(CASE WHEN NOT(fonte_recursos.tx_nome_origem_fonte_recursos_projeto IS NULL) THEN peso_campo ELSE 0 END) + 
						(CASE WHEN NOT(objetivo.tx_nome_objetivo_projeto IS NULL) THEN peso_campo ELSE 0 END) + 
						(CASE WHEN NOT(objetivo.tx_nome_meta_projeto IS NULL) THEN peso_campo ELSE 0 END)
					) / COUNT(*) AS NUMERIC(7, 2))
				) END 
			), 
			peso_segmento 
		FROM 
			portal.vw_osc_projeto AS projeto FULL JOIN 
			portal.vw_osc_fonte_recursos_projeto AS fonte_recursos ON projeto.id_projeto = fonte_recursos.id_projeto FULL JOIN 
			portal.vw_osc_publico_beneficiado_projeto AS publico_beneficiado ON projeto.id_projeto = publico_beneficiado.id_projeto FULL JOIN 
			portal.vw_osc_objetivo_projeto AS objetivo ON projeto.id_projeto = objetivo.id_projeto FULL JOIN 
			osc.tb_osc AS osc ON osc.id_osc = projeto.id_osc 
		GROUP BY 
			projeto.id_osc;
END;

$$ LANGUAGE 'plpgsql';
