DROP FUNCTION IF EXISTS portal.inserir_parceria_estado_municipio(osc INTEGER, identificador_projeto_externo INTEGER, nome_projeto TEXT, data_inicio_projeto DATE, data_fim_projeto DATE, valor_captado_projeto DOUBLE PRECISION, valor_total_projeto DOUBLE PRECISION, descricao_projeto TEXT, status_projeto INTEGER, status_projeto_outro TEXT, orgao_concedente TEXT, fonte_recursos_projeto INTEGER, tipo_parceria INTEGER, tipo_parceria_outro TEXT, usuario TEXT);

CREATE OR REPLACE FUNCTION portal.inserir_parceria_estado_municipio(osc INTEGER, identificador_projeto_externo INTEGER, nome_projeto TEXT, data_inicio_projeto DATE, data_fim_projeto DATE, valor_captado_projeto DOUBLE PRECISION, valor_total_projeto DOUBLE PRECISION, descricao_projeto TEXT, status_projeto INTEGER, status_projeto_outro TEXT, orgao_concedente TEXT, fonte_recursos_projeto INTEGER, tipo_parceria INTEGER, tipo_parceria_outro TEXT, usuario TEXT) RETURNS TABLE(
	flag BOOLEAN, 
	mensagem TEXT
) AS $$

DECLARE 
	projeto INTEGER;

BEGIN 
	INSERT INTO osc.tb_projeto (
		id_osc, 
		tx_identificador_projeto_externo, 
		ft_identificador_projeto_externo, 
		tx_nome_projeto, 
		ft_nome_projeto, 
		dt_data_inicio_projeto, 
		ft_data_inicio_projeto, 
		dt_data_fim_projeto, 
		ft_data_fim_projeto, 
		nr_valor_captado_projeto, 
		ft_valor_captado_projeto, 
		nr_valor_total_projeto, 
		ft_valor_total_projeto, 
		tx_descricao_projeto, 
		ft_descricao_projeto, 
		cd_status_projeto, 
		tx_status_projeto_outro, 
		ft_status_projeto, 
		tx_orgao_concedente, 
		ft_orgao_concedente, 
		bo_oficial
	) 
	VALUES (
		osc, 
		identificador_projeto_externo, 
		usuario, 
		nome_projeto, 
		usuario, 
		data_inicio_projeto, 
		usuario, 
		data_fim_projeto, 
		usuario, 
		valor_captado_projeto, 
		usuario, 
		valor_total_projeto, 
		usuario, 
		descricao_projeto, 
		usuario, 
		status_projeto, 
		status_projeto_outro, 
		usuario, 
		orgao_concedente, 
		usuario, 
		true
	) 
	RETURNING id_projeto INTO projeto;
	
	INSERT INTO osc.tb_fonte_recursos_projeto (
		id_projeto, 
		cd_fonte_recursos_projeto, 
		ft_fonte_recursos_projeto, 
		cd_tipo_parceria, 
		tx_tipo_parceria_outro, 
		ft_tipo_parceria, 
		bo_oficial
	) 
	VALUES (
		projeto, 
		fonte_recursos_projeto, 
		usuario, 
		tipo_parceria, 
		tipo_parceria_outro, 
		usuario, 
		true
	);
	
	flag := true;
	mensagem := 'Parceria inserido.';
	RETURN NEXT;
/*
EXCEPTION 
	WHEN foreign_key_violation THEN 
		flag := false;
		mensagem := 'Dado inválido está sendo utilizado.';
		RETURN NEXT;
	
	WHEN not_null_violation THEN 
		flag := false;
		mensagem := 'Campo(s) obrigatório(s) não foram preenchido(s).';
		RETURN NEXT;
	
	WHEN unique_violation THEN 
		flag := false;
		mensagem := 'Unicidade de campo violado.';
		RETURN NEXT;
	
	WHEN others THEN 
		flag := false;
		mensagem := 'Ocorreu um erro.';
		RETURN NEXT;
*/
END;
$$ LANGUAGE 'plpgsql';
