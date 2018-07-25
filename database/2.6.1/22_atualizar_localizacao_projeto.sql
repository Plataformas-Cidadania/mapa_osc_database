DROP FUNCTION IF EXISTS portal.atualizar_localizacao_projeto(TEXT, NUMERIC, TIMESTAMP, JSONB, BOOLEAN, BOOLEAN, BOOLEAN, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_localizacao_projeto(fonte TEXT, identificador NUMERIC, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER, tipo_busca INTEGER) RETURNS TABLE(
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
	nome_tabela := 'osc.tb_localizacao_projeto';
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
	ELSIF osc.bo_osc_ativa IS false THEN
		RAISE EXCEPTION 'osc_inativa';
	END IF;
	
	IF json IS null THEN
		json := ('[]')::JSONB;
	ELSIF jsonb_typeof(json) = 'object' THEN
		--json := jsonb_build_array(json);
		json := ('{' || (json->>'projetos')::TEXT || '}')::JSONB;
	END IF;

	FOR objeto IN (SELECT * FROM jsonb_populate_recordset(null::osc.tb_localizacao_projeto, json))
	LOOP
		dado_anterior := null;

		IF tipo_busca = 1 THEN
			SELECT INTO dado_anterior * FROM osc.tb_localizacao_projeto
			WHERE id_localizacao_projeto = objeto.id_localizacao_projeto
			AND id_projeto = identificador;

		ELSIF tipo_busca = 2 THEN
			SELECT INTO dado_anterior * FROM osc.tb_localizacao_projeto
			WHERE id_regiao_localizacao_projeto = objeto.id_regiao_localizacao_projeto
			AND id_projeto = identificador;

		ELSE
			RAISE EXCEPTION 'tipo_busca_invalido';

		END IF;

		IF dado_anterior.id_localizacao_projeto IS null THEN
			INSERT INTO osc.tb_localizacao_projeto (
				id_projeto,
				id_regiao_localizacao_projeto,
				ft_regiao_localizacao_projeto,
				tx_nome_regiao_localizacao_projeto,
				ft_nome_regiao_localizacao_projeto,
				bo_localizacao_prioritaria,
				ft_localizacao_prioritaria
			) VALUES (
				osc.id_projeto,
				objeto.id_regiao_localizacao_projeto,
				fonte_dados.nome_fonte,
				objeto.tx_nome_regiao_localizacao_projeto,
				fonte_dados.nome_fonte,
				objeto.bo_localizacao_prioritaria,
				fonte_dados.nome_fonte
			) RETURNING * INTO dado_posterior;

			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_localizacao_projeto);
			PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, null, row_to_json(dado_posterior), id_carga);

		ELSE
			dado_posterior := dado_anterior;
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_localizacao_projeto);
			flag_update := false;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.id_regiao_localizacao_projeto::TEXT, dado_anterior.ft_regiao_localizacao_projeto, objeto.id_regiao_localizacao_projeto::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.id_regiao_localizacao_projeto := objeto.id_regiao_localizacao_projeto;
				dado_posterior.ft_regiao_localizacao_projeto := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_nome_regiao_localizacao_projeto::TEXT, dado_anterior.ft_nome_regiao_localizacao_projeto, objeto.bo_localizacao_prioritaria::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.tx_nome_regiao_localizacao_projeto := objeto.tx_nome_regiao_localizacao_projeto;
				dado_posterior.ft_nome_regiao_localizacao_projeto := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.bo_localizacao_prioritaria::TEXT, dado_anterior.ft_localizacao_prioritaria, objeto.bo_localizacao_prioritaria::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.bo_localizacao_prioritaria := objeto.bo_localizacao_prioritaria;
				dado_posterior.ft_localizacao_prioritaria := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF flag_update THEN
				UPDATE osc.tb_localizacao_projeto
				SET id_regiao_localizacao_projeto = dado_posterior.id_regiao_localizacao_projeto,
					ft_regiao_localizacao_projeto = dado_posterior.ft_regiao_localizacao_projeto,
					tx_nome_regiao_localizacao_projeto = dado_posterior.tx_nome_regiao_localizacao_projeto,
					ft_nome_regiao_localizacao_projeto = dado_posterior.ft_nome_regiao_localizacao_projeto,
					bo_localizacao_prioritaria = dado_posterior.bo_localizacao_prioritaria,
					ft_localizacao_prioritaria = dado_posterior.ft_localizacao_prioritaria
				WHERE id_localizacao_projeto = dado_posterior.id_localizacao_projeto;

				PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior), id_carga);
			END IF;

		END IF;

	END LOOP;

	IF delete_valido THEN
		FOR objeto IN (SELECT * FROM osc.tb_localizacao_projeto WHERE id_projeto = osc.id_projeto AND id_localizacao_projeto != ALL(dado_nao_delete))
		LOOP
			IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_regiao_localizacao_projeto, objeto.ft_nome_regiao_localizacao_projeto, objeto.ft_localizacao_prioritaria]) AS a) THEN
				DELETE FROM osc.tb_localizacao_projeto WHERE id_localizacao_projeto = objeto.id_localizacao_projeto;
				PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
			END IF;
		END LOOP;
	END IF;

	flag := true;
	mensagem := 'Localização de projeto atualizado.';

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
SELECT * FROM portal.atualizar_localizacao_projeto(
	'Representante de OSC'::TEXT, 
	'1'::NUMERIC, 
	now()::TIMESTAMP, 
	'[
		{"id_regiao_localizacao_projeto": 33, "tx_nome_regiao_localizacao_projeto": "Xerém", "bo_localizacao_prioritaria": true},
		{"id_regiao_localizacao_projeto": 34, "tx_nome_regiao_localizacao_projeto": "Xerém", "bo_localizacao_prioritaria": false},
		{"id_regiao_localizacao_projeto": 35, "tx_nome_regiao_localizacao_projeto": "Xerém", "bo_localizacao_prioritaria": false}
	]'::JSONB, 
	true::BOOLEAN, 
	true::BOOLEAN, 
	true::BOOLEAN, 
	null::INTEGER, 
	2::INTEGER
);

SELECT * FROM osc.tb_localizacao_projeto WHERE id_projeto = 1;