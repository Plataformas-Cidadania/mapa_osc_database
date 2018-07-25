DROP FUNCTION IF EXISTS portal.atualizar_publico_beneficiado_projeto(TEXT, NUMERIC, TIMESTAMP, JSONB, BOOLEAN, BOOLEAN, BOOLEAN, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_publico_beneficiado_projeto(fonte TEXT, identificador NUMERIC, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER, tipo_busca INTEGER) RETURNS TABLE(
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
	nome_tabela := 'osc.tb_publico_beneficiado_projeto';
	dado_nao_delete := '{}'::INTEGER[];

	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);

	SELECT * INTO osc 
	FROM osc.tb_osc 
	LEFT JOIN osc.tb_projeto 
	ON tb_osc.id_osc = tb_projeto.id_osc 
	WHERE tb_projeto.id_projeto = identificador;

	IF fonte_dados IS null THEN
		RAISE EXCEPTION 'fonte_invalida';
	ELSIF osc IS null THEN
		RAISE EXCEPTION 'osc_nao_encontrada';
	ELSIF osc.bo_osc_ativa IS false THEN
		RAISE EXCEPTION 'osc_inativa';
	ELSIF osc.id_projeto IS null THEN
		RAISE EXCEPTION 'projeto_nao_encontrado';
	ELSIF osc.id_osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	END IF;
	
	IF json IS null THEN
		json := ('[]')::JSONB;
	ELSIF jsonb_typeof(json) = 'object' THEN
		--json := jsonb_build_array(json);
		json := ('{' || (json->>'projetos')::TEXT || '}')::JSONB;
	END IF;

	FOR objeto IN (SELECT * FROM jsonb_to_recordset(json) AS x(id_publico_beneficiado INTEGER, nr_estimativa_pessoas_atendidas INTEGER, tx_nome_publico_beneficiado TEXT))
	LOOP
		dado_anterior := null;

		IF tipo_busca = 1 THEN
			SELECT INTO dado_anterior * FROM osc.tb_publico_beneficiado_projeto
			WHERE id_publico_beneficiado_projeto = objeto.id_publico_beneficiado_projeto
			AND id_projeto = osc.id_projeto;

		ELSIF tipo_busca = 2 THEN
			SELECT INTO dado_anterior * FROM osc.tb_publico_beneficiado_projeto
			WHERE id_publico_beneficiado = objeto.id_publico_beneficiado
			AND id_projeto = osc.id_projeto;

		ELSE
			RAISE EXCEPTION 'tipo_busca_invalido';

		END IF;

		IF dado_anterior.id_publico_beneficiado_projeto IS null THEN
			INSERT INTO osc.tb_publico_beneficiado_projeto (
				id_projeto,
				nr_estimativa_pessoas_atendidas,
				ft_publico_beneficiado_projeto
			) VALUES (
				osc.id_projeto,
				objeto.nr_estimativa_pessoas_atendidas,
				fonte_dados.nome_fonte
			) RETURNING * INTO dado_posterior;

			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_publico_beneficiado_projeto);
			PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, null, row_to_json(dado_posterior), id_carga);

		ELSE
			dado_posterior := dado_anterior;
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_publico_beneficiado_projeto);
			flag_update := false;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_estimativa_pessoas_atendidas::TEXT, dado_anterior.ft_publico_beneficiado_projeto, objeto.nr_estimativa_pessoas_atendidas::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.nr_estimativa_pessoas_atendidas := objeto.nr_estimativa_pessoas_atendidas;
				dado_posterior.ft_publico_beneficiado_projeto := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF flag_update THEN
				UPDATE osc.tb_publico_beneficiado_projeto
				SET nr_estimativa_pessoas_atendidas = dado_posterior.nr_estimativa_pessoas_atendidas,
					ft_publico_beneficiado_projeto = dado_posterior.ft_publico_beneficiado_projeto
				WHERE id_publico_beneficiado_projeto = objeto.id_publico_beneficiado_projeto;

				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior), id_carga);
			END IF;

		END IF;

		IF objeto.tx_nome_publico_beneficiado IS NOT null THEN
			SELECT INTO record_funcao_externa * FROM portal.atualizar_publico_beneficiado_projeto(fonte, dado_posterior.id_conferencia, data_atualizacao, ('{"tx_nome_publico_beneficiado": ' || (objeto.tx_nome_publico_beneficiado)::TEXT || '}'), null_valido, delete_valido, erro_log, id_carga);
			IF record_funcao_externa.flag = false THEN
				mensagem := record_funcao_externa.mensagem;
				RAISE EXCEPTION 'funcao_externa';
			END IF;
		END IF;
	END LOOP;

	IF delete_valido THEN
		FOR objeto IN (SELECT * FROM osc.tb_publico_beneficiado_projeto WHERE id_projeto = osc.id_projeto AND id_publico_beneficiado_projeto != ALL(dado_nao_delete))
		LOOP
			FOR objeto_externo IN (SELECT * FROM osc.tb_publico_beneficiado WHERE id_publico_beneficiado = objeto.id_publico_beneficiado)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto_externo.ft_publico_beneficiado_projeto]) AS a) THEN
					DELETE FROM osc.tb_publico_beneficiado WHERE id_publico_beneficiado = objeto_externo.id_publico_beneficiado AND id_publico_beneficiado != ALL(dado_nao_delete);
					PERFORM portal.inserir_log_atualizacao('osc.tb_publico_beneficiado'::TEXT, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto_externo), null::JSON, id_carga);
				END IF;
			END LOOP;

			IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_publico_beneficiado_projeto]) AS a) THEN
				DELETE FROM osc.tb_publico_beneficiado_projeto WHERE id_publico_beneficiado_projeto = objeto.id_publico_beneficiado_projeto;
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
			IF SQLERRM <> 'funcao_externa' THEN 
				SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, identificador, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
			END IF;
		ELSE
			mensagem := 'Ocorreu um erro.';
		END IF;

		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';



-- Teste
SELECT * FROM portal.atualizar_publico_beneficiado_projeto(
	'Representante de OSC'::TEXT, 
	'87081'::NUMERIC, 
	now()::TIMESTAMP, 
	'[
		{"id_publico_beneficiado": 33, "nr_estimativa_pessoas_atendidas": "100"},
		{"id_publico_beneficiado": 34, "nr_estimativa_pessoas_atendidas": "200"},
		{"id_publico_beneficiado": 35, "nr_estimativa_pessoas_atendidas": "300"}
	]'::JSONB, 
	true::BOOLEAN, 
	true::BOOLEAN, 
	true::BOOLEAN, 
	null::INTEGER, 
	2::INTEGER
);

SELECT * FROM osc.tb_publico_beneficiado_projeto a JOIN osc.tb_projeto b ON a.id_projeto = b.id_projeto WHERE b.id_osc = 1548640;