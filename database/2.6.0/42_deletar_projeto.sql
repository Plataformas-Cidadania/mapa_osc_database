DROP FUNCTION IF EXISTS portal.deletar_projeto(TEXT, NUMERIC, TEXT, TIMESTAMP, INTEGER, BOOLEAN, INTEGER);

CREATE OR REPLACE FUNCTION portal.deletar_projeto(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, id INTEGER, erro_log BOOLEAN, id_carga INTEGER) RETURNS TABLE(
	mensagem TEXT,
	flag BOOLEAN
)AS $$

DECLARE
	nome_tabela TEXT;
	fonte_dados RECORD;
	objeto RECORD;
	osc INTEGER;

BEGIN
	nome_tabela := 'osc.tb_projeto';
	tipo_identificador := lower(tipo_identificador);
	
	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);
	
	IF fonte_dados IS null THEN
		RAISE EXCEPTION 'fonte_invalida';
	ELSIF osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	END IF;
	
	IF tipo_identificador = 'cnpj' THEN
		SELECT id_osc INTO osc FROM osc.tb_osc WHERE cd_identificador_osc = identificador;
	ELSIF tipo_identificador = 'id_osc' THEN
		osc := identificador;
	END IF;
	
	IF tipo_identificador != 'cnpj' AND tipo_identificador != 'id_osc' THEN
		RAISE EXCEPTION 'tipo_identificador_invalido';
	ELSIF osc IS null THEN
		RAISE EXCEPTION 'osc_nao_encontrada';
	END IF;
	
	IF osc <> (SELECT id_osc FROM osc.tb_projeto WHERE id_projeto = id) THEN
		RAISE EXCEPTION 'id_osc_nao_confere';
	END IF;

	objeto := (SELECT * FROM osc.tb_tipo_parceria_projeto WHERE id_projeto = id);
	IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_tipo_parceria_projeto]) AS a) THEN
		DELETE FROM osc.tb_tipo_parceria_projeto WHERE id_projeto = id;
		PERFORM portal.inserir_log_atualizacao('osc.tb_tipo_parceria_projeto', osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
	ELSE
		RAISE EXCEPTION 'prioridade_invalida';
	END IF;
	
	objeto := (SELECT * FROM osc.tb_fonte_recursos_projeto WHERE id_projeto = id);
	IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_fonte_recursos_projeto, objeto.ft_orgao_concedente]) AS a) THEN
		DELETE FROM osc.tb_fonte_recursos_projeto WHERE id_projeto = id;
		PERFORM portal.inserir_log_atualizacao('osc.tb_fonte_recursos_projeto', osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
	ELSE
		RAISE EXCEPTION 'prioridade_invalida';
	END IF;
			
	objeto := (SELECT * FROM osc.tb_area_atuacao_outra_projeto WHERE id_projeto = id);
	IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_area_atuacao_outra_projeto]) AS a) THEN
		DELETE FROM osc.tb_area_atuacao_outra_projeto WHERE id_projeto = id;
		PERFORM portal.inserir_log_atualizacao('osc.tb_area_atuacao_outra_projeto', osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
	ELSE
		RAISE EXCEPTION 'prioridade_invalida';
	END IF;
	
	objeto := (SELECT * FROM osc.tb_area_atuacao_projeto WHERE id_projeto = id);
	IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_area_atuacao_projeto]) AS a) THEN
		DELETE FROM osc.tb_area_atuacao_projeto WHERE id_projeto = id;
		PERFORM portal.inserir_log_atualizacao('osc.tb_area_atuacao_projeto', osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
	ELSE
		RAISE EXCEPTION 'prioridade_invalida';
	END IF;
	
	objeto := (SELECT * FROM osc.tb_financiador_projeto WHERE id_projeto = id);
	IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_nome_financiador]) AS a) THEN
		DELETE FROM osc.tb_financiador_projeto WHERE id_projeto = id;
		PERFORM portal.inserir_log_atualizacao('osc.tb_financiador_projeto', osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
	ELSE
		RAISE EXCEPTION 'prioridade_invalida';
	END IF;
	
	objeto := (SELECT * FROM osc.tb_localizacao_projeto WHERE id_projeto = id);
	IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_regiao_localizacao_projeto, objeto.ft_nome_regiao_localizacao_projeto, objeto.ft_localizacao_prioritaria]) AS a) THEN
		DELETE FROM osc.tb_localizacao_projeto WHERE id_projeto = id;
		PERFORM portal.inserir_log_atualizacao('osc.tb_localizacao_projeto', osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
	ELSE
		RAISE EXCEPTION 'prioridade_invalida';
	END IF;
	
	objeto := (SELECT * FROM osc.tb_objetivo_projeto WHERE id_projeto = id);
	IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_objetivo_projeto]) AS a) THEN
		DELETE FROM osc.tb_objetivo_projeto WHERE id_projeto = id;
		PERFORM portal.inserir_log_atualizacao('osc.tb_objetivo_projeto', osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
	ELSE
		RAISE EXCEPTION 'prioridade_invalida';
	END IF;
	
	objeto := (SELECT * FROM osc.tb_osc_parceira_projeto WHERE id_projeto = id);
	IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_osc_parceira_projeto]) AS a) THEN
		DELETE FROM osc.tb_osc_parceira_projeto WHERE id_projeto = id;
		PERFORM portal.inserir_log_atualizacao('osc.tb_osc_parceira_projeto', osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
	ELSE
		RAISE EXCEPTION 'prioridade_invalida';
	END IF;
	
	objeto := (SELECT * FROM osc.tb_publico_beneficiado_projeto WHERE id_projeto = id);
	IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_publico_beneficiado_projeto]) AS a) THEN
		DELETE FROM osc.tb_publico_beneficiado_projeto WHERE id_projeto = id;
		PERFORM portal.inserir_log_atualizacao('osc.tb_publico_beneficiado_projeto', osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
	ELSE
		RAISE EXCEPTION 'prioridade_invalida';
	END IF;
	
	objeto := (SELECT * FROM osc.tb_publico_beneficiado_projeto WHERE id_projeto = id);
	IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_identificador_projeto_externo, objeto.ft_municipio, objeto.ft_uf, objeto.ft_nome_projeto, objeto.ft_status_projeto, objeto.ft_data_inicio_projeto, objeto.ft_data_fim_projeto, objeto.ft_valor_total_projeto, objeto.ft_valor_captado_projeto, objeto.ft_total_beneficiarios, objeto.ft_abrangencia_projeto, objeto.ft_zona_atuacao_projeto, objeto.ft_descricao_projeto, objeto.ft_metodologia_monitoramento, objeto.ft_link_projeto]) AS a) THEN
		DELETE FROM osc.tb_projeto WHERE id_projeto = id;
		PERFORM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
	ELSE
		RAISE EXCEPTION 'prioridade_invalida';
	END IF;
	
	flag := true;
	mensagem := 'Projeto deletado.';
	
	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, identificador, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
