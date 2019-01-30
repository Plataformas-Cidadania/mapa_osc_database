DROP FUNCTION IF EXISTS portal.obter_osc_projetos(TEXT, TEXT, INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_osc_projetos(identificador TEXT, tipo_identificador TEXT, tipo INTEGER) RETURNS TABLE (
	resultado JSON,
	mensagem TEXT,
	flag BOOLEAN
) AS $$

DECLARE
	osc RECORD;
	id_osc_req INTEGER;
	id_projeto_req INTEGER;

BEGIN
	IF tipo_identificador = 'id_osc' THEN
		SELECT INTO osc * FROM osc.tb_osc WHERE id_osc::TEXT = identificador OR tx_apelido_osc = identificador;
		id_osc_req := identificador;

	ELSIF tipo_identificador = 'id_projeto' THEN
		SELECT INTO osc * FROM osc.tb_osc LEFT JOIN osc.tb_projeto ON tb_osc.id_osc = tb_projeto.id_osc WHERE tb_projeto.id_projeto::TEXT = identificador;
		id_projeto_req := identificador;

	ELSE
		RAISE EXCEPTION 'tipo_busca_invalido';

	END IF;

	IF osc IS null THEN
		RAISE EXCEPTION 'osc_nao_encontrada';
	ELSIF osc.bo_osc_ativa IS false THEN
		RAISE EXCEPTION 'osc_inativa';
	END IF;

	IF osc.bo_nao_possui_projeto IS NOT true THEN
		IF tipo = 1 THEN
			resultado := (
				SELECT row_to_json(a)
				FROM (
					SELECT
						osc.bo_nao_possui_projeto AS bo_nao_possui_projeto,
						osc.ft_nao_possui_projeto AS ft_nao_possui_projeto,
						(
							SELECT array_to_json(array_agg(row_to_json(a)))
							FROM (
								SELECT
									tb_projeto.id_projeto AS id_projeto,
									tb_projeto.tx_identificador_projeto_externo AS tx_identificador_projeto_externo,
									tb_projeto.ft_identificador_projeto_externo AS ft_identificador_projeto_externo,
									tb_projeto.tx_nome_projeto AS tx_nome_projeto,
									tb_projeto.ft_nome_projeto AS ft_nome_projeto,
									tb_projeto.cd_status_projeto AS cd_status_projeto,
									dc_status_projeto.tx_nome_status_projeto AS tx_nome_status_projeto,
									tb_projeto.tx_status_projeto_outro AS tx_status_projeto_outro,
									tb_projeto.ft_status_projeto AS ft_status_projeto,
									TO_CHAR(tb_projeto.dt_data_inicio_projeto, 'DD-MM-YYYY') AS dt_data_inicio_projeto,
									tb_projeto.ft_data_inicio_projeto AS ft_data_inicio_projeto,
									TO_CHAR(tb_projeto.dt_data_fim_projeto, 'DD-MM-YYYY') AS dt_data_fim_projeto,
									tb_projeto.ft_data_fim_projeto AS ft_data_fim_projeto,
									tb_projeto.tx_link_projeto AS tx_link_projeto,
									tb_projeto.ft_link_projeto AS ft_link_projeto,
									tb_projeto.nr_total_beneficiarios AS nr_total_beneficiarios,
									tb_projeto.ft_total_beneficiarios AS ft_total_beneficiarios,
									TRIM(TO_CHAR(tb_projeto.nr_valor_total_projeto, '99999999999999999999D99')) AS nr_valor_total_projeto,
									tb_projeto.ft_valor_total_projeto AS ft_valor_total_projeto,
									TRIM(TO_CHAR(tb_projeto.nr_valor_captado_projeto, '99999999999999999999D99')) AS nr_valor_captado_projeto,
									tb_projeto.ft_valor_captado_projeto AS ft_valor_captado_projeto,
									tb_projeto.tx_metodologia_monitoramento AS tx_metodologia_monitoramento,
									tb_projeto.ft_metodologia_monitoramento AS ft_metodologia_monitoramento,
									tb_projeto.tx_descricao_projeto AS tx_descricao_projeto,
									tb_projeto.ft_descricao_projeto AS ft_descricao_projeto,
									tb_projeto.cd_abrangencia_projeto AS cd_abrangencia_projeto,
									dc_abrangencia_projeto.tx_nome_abrangencia_projeto AS tx_nome_abrangencia_projeto,
									tb_projeto.ft_abrangencia_projeto AS ft_abrangencia_projeto,
									tb_projeto.cd_zona_atuacao_projeto AS cd_zona_atuacao_projeto,
									dc_zona_atuacao_projeto.tx_nome_zona_atuacao AS tx_nome_zona_atuacao,
									tb_projeto.ft_zona_atuacao_projeto AS ft_zona_atuacao_projeto,
									tb_projeto.cd_municipio AS cd_municipio,
									ed_municipio.edmu_nm_municipio AS edmu_nm_municipio,
									tb_projeto.ft_municipio AS ft_municipio,
									tb_projeto.cd_uf AS cd_uf,
									ed_uf.eduf_nm_uf AS eduf_nm_uf,
									tb_projeto.ft_uf AS ft_uf,
									(
										COALESCE(
											(
												SELECT array_to_json(array_agg(row_to_json(a)))
												FROM (
													SELECT
														tb_fonte_recursos_projeto.id_fonte_recursos_projeto AS id_fonte_recursos_projeto,
														tb_fonte_recursos_projeto.cd_origem_fonte_recursos_projeto AS cd_origem_fonte_recursos_projeto,
														dc_origem_fonte_recursos_projeto.tx_nome_origem_fonte_recursos_projeto AS tx_nome_origem_fonte_recursos_projeto,
														tb_fonte_recursos_projeto.ft_fonte_recursos_projeto AS ft_fonte_recursos_projeto
													FROM
														osc.tb_fonte_recursos_projeto
													LEFT JOIN
														syst.dc_origem_fonte_recursos_projeto
													ON
														tb_fonte_recursos_projeto.cd_origem_fonte_recursos_projeto = dc_origem_fonte_recursos_projeto.cd_origem_fonte_recursos_projeto
													WHERE
														tb_fonte_recursos_projeto.id_projeto = tb_projeto.id_projeto
												) AS a
											), '[]'
										)
									) AS fonte_recursos,
									(
										COALESCE(
											(
												SELECT array_to_json(array_agg(row_to_json(a)))
												FROM (
													SELECT
														tb_tipo_parceria_projeto.id_tipo_parceria_projeto AS id_tipo_parceria_projeto,
														tb_tipo_parceria_projeto.cd_tipo_parceria_projeto AS cd_tipo_parceria_projeto,
														dc_tipo_parceria.tx_nome_tipo_parceria AS tx_nome_tipo_parceria,
														tb_tipo_parceria_projeto.ft_tipo_parceria_projeto AS ft_tipo_parceria_projeto
													FROM
														osc.tb_tipo_parceria_projeto
													LEFT JOIN
														syst.dc_tipo_parceria
													ON
														tb_tipo_parceria_projeto.cd_tipo_parceria_projeto = dc_tipo_parceria.cd_tipo_parceria
													WHERE
														tb_tipo_parceria_projeto.id_projeto = tb_projeto.id_projeto
												) AS a
											), '[]'
										)
									) AS tipo_parceria,
									(
										COALESCE(
											(
												SELECT array_to_json(array_agg(row_to_json(a)))
												FROM (
													SELECT
														id_publico_beneficiado_projeto AS id_publico_beneficiado,
														tx_nome_publico_beneficiado AS tx_nome_publico_beneficiado,
														ft_nome_publico_beneficiado AS ft_publico_beneficiado_projeto,
														nr_estimativa_pessoas_atendidas AS nr_estimativa_pessoas_atendidas,
														ft_estimativa_pessoas_atendidas AS ft_estimativa_pessoas_atendidas
													FROM
														osc.tb_publico_beneficiado_projeto
													WHERE
														id_projeto = tb_projeto.id_projeto
												) AS a
											), '[]'
										)
									) AS publico_beneficiado,
									(
										COALESCE(
											(
												SELECT array_to_json(array_agg(row_to_json(a)))
												FROM (
													SELECT
														id_financiador_projeto AS id_fonte_recursos_projeto,
														tx_nome_financiador AS tx_nome_financiador,
														ft_nome_financiador AS ft_nome_financiador
													FROM
														osc.tb_financiador_projeto
													WHERE
														tb_financiador_projeto.id_projeto = tb_projeto.id_projeto
												) AS a
											), '[]'
										)
									) AS financiador_projeto,
									(
										COALESCE(
											(
												SELECT array_to_json(array_agg(row_to_json(a)))
												FROM (
													SELECT
														id_localizacao_projeto AS id_localizacao_projeto,
														tx_nome_regiao_localizacao_projeto AS tx_nome_regiao_localizacao_projeto,
														ft_nome_regiao_localizacao_projeto AS ft_nome_regiao_localizacao_projeto,
														bo_localizacao_prioritaria AS bo_localizacao_prioritaria,
														ft_localizacao_prioritaria AS ft_localizacao_prioritaria,
														id_regiao_localizacao_projeto AS id_regiao_localizacao_projeto
													FROM
														osc.tb_localizacao_projeto
													WHERE
														tb_localizacao_projeto.id_projeto = tb_projeto.id_projeto
												) AS a
											), '[]'
										)
									) AS localizacao,
									(
										COALESCE(
											(
												SELECT array_to_json(array_agg(row_to_json(a)))
												FROM (
													SELECT
														tb_osc_parceira_projeto.id_osc AS id_osc,
														COALESCE(tb_dados_gerais.tx_nome_fantasia_osc, tb_dados_gerais.tx_razao_social_osc) AS  tx_nome_osc_parceira_projeto, 
														tb_osc_parceira_projeto.ft_osc_parceira_projeto AS ft_osc_parceira_projeto
													FROM
														osc.tb_osc_parceira_projeto
													LEFT JOIN
														osc.tb_dados_gerais
													ON
														tb_osc_parceira_projeto.id_osc = tb_dados_gerais.id_osc
													WHERE
														tb_osc_parceira_projeto.id_projeto = tb_projeto.id_projeto
												) AS a
											), '[]'
										)
									) AS osc_parceira,
									(
										COALESCE(
											(
												SELECT array_to_json(array_agg(row_to_json(a)))
												FROM (
													SELECT
														tb_objetivo_projeto.id_objetivo_projeto AS id_objetivo_projeto,
														dc_meta_projeto.cd_objetivo_projeto AS cd_objetivo_projeto,
														(dc_objetivo_projeto.tx_codigo_objetivo_projeto || '. ' || dc_objetivo_projeto.tx_nome_objetivo_projeto) AS tx_nome_objetivo_projeto,
														tb_objetivo_projeto.cd_meta_projeto AS cd_meta_projeto,
														(dc_meta_projeto.tx_codigo_meta_projeto || '. ' || dc_meta_projeto.tx_nome_meta_projeto) AS tx_nome_meta_projeto,
														tb_objetivo_projeto.ft_objetivo_projeto AS ft_objetivo_projeto
													FROM
														osc.tb_objetivo_projeto
													LEFT JOIN
														syst.dc_meta_projeto
													ON
														tb_objetivo_projeto.cd_meta_projeto = dc_meta_projeto.cd_meta_projeto
													LEFT JOIN
														syst.dc_objetivo_projeto
													ON
														dc_meta_projeto.cd_objetivo_projeto = dc_objetivo_projeto.cd_objetivo_projeto
													WHERE
														tb_objetivo_projeto.id_projeto = tb_projeto.id_projeto
												) AS a
											), '[]'
										)
									) AS objetivo_meta
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
									tb_projeto.id_osc = id_osc_req
								OR
									tb_projeto.id_projeto = id_projeto_req
							) AS a
						) AS projetos,
						(
							SELECT row_to_json(a)
							FROM (
								SELECT 
									TRIM(TO_CHAR(SUM(tb_projeto.nr_valor_total_projeto), '99999999999999999999D99')) AS nr_valor_total
								FROM 
									osc.tb_projeto 
								WHERE
									tb_projeto.id_osc = id_osc_req
								OR
									tb_projeto.id_projeto = id_projeto_req
							) AS a
						) AS recursos
				) AS a
			);

		ELSIF tipo = 2 THEN
			resultado := (
				SELECT row_to_json(a)
				FROM (
					SELECT
						true AS bo_nao_possui_projeto,
						osc.ft_nao_possui_projeto AS ft_nao_possui_projeto,
						(
							SELECT array_to_json(array_agg(row_to_json(a)))
							FROM (
								SELECT
									tb_projeto.id_projeto as id_projeto,
									tb_projeto.tx_nome_projeto AS tx_nome_projeto
								FROM
									osc.tb_projeto
								WHERE
									tb_projeto.id_osc = id_osc_req
								OR
									tb_projeto.id_projeto = id_projeto_req
							) AS a
						) AS projetos
				) AS a
			);

		ELSE
			RAISE EXCEPTION 'tipo_obter_projeto_invalido';

		END IF;

	ELSE
		resultado := (
			SELECT row_to_json(a)
			FROM (
				SELECT
					true AS bo_nao_possui_projeto,
					osc.ft_nao_possui_projeto AS ft_nao_possui_projeto,
					null AS projetos
			) AS a
		);

	END IF;

	IF tipo_identificador = 'id_projeto' THEN
		resultado := ((resultado->>'projetos')::JSONB)->(0);
	END IF;

	flag := true;
	mensagem := 'Projeto(s) retornado(s).';

	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;
$$ LANGUAGE 'plpgsql';
