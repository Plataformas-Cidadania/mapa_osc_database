DROP FUNCTION IF EXISTS portal.obter_osc_projetos(param TEXT, tipo INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_osc_projetos(param TEXT, tipo INTEGER) RETURNS TABLE (
	resultado JSONB,
	mensagem TEXT,
	flag BOOLEAN
) AS $$ 

DECLARE
	bo_nao_possui_projeto BOOLEAN;
	projetos JSON[];

BEGIN 
	SELECT INTO bo_nao_possui_projeto tb_osc.bo_nao_possui_projeto FROM osc.tb_osc WHERE tb_osc.id_osc::TEXT = param OR tb_osc.tx_apelido_osc = param;
	
	IF bo_nao_possui_projeto IS false THEN 
		IF tipo = 1 THEN 
			RAISE NOTICE 'Ponto 1';
			
			SELECT INTO projetos json_agg(json_build_object(
				id_projeto, tx_identificador_projeto_externo, ft_identificador_projeto_externo, tx_nome_projeto, ft_nome_projeto, cd_status_projeto, 
				tx_nome_status_projeto, tx_status_projeto_outro, ft_status_projeto, dt_data_inicio_projeto, ft_data_inicio_projeto, dt_data_fim_projeto, 
				ft_data_fim_projeto, tx_link_projeto, ft_link_projeto, nr_total_beneficiarios, ft_total_beneficiarios, nr_valor_total_projeto, ft_valor_total_projeto, 
				nr_valor_captado_projeto, ft_valor_captado_projeto, tx_metodologia_monitoramento, ft_metodologia_monitoramento, tx_descricao_projeto, ft_descricao_projeto, 
				cd_abrangencia_projeto, tx_nome_abrangencia_projeto, ft_abrangencia_projeto, cd_zona_atuacao_projeto, tx_nome_zona_atuacao, ft_zona_atuacao_projeto, 
				cd_municipio, ft_municipio, cd_uf, ft_uf)) 
			FROM 
				portal.vw_osc_projeto 
			WHERE 
				id_osc::TEXT = param OR 
				tx_apelido_osc = param;
			
			RAISE NOTICE 'Ponto 2';
			
		ELSIF tipo = 2 THEN 
			RAISE NOTICE 'Ponto 3';
			projetos := array_to_json(
				(SELECT 
					id_projeto, tx_identificador_projeto_externo
				FROM 
					portal.vw_osc_projeto 
				WHERE 
					id_osc::TEXT = param OR 
					tx_apelido_osc = param)
			);
			
		ELSE 
			RAISE NOTICE 'Tipo de projeto: Inválido';
			RAISE EXCEPTION 'tipo_obter_projeto_invalido';
			
		END IF;
	END IF;
	
	RAISE NOTICE '%', projetos;
	resultado := projetos;
	flag := false;
	mensagem := 'Projetos retornados.';
	
	RETURN NEXT;

EXCEPTION
	WHEN others THEN 
		RAISE NOTICE '%: %', SQLSTATE, SQLERRM;
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;
$$ LANGUAGE 'plpgsql';
