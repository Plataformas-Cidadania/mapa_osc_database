DROP FUNCTION IF EXISTS portal.atualizar_area_atuacao_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER, tipo_busca INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_area_atuacao_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER, tipo_busca INTEGER) RETURNS TABLE(
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
	nome_tabela := 'osc.tb_area_atuacao';
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

	FOR objeto IN (SELECT * FROM jsonb_populate_recordset(null::osc.tb_area_atuacao, json))
	LOOP
		dado_anterior := null;

		IF tipo_busca = 1 THEN
			SELECT INTO dado_anterior *
			FROM osc.tb_area_atuacao
			WHERE id_area_atuacao = objeto.id_area_atuacao
			AND id_osc = osc;

		ELSIF tipo_busca = 2 THEN
			SELECT INTO dado_anterior *
			FROM osc.tb_area_atuacao
			WHERE cd_area_atuacao = objeto.cd_area_atuacao
			AND cd_subarea_atuacao = objeto.cd_subarea_atuacao
			AND id_osc = osc;

		ELSE
			RAISE EXCEPTION 'tipo_busca_invalido';

		END IF;

		IF dado_anterior.id_area_atuacao IS null THEN
			INSERT INTO osc.tb_area_atuacao (
				id_osc,
				cd_area_atuacao,
				cd_subarea_atuacao,
				tx_nome_outra,
				ft_area_atuacao,
				bo_oficial
			) VALUES (
				osc,
				objeto.cd_area_atuacao,
				objeto.cd_subarea_atuacao,
				objeto.tx_nome_outra,
				fonte_dados.nome_fonte,
				objeto.bo_oficial
			) RETURNING * INTO dado_posterior;

			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_area_atuacao);

			PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, null, row_to_json(dado_posterior),id_carga);

		ELSE
			dado_posterior := dado_anterior;
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_area_atuacao);
			flag_update := false;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_area_atuacao::TEXT, dado_anterior.ft_area_atuacao, objeto.cd_area_atuacao::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.cd_area_atuacao := objeto.cd_area_atuacao;
				dado_posterior.ft_area_atuacao := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_subarea_atuacao::TEXT, dado_anterior.ft_area_atuacao, objeto.cd_subarea_atuacao::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.cd_subarea_atuacao := objeto.cd_subarea_atuacao;
				dado_posterior.ft_area_atuacao := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_nome_outra::TEXT, dado_anterior.ft_area_atuacao, objeto.tx_nome_outra::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.tx_nome_outra := objeto.tx_nome_outra;
				dado_posterior.ft_area_atuacao := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.bo_oficial::TEXT, dado_anterior.ft_area_atuacao, objeto.bo_oficial::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.bo_oficial := objeto.bo_oficial;
				flag_update := true;
			END IF;

			IF flag_update THEN
				UPDATE osc.tb_area_atuacao
				SET	cd_area_atuacao = dado_posterior.cd_area_atuacao,
					cd_subarea_atuacao = dado_posterior.cd_subarea_atuacao,
					tx_nome_outra = dado_posterior.tx_nome_outra,
					ft_area_atuacao = dado_posterior.ft_area_atuacao,
					bo_oficial = dado_posterior.bo_oficial
				WHERE id_area_atuacao = dado_posterior.id_area_atuacao;

				PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior),id_carga);
			END IF;

		END IF;

	END LOOP;

	IF delete_valido THEN
		FOR objeto IN (SELECT * FROM osc.tb_area_atuacao WHERE id_osc = osc AND id_area_atuacao != ALL(dado_nao_delete))
		LOOP
			IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_area_atuacao]) AS a) THEN
				DELETE FROM osc.tb_area_atuacao WHERE id_area_atuacao = objeto.id_area_atuacao;
				PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, row_to_json(objeto),null);
			END IF;
		END LOOP;
	END IF;

	flag := true;
	mensagem := 'Área de atuação de OSC atualizado.';

	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, identificador, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
