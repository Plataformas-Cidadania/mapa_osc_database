DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_espacos_participacao_social();

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_espacos_participacao_social() RETURNS TABLE (
	id_osc INTEGER, 
	transparencia NUMERIC, 
	peso DOUBLE PRECISION
) AS $$ 

DECLARE 
	peso DOUBLE PRECISION;

BEGIN 
	peso := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 6); 
	
	RETURN QUERY 
        SELECT 
			conselho.id_osc, 
			(CAST(SUM(
				(CASE WHEN NOT(conselho.tx_nome_conselho IS NULL) THEN 10 ELSE 0 END) + 
				(CASE WHEN NOT(conselho.tx_nome_tipo_participacao IS NULL) THEN 10 ELSE 0 END) + 
				(CASE WHEN NOT(conselho.tx_nome_periodicidade_reuniao_conselho IS NULL) THEN 10 ELSE 0 END) + 
				(CASE WHEN NOT(conselho.dt_data_inicio_conselho IS NULL) THEN 10 ELSE 0 END) + 
				(CASE WHEN NOT(conselho.dt_data_fim_conselho IS NULL) THEN 10 ELSE 0 END) + 
				(CASE WHEN NOT(representante_conselho.tx_nome_representante_conselho IS NULL) THEN 10 ELSE 0 END) + 
				(CASE WHEN NOT(conferencia.tx_nome_conferencia IS NULL) THEN 10 ELSE 0 END) + 
				(CASE WHEN NOT(conferencia.dt_ano_realizacao IS NULL) THEN 10 ELSE 0 END) + 
				(CASE WHEN NOT(conferencia.tx_nome_forma_participacao_conferencia IS NULL) THEN 10 ELSE 0 END) + 
				(CASE WHEN NOT(outra.tx_nome_participacao_social_outra IS NULL) THEN 10 ELSE 0 END)
			) / COUNT(*) AS NUMERIC(7, 2))), 
			peso 
		FROM 
			portal.vw_osc_participacao_social_conselho AS conselho FULL JOIN 
			portal.vw_osc_representante_conselho AS representante_conselho ON conselho.id_osc = representante_conselho.id_osc FULL JOIN 
			portal.vw_osc_participacao_social_conferencia AS conferencia ON conselho.id_osc = conferencia.id_osc FULL JOIN 
			portal.vw_osc_participacao_social_outra AS outra ON conselho.id_osc = outra.id_osc 
		GROUP BY 
			conselho.id_osc;
END;

$$ LANGUAGE 'plpgsql';
