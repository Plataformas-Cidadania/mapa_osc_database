DROP FUNCTION IF EXISTS portal.obter_osc_projetos(TEXT, INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_osc_projetos(param TEXT, tipo INTEGER) RETURNS TABLE (
	resultado JSONB,
	mensagem TEXT,
	flag BOOLEAN
) AS $$ 

DECLARE
	tb_osc RECORD;

BEGIN 
	SELECT INTO tb_osc * FROM osc.tb_osc WHERE id_osc::TEXT = param OR tx_apelido_osc = param;
	
	IF tb_osc.bo_nao_possui_projeto IS NOT true THEN 
		IF tipo = 1 THEN 
			resultado := (
				jsonb_build_object(
					'bo_nao_possui_projeto', tb_osc.bo_nao_possui_projeto, 
					'ft_nao_possui_projeto', tb_osc.ft_nao_possui_projeto, 
					'projetos', (
						SELECT 
							jsonb_agg(
								jsonb_build_object(
									'id_projeto', tb_projeto.id_projeto, 
									'tx_identificador_projeto_externo', tb_projeto.tx_identificador_projeto_externo, 
									'ft_identificador_projeto_externo', tb_projeto.ft_identificador_projeto_externo, 
									'tx_nome_projeto', tb_projeto.tx_nome_projeto, 
									'ft_nome_projeto', tb_projeto.ft_nome_projeto, 
									'cd_status_projeto', tb_projeto.cd_status_projeto, 
									'tx_nome_status_projeto', dc_status_projeto.tx_nome_status_projeto, 
									'tx_status_projeto_outro', tb_projeto.tx_status_projeto_outro, 
									'ft_status_projeto', tb_projeto.ft_status_projeto, 
									'dt_data_inicio_projeto', TO_CHAR(tb_projeto.dt_data_inicio_projeto, 'DD-MM-YYYY'), 
									'ft_data_inicio_projeto', tb_projeto.ft_data_inicio_projeto, 
									'dt_data_fim_projeto', TO_CHAR(tb_projeto.dt_data_fim_projeto, 'DD-MM-YYYY'), 
									'ft_data_fim_projeto', tb_projeto.ft_data_fim_projeto, 
									'tx_link_projeto', tb_projeto.tx_link_projeto, 
									'ft_link_projeto', tb_projeto.ft_link_projeto, 
									'nr_total_beneficiarios', tb_projeto.nr_total_beneficiarios, 
									'ft_total_beneficiarios', tb_projeto.ft_total_beneficiarios, 
									'nr_valor_total_projeto', tb_projeto.nr_valor_total_projeto, 
									'ft_valor_total_projeto', tb_projeto.ft_valor_total_projeto, 
									'nr_valor_captado_projeto', tb_projeto.nr_valor_captado_projeto, 
									'ft_valor_captado_projeto', tb_projeto.ft_valor_captado_projeto, 
									'tx_metodologia_monitoramento', tb_projeto.tx_metodologia_monitoramento, 
									'ft_metodologia_monitoramento', tb_projeto.ft_metodologia_monitoramento, 
									'tx_descricao_projeto', tb_projeto.tx_descricao_projeto, 
									'ft_descricao_projeto', tb_projeto.ft_descricao_projeto, 
									'cd_abrangencia_projeto', tb_projeto.cd_abrangencia_projeto, 
									'tx_nome_abrangencia_projeto', dc_abrangencia_projeto.tx_nome_abrangencia_projeto, 
									'ft_abrangencia_projeto', tb_projeto.ft_abrangencia_projeto, 
									'cd_zona_atuacao_projeto', tb_projeto.cd_zona_atuacao_projeto, 
									'tx_nome_zona_atuacao', dc_zona_atuacao_projeto.tx_nome_zona_atuacao, 
									'ft_zona_atuacao_projeto', tb_projeto.ft_zona_atuacao_projeto, 
									'cd_municipio', tb_projeto.cd_municipio, 
									'tx_nome_municipio', ed_municipio.edmu_nm_municipio, 
									'ft_municipio', tb_projeto.ft_municipio, 
									'cd_uf', tb_projeto.cd_uf, 
									'tx_nome_uf', ed_uf.eduf_nm_uf, 
									'ft_uf', tb_projeto.ft_uf
								)
							)
						FROM 
							osc.tb_projeto 
						LEFT JOIN 
							syst.dc_status_projeto 
						ON 
							tb_projeto.cd_status_projeto = dc_status_projeto.cd_status_projeto 
						LEFT JOIN 	
							syst.dc_abrangencia_projeto 
						ON 
							tb_projeto.cd_abrangencia_projeto = dc_abrangencia_projeto.cd_abrangencia_projeto 
						LEFT JOIN 	
							syst.dc_zona_atuacao_projeto 
						ON 
							tb_projeto.cd_zona_atuacao_projeto = dc_zona_atuacao_projeto.cd_zona_atuacao_projeto 
						LEFT JOIN 	
							spat.ed_municipio 
						ON 
							tb_projeto.cd_municipio = ed_municipio.edmu_cd_municipio 
						LEFT JOIN 	
							spat.ed_uf 
						ON 
							tb_projeto.cd_uf = ed_uf.eduf_cd_uf 
						WHERE 
							tb_projeto.id_osc::TEXT = param 
						OR 
							tb_osc.tx_apelido_osc = param
					)
				)
			);
			
		ELSIF tipo = 2 THEN 
			resultado := (
				jsonb_build_object(
					'bo_nao_possui_projeto', true, 
					'ft_nao_possui_projeto', tb_osc.ft_nao_possui_projeto, 
					'projetos', (
							SELECT 
								jsonb_agg(
									jsonb_build_object(
										'id_projeto', id_projeto, 
										'tx_nome_projeto', tx_nome_projeto
									)
								)
							FROM 
								osc.tb_projeto 
							WHERE 
								id_osc::TEXT = param 
							OR 
								tx_apelido_osc = param
					)
				)
			);
			
		ELSE 
			RAISE EXCEPTION 'tipo_obter_projeto_invalido';
			
		END IF;
		
	ELSE 
		resultado := jsonb_build_object(
			'bo_nao_possui_projeto', true, 
			'ft_nao_possui_projeto', tb_osc.ft_nao_possui_projeto, 
			'projetos', null
		);
	
	END IF;
	
	flag := false;
	mensagem := 'Projetos retornados.';
	
	RETURN NEXT;

EXCEPTION
	WHEN others THEN 
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;
$$ LANGUAGE 'plpgsql';
