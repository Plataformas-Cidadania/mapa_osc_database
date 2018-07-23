DROP FUNCTION IF EXISTS portal.atualizar_objetivos_osc(TEXT, NUMERIC, TEXT, TIMESTAMP, JSONB, BOOLEAN, BOOLEAN, BOOLEAN, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_objetivos_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER, tipo_busca INTEGER) RETURNS TABLE(
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
	nome_tabela := 'osc.tb_objetivo_osc';
	tipo_identificador := lower(tipo_identificador);

	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);

	IF fonte_dados IS null THEN
		RAISE EXCEPTION 'fonte_invalida';
	END IF;

	IF tipo_identificador = 'cnpj' THEN
		SELECT * INTO osc FROM osc.tb_osc WHERE cd_identificador_osc = identificador;
	ELSIF tipo_identificador = 'id_osc' THEN
		SELECT * INTO osc FROM osc.tb_osc WHERE id_osc = identificador;
	ELSE
		RAISE EXCEPTION 'tipo_identificador_invalido';
	END IF;

	IF osc IS null THEN
		RAISE EXCEPTION 'osc_nao_encontrada';
	ELSIF osc.id_osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	END IF;
	
	IF jsonb_typeof(json) = 'object' THEN
		json := jsonb_build_array(json);
	END IF;
	
	FOR objeto IN (SELECT * FROM jsonb_populate_recordset(null::osc.tb_objetivo_osc, json))
	LOOP
		dado_anterior := null;

		IF tipo_busca = 1 THEN
			SELECT INTO dado_anterior *
			FROM osc.tb_objetivo_osc
			WHERE id_objetivo_osc = objeto.id_objetivo_osc;

		ELSIF tipo_busca = 2 THEN
			SELECT INTO dado_anterior *
			FROM osc.tb_objetivo_osc
			WHERE cd_meta_osc = objeto.cd_meta_osc
			AND id_osc = osc.id_osc;

		ELSE
			RAISE EXCEPTION 'tipo_busca_invalido';

		END IF;

		IF dado_anterior.id_objetivo_osc IS null THEN
			INSERT INTO osc.tb_objetivo_osc (
				id_osc,
				cd_meta_osc,
				ft_objetivo_osc
			) VALUES (
				osc.id_osc,
				objeto.cd_meta_osc,
				fonte_dados.nome_fonte
			) RETURNING * INTO dado_posterior;

			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_objetivo_osc);

			PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, null::JSON, row_to_json(dado_posterior), id_carga);

		ELSE
			dado_posterior := dado_anterior;
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_objetivo_osc);
			flag_update := false;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_meta_osc::TEXT, dado_anterior.ft_objetivo_osc, objeto.cd_meta_osc::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
				dado_posterior.cd_meta_osc := objeto.cd_meta_osc;
				dado_posterior.ft_objetivo_osc := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF flag_update THEN
				UPDATE osc.tb_objetivo_osc
				SET	cd_meta_osc = dado_posterior.cd_meta_osc,
					ft_objetivo_osc = dado_posterior.ft_objetivo_osc
				WHERE id_objetivo_osc = dado_posterior.id_objetivo_osc;

				PERFORM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior), id_carga);
			END IF;

		END IF;

	END LOOP;

	IF delete_valido THEN
		FOR objeto IN (SELECT * FROM osc.tb_objetivo_osc WHERE id_osc = osc.id_osc)
		LOOP
			IF (objeto.id_objetivo_osc != ALL(dado_nao_delete)) OR (dado_nao_delete IS null) THEN
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_objetivo_osc]) AS a) THEN
					DELETE FROM osc.tb_objetivo_osc WHERE id_objetivo_osc = objeto.id_objetivo_osc;
					PERFORM portal.inserir_log_atualizacao(nome_tabela, osc.id_osc, fonte, data_atualizacao, row_to_json(objeto), null::JSON, id_carga);
				END IF;
			END IF;
		END LOOP;
	END IF;
	
	flag := true;
	mensagem := 'Objetivos de OSC atualizado.';

	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, identificador, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';



-- Teste
SELECT * FROM portal.atualizar_objetivos_osc(
	'Representante de OSC'::TEXT, 
	'789809'::NUMERIC, 
	'id_osc'::TEXT, 
	now()::TIMESTAMP, 
	'[
		{"cd_meta_osc": 1},
		{"cd_meta_osc": 2},
		{"cd_meta_osc": 3}
	]'::JSONB, 
	true::BOOLEAN, 
	true::BOOLEAN, 
	true::BOOLEAN, 
	null::INTEGER, 
	2::INTEGER
);

SELECT * FROM osc.tb_objetivo_osc WHERE id_osc = 789809;