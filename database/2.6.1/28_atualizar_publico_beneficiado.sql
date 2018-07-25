DROP FUNCTION IF EXISTS portal.atualizar_publico_beneficiado(TEXT, NUMERIC, TIMESTAMP, JSONB, BOOLEAN, BOOLEAN, BOOLEAN, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_publico_beneficiado(fonte TEXT, identificador NUMERIC, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER, tipo_busca INTEGER) RETURNS TABLE(
	mensagem TEXT,
	flag BOOLEAN
)AS $$

DECLARE
	nome_tabela TEXT;
	fonte_dados RECORD;
	objeto RECORD;
	dado_anterior RECORD;
	dado_posterior RECORD;
	dado_nao_delete INTEGER[];
	flag_update BOOLEAN;
	osc RECORD;

BEGIN
	nome_tabela := 'osc.tb_publico_beneficiado';
	dado_nao_delete := '{}'::INTEGER[];

	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);

	SELECT * INTO osc 
	FROM osc.tb_osc 
	LEFT JOIN osc.tb_projeto 
	ON tb_osc.id_osc = tb_projeto.id_osc 
	LEFT JOIN osc.tb_publico_beneficiado_projeto 
	ON tb_osc.id_publico_beneficiado = tb_publico_beneficiado_projeto.id_publico_beneficiado 
	WHERE tb_projeto.id_publico_beneficiado_projeto = identificador;

	IF fonte_dados IS null THEN
		RAISE EXCEPTION 'fonte_invalida';
	ELSIF osc IS null THEN
		RAISE EXCEPTION 'osc_nao_encontrada';
	ELSIF osc.bo_osc_ativa IS false THEN
		RAISE EXCEPTION 'osc_inativa';
	ELSIF osc.id_projeto IS null THEN
		RAISE EXCEPTION 'projeto_nao_encontrado';
	ELSIF osc.id_publico_beneficiado_projeto IS null THEN
		RAISE EXCEPTION 'publico_beneficiado_nao_encontrado';
	ELSIF osc.id_osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	END IF;
	
	IF json IS null THEN
		json := ('[]')::JSONB;
	ELSIF jsonb_typeof(json) = 'object' THEN
		--json := jsonb_build_array(json);
		json := ('{' || (json->>'projetos')::TEXT || '}')::JSONB;
	END IF;

	FOR objeto IN (SELECT * FROM jsonb_populate_recordset(null::osc.tb_publico_beneficiado, json))
	LOOP
		dado_anterior := null;

		IF tipo_busca = 1 THEN
			SELECT INTO dado_anterior * FROM osc.tb_publico_beneficiado
			WHERE id_publico_beneficiado = objeto.id_publico_beneficiado
			AND id_publico_beneficiado_projeto = osc.id_publico_beneficiado_projeto;

		ELSIF tipo_busca = 2 THEN
			SELECT INTO dado_anterior * FROM osc.tb_publico_beneficiado
			WHERE id_publico_beneficiado_projeto = objeto.id_publico_beneficiado_projeto
			AND id_publico_beneficiado_projeto = osc.id_publico_beneficiado_projeto;

		ELSE
			RAISE EXCEPTION 'tipo_busca_invalido';

		END IF;

		IF dado_anterior.id_publico_beneficiado IS null THEN
			INSERT INTO osc.tb_publico_beneficiado (
				id_publico_beneficiado_projeto,
				tx_nome_publico_beneficiado,
				ft_publico_beneficiado
			) VALUES (
				public.id_publico_beneficiado_projeto
				objeto.tx_nome_publico_beneficiado,
				fonte_dados.nome_fonte
			) RETURNING * INTO dado_posterior;

			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_publico_beneficiado);
			PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, null, row_to_json(dado_posterior), id_carga);

		ELSE
			dado_posterior := dado_anterior;
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_publico_beneficiado);
			flag_update := false;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_nome_publico_beneficiado::TEXT, dado_anterior.ft_publico_beneficiado, objeto.tx_nome_publico_beneficiado::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.tx_nome_publico_beneficiado := objeto.tx_nome_publico_beneficiado;
				dado_posterior.ft_publico_beneficiado := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF flag_update THEN
				UPDATE osc.tb_publico_beneficiado
				SET tx_nome_publico_beneficiado = dado_posterior.tx_nome_publico_beneficiado,
					ft_publico_beneficiado = dado_posterior.ft_publico_beneficiado
				WHERE id_publico_beneficiado = objeto.id_publico_beneficiado;

				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior), id_carga);
			END IF;

		END IF;

	END LOOP;

	IF delete_valido THEN
		FOR objeto IN (SELECT * FROM osc.tb_publico_beneficiado WHERE id_publico_beneficiado = osc.id_projeto AND id_publico_beneficiado != ALL(dado_nao_delete))
		LOOP
			IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_publico_beneficiado]) AS a) THEN
				DELETE FROM osc.tb_publico_beneficiado WHERE id_publico_beneficiado = objeto.id_publico_beneficiado;
				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
			END IF;
		END LOOP;
	END IF;

	flag := true;
	mensagem := 'Público beneficiado de projeto atualizado.';

	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '%', SQLERRM;
		flag := false;
		
		IF osc IS NOT null THEN
			SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, osc.id_osc, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		ELSE
			mensagem := 'Ocorreu um erro.';
		END IF;

		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';



-- Teste
SELECT * FROM portal.atualizar_publico_beneficiado(
	'Representante de OSC'::TEXT, 
	'87081'::NUMERIC, 
	now()::TIMESTAMP, 
	'[
		{"tx_nome_publico_beneficiado": "Teste 1"},
		{"tx_nome_publico_beneficiado": "Teste 2"},
		{"tx_nome_publico_beneficiado": "Teste 3"}
	]'::JSONB, 
	true::BOOLEAN, 
	true::BOOLEAN, 
	true::BOOLEAN, 
	null::INTEGER, 
	2::INTEGER
);

SELECT * FROM osc.atualizar_publico_beneficiado a JOIN osc.tb_projeto b ON a.id_projeto = b.id_projeto WHERE b.id_osc = 1548640;