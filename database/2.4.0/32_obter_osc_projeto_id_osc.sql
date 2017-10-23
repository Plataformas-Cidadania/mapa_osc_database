-- Function: portal.obter_osc_projeto_id_osc(text)

DROP FUNCTION portal.obter_osc_projeto_id_osc(text);

CREATE OR REPLACE FUNCTION portal.obter_osc_projeto_id_osc(IN param text)
  RETURNS TABLE(id_projeto integer, tx_identificador_projeto_externo text, ft_identificador_projeto_externo text, tx_nome_projeto text, ft_nome_projeto text, cd_status_projeto integer, tx_nome_status_projeto text, ft_status_projeto text, dt_data_inicio_projeto text, ft_data_inicio_projeto text, dt_data_fim_projeto text, ft_data_fim_projeto text, tx_link_projeto text, ft_link_projeto text, nr_total_beneficiarios integer, ft_total_beneficiarios text, nr_valor_total_projeto text, ft_valor_total_projeto text, nr_valor_captado_projeto text, ft_valor_captado_projeto text, tx_metodologia_monitoramento text, ft_metodologia_monitoramento text, tx_descricao_projeto text, ft_descricao_projeto text, cd_abrangencia_projeto integer, tx_nome_abrangencia_projeto text, ft_abrangencia_projeto text, cd_zona_atuacao_projeto integer, tx_nome_zona_atuacao text, ft_zona_atuacao_projeto text) AS
$BODY$ 
BEGIN 
	RETURN QUERY 
		SELECT 
			vw_osc_projeto.id_projeto, 
			vw_osc_projeto.tx_identificador_projeto_externo, 
			vw_osc_projeto.ft_identificador_projeto_externo, 
			vw_osc_projeto.tx_nome_projeto, 
			vw_osc_projeto.ft_nome_projeto, 
			vw_osc_projeto.cd_status_projeto, 
			vw_osc_projeto.tx_nome_status_projeto, 
			vw_osc_projeto.ft_status_projeto, 
			vw_osc_projeto.dt_data_inicio_projeto, 
			vw_osc_projeto.ft_data_inicio_projeto, 
			vw_osc_projeto.dt_data_fim_projeto, 
			vw_osc_projeto.ft_data_fim_projeto, 
			vw_osc_projeto.tx_link_projeto, 
			vw_osc_projeto.ft_link_projeto, 
			vw_osc_projeto.nr_total_beneficiarios, 
			vw_osc_projeto.ft_total_beneficiarios, 
			vw_osc_projeto.nr_valor_total_projeto, 
			vw_osc_projeto.ft_valor_total_projeto, 
			vw_osc_projeto.nr_valor_captado_projeto, 
			vw_osc_projeto.ft_valor_captado_projeto, 
			vw_osc_projeto.tx_metodologia_monitoramento, 
			vw_osc_projeto.ft_metodologia_monitoramento, 
			vw_osc_projeto.tx_descricao_projeto, 
			vw_osc_projeto.ft_descricao_projeto, 
			vw_osc_projeto.cd_abrangencia_projeto, 
			vw_osc_projeto.tx_nome_abrangencia_projeto, 
			vw_osc_projeto.ft_abrangencia_projeto, 
			vw_osc_projeto.cd_zona_atuacao_projeto, 
			vw_osc_projeto.tx_nome_zona_atuacao, 
			vw_osc_projeto.ft_zona_atuacao_projeto 
		FROM 
			portal.vw_osc_projeto 
		WHERE 
			vw_osc_projeto.id_osc::TEXT = param OR 
			vw_osc_projeto.tx_apelido_osc = param;
	RETURN;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION portal.obter_osc_projeto_id_osc(text)
  OWNER TO postgres;
