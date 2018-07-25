DROP FUNCTION IF EXISTS portal.atualizar_tipo_parceria_projeto(TEXT, NUMERIC, TIMESTAMP, JSONB, BOOLEAN, BOOLEAN, BOOLEAN, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_tipo_parceria_projeto(fonte TEXT, identificador NUMERIC, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER, tipo_busca INTEGER) RETURNS TABLE(
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
	nome_tabela := 'osc.tb_tipo_parceria_projeto';
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
		json := jsonb_build_array(json);
		--json := ('{' || (json->>'projetos')::TEXT || '}')::JSONB;
	END IF;

	FOR objeto IN (SELECT * FROM jsonb_populate_recordset(null::osc.tb_tipo_parceria_projeto, json))
	LOOP
		dado_anterior := null;

		IF tipo_busca = 1 THEN
			SELECT INTO dado_anterior * FROM osc.tb_tipo_parceria_projeto
			WHERE id_tipo_parceria_projeto = objeto.id_tipo_parceria_projeto
			AND id_projeto = osc.id_projeto;

		ELSIF tipo_busca = 2 THEN
			SELECT INTO dado_anterior * FROM osc.tb_tipo_parceria_projeto
			WHERE cd_origem_fonte_recursos_projeto = objeto.cd_origem_fonte_recursos_projeto
			AND cd_tipo_parceria_projeto = objeto.cd_tipo_parceria_projeto
			AND id_projeto = osc.id_projeto;

		ELSE
			RAISE EXCEPTION 'tipo_busca_invalido';

		END IF;

		IF dado_anterior.id_tipo_parceria_projeto IS null THEN
			INSERT INTO osc.tb_tipo_parceria_projeto (
				id_projeto,
				cd_origem_fonte_recursos_projeto,
				cd_tipo_parceria_projeto,
				ft_tipo_parceria_projeto
			) VALUES (
				osc.id_projeto,
				objeto.cd_origem_fonte_recursos_projeto,
				objeto.cd_tipo_parceria_projeto,
				fonte_dados.nome_fonte
			) RETURNING * INTO dado_posterior;
			
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_tipo_parceria_projeto);
			PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, null, row_to_json(dado_posterior), id_carga);

		ELSE
			dado_posterior := dado_anterior;
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_tipo_parceria_projeto);
			flag_update := false;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_origem_fonte_recursos_projeto::TEXT, dado_anterior.ft_tipo_parceria_projeto, objeto.cd_origem_fonte_recursos_projeto::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.cd_origem_fonte_recursos_projeto := objeto.cd_origem_fonte_recursos_projeto;
				dado_posterior.ft_tipo_parceria_projeto := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_tipo_parceria_projeto::TEXT, dado_anterior.ft_tipo_parceria_projeto, objeto.cd_tipo_parceria_projeto::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.cd_tipo_parceria_projeto := objeto.cd_tipo_parceria_projeto;
				dado_posterior.ft_tipo_parceria_projeto := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF flag_update THEN
				UPDATE osc.tb_tipo_parceria_projeto
				SET cd_origem_fonte_recursos_projeto = dado_posterior.cd_origem_fonte_recursos_projeto,
					cd_tipo_parceria_projeto = dado_posterior.cd_tipo_parceria_projeto,
					ft_tipo_parceria_projeto = dado_posterior.ft_tipo_parceria_projeto
				WHERE id_tipo_parceria_projeto = objeto.id_tipo_parceria_projeto;

				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior), id_carga);
			END IF;

		END IF;

	END LOOP;

	IF delete_valido THEN
		FOR objeto IN (SELECT * FROM osc.tb_tipo_parceria_projeto WHERE id_projeto = osc.id_projeto AND id_tipo_parceria_projeto != ALL(dado_nao_delete))
		LOOP
			IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_tipo_parceria_projeto]) AS a) THEN
				DELETE FROM osc.tb_tipo_parceria_projeto WHERE id_tipo_parceria_projeto = objeto.id_tipo_parceria_projeto;
				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto), null, id_carga);
			END IF;
		END LOOP;
	END IF;

	flag := true;
	mensagem := 'Tipo(s) de parceria(s) de projeto atualizado.';

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
SELECT * FROM portal.atualizar_tipo_parceria_projeto(
	'Representante de OSC'::TEXT, 
	'87081'::NUMERIC, 
	now()::TIMESTAMP, 
	'[
		{"cd_origem_fonte_recursos_projeto": 1, "cd_tipo_parceria_projeto": "1"},
		{"cd_origem_fonte_recursos_projeto": 1, "cd_tipo_parceria_projeto": "2"},
		{"cd_origem_fonte_recursos_projeto": 1, "cd_tipo_parceria_projeto": "3"}
	]'::JSONB, 
	true::BOOLEAN, 
	true::BOOLEAN, 
	true::BOOLEAN, 
	null::INTEGER, 
	2::INTEGER
);

--SELECT * FROM osc.tb_tipo_parceria_projeto a JOIN osc.tb_projeto b ON a.id_projeto = b.id_projeto WHERE b.id_osc = 1548640;