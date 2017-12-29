DROP FUNCTION IF EXISTS portal.atualizar_certificado_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER, tipo_busca INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_certificado_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER, tipo_busca INTEGER) RETURNS TABLE(
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
	osc INTEGER;

BEGIN
	nome_tabela := 'osc.tb_certificado';
	tipo_identificador := lower(tipo_identificador);

	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);

	IF fonte_dados IS null THEN
		RAISE EXCEPTION 'fonte_invalida';
	END IF;

	IF tipo_identificador = 'cnpj' THEN
		SELECT id_osc INTO osc FROM osc.tb_osc WHERE cd_identificador_osc = identificador;
	ELSIF tipo_identificador = 'id_osc' THEN
		SELECT id_osc INTO osc FROM osc.tb_osc WHERE id_osc = identificador;
	ELSE
		RAISE EXCEPTION 'tipo_identificador_invalido';
	END IF;

	IF osc IS null THEN
		RAISE EXCEPTION 'osc_nao_encontrada';
	ELSIF osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	END IF;

	IF jsonb_typeof(json) = 'object' THEN
		json := jsonb_build_array(json);
	END IF;

	FOR objeto IN (SELECT * FROM jsonb_populate_recordset(null::osc.tb_certificado, json))
	LOOP
		dado_anterior := null;

		IF tipo_busca = 1 THEN
			SELECT INTO dado_anterior *
			FROM osc.tb_certificado
			WHERE id_certificado = objeto.id_certificado;

		ELSIF tipo_busca = 2 THEN
			SELECT INTO dado_anterior *
			FROM osc.tb_certificado
			WHERE cd_certificado = objeto.cd_certificado
			AND id_osc = osc;

		ELSE
			RAISE EXCEPTION 'tipo_busca_invalido';

		END IF;

		IF dado_anterior.id_certificado IS null THEN
			INSERT INTO osc.tb_certificado (
				id_osc,
				cd_certificado,
				ft_certificado,
				dt_inicio_certificado,
				ft_inicio_certificado,
				dt_fim_certificado,
				ft_fim_certificado
			) VALUES (
				osc,
				objeto.cd_certificado,
				fonte_dados.nome_fonte,
				objeto.dt_inicio_certificado,
				fonte_dados.nome_fonte,
				objeto.dt_fim_certificado,
				fonte_dados.nome_fonte
			) RETURNING * INTO dado_posterior;

			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_certificado);

			PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, null, row_to_json(dado_posterior),id_carga);

		ELSE
			dado_posterior := dado_anterior;
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_certificado);
			flag_update := false;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_certificado::TEXT, dado_anterior.ft_certificado, objeto.cd_certificado::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
				dado_posterior.cd_certificado := objeto.cd_certificado;
				dado_posterior.ft_certificado := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_inicio_certificado::TEXT, dado_anterior.ft_certificado, objeto.dt_inicio_certificado::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
				dado_posterior.dt_inicio_certificado := objeto.dt_inicio_certificado;
				dado_posterior.ft_inicio_certificado := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_fim_certificado::TEXT, dado_anterior.ft_certificado, objeto.dt_fim_certificado::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
				dado_posterior.dt_fim_certificado := objeto.dt_fim_certificado;
				dado_posterior.ft_fim_certificado := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF flag_update THEN
				UPDATE osc.tb_certificado
				SET	cd_certificado = dado_posterior.cd_certificado,
					ft_certificado = dado_posterior.ft_certificado,
					dt_inicio_certificado = dado_posterior.dt_inicio_certificado,
					ft_inicio_certificado = dado_posterior.ft_inicio_certificado,
					dt_fim_certificado = dado_posterior.dt_fim_certificado,
					ft_fim_certificado = dado_posterior.ft_fim_certificado
				WHERE id_certificado = dado_posterior.id_certificado;

				PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior),id_carga);
			END IF;

		END IF;

	END LOOP;

	IF delete_valido THEN
		DELETE FROM osc.tb_certificado WHERE id_certificado != ALL(dado_nao_delete);
	END IF;

	IF delete_valido THEN
		FOR objeto IN (SELECT * FROM osc.tb_certificado WHERE id_osc = osc AND id_certificado != ALL(dado_nao_delete))
		LOOP
			IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_area_atuacao]) AS a) THEN
				DELETE FROM osc.tb_certificado WHERE id_certificado = objeto.id_certificado;
				PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, row_to_json(objeto), null);
			END IF;
		END LOOP;
	END IF;

	flag := true;
	mensagem := 'Certificado de OSC atualizado.';

	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, identificador, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
