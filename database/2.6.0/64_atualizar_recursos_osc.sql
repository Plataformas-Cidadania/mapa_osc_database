DROP FUNCTION IF EXISTS portal.atualizar_recursos_osc(TEXT, NUMERIC, TEXT, TIMESTAMP, JSONB, BOOLEAN, BOOLEAN, BOOLEAN, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_recursos_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER, tipo_busca INTEGER) RETURNS TABLE(
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
	ano DATE;
	nao_possui BOOLEAN;

BEGIN
	nome_tabela := 'osc.atualizar_recursos_osc';

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

	IF (json->>'dt_ano_recursos_osc') IS null THEN
		json := json->>'recursos';
	ELSE
		ano := (json->>'dt_ano_recursos_osc')::DATE;
		
		IF (json->>'bo_nao_possui')::BOOLEAN IS true THEN
			json := '[{"bo_nao_possui": true}]';
			dado_nao_delete := '{}';
		ELSE
			json := json->>'recursos';
		END IF;
	END IF;

	FOR objeto IN (SELECT *FROM jsonb_populate_recordset(null::osc.tb_recursos_osc, json))
	LOOP
		IF ano IS NOT null THEN
			objeto.dt_ano_recursos_osc = ano;
		END IF;

		IF objeto.bo_nao_possui IS NOT true THEN
			objeto.bo_nao_possui = false;
		END IF;
		
		dado_anterior := null;

		IF tipo_busca = 1 THEN
			SELECT INTO dado_anterior * FROM osc.tb_recursos_osc
			WHERE id_recursos_osc = objeto.id_recursos_osc
			AND id_osc = identificador;

		ELSIF tipo_busca = 2 THEN
			SELECT INTO dado_anterior * FROM osc.tb_recursos_osc
			WHERE (
				(
					cd_fonte_recursos_osc = objeto.cd_fonte_recursos_osc
					OR cd_origem_fonte_recursos_osc = objeto.cd_origem_fonte_recursos_osc
				)
				AND dt_ano_recursos_osc = objeto.dt_ano_recursos_osc
			)
			AND id_osc = identificador;

		ELSE
			RAISE EXCEPTION 'tipo_busca_invalido';

		END IF;

		IF objeto.cd_fonte_recursos_osc IS NOT null THEN
			objeto.cd_origem_fonte_recursos_osc := null;
		END IF;

		IF dado_anterior.id_recursos_osc IS null THEN
			INSERT INTO osc.tb_recursos_osc (
				id_osc,
				cd_origem_fonte_recursos_osc,
				cd_fonte_recursos_osc,
				ft_fonte_recursos_osc,
				dt_ano_recursos_osc,
				ft_ano_recursos_osc,
				nr_valor_recursos_osc,
				ft_valor_recursos_osc,
				bo_nao_possui,
				ft_nao_possui
			) VALUES (
				identificador,
				objeto.cd_origem_fonte_recursos_osc,
				objeto.cd_fonte_recursos_osc,
				fonte_dados.nome_fonte,
				objeto.dt_ano_recursos_osc,
				fonte_dados.nome_fonte,
				objeto.nr_valor_recursos_osc,
				fonte_dados.nome_fonte,
				objeto.bo_nao_possui,
				fonte_dados.nome_fonte
			) RETURNING * INTO dado_posterior;

			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_recursos_osc);
			PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, null, row_to_json(dado_posterior),id_carga);

		ELSE
			dado_posterior := dado_anterior;
			dado_nao_delete := array_append(dado_nao_delete, dado_posterior.id_recursos_osc);
			flag_update := false;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_origem_fonte_recursos_osc::TEXT, dado_anterior.ft_fonte_recursos_osc, objeto.cd_origem_fonte_recursos_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.cd_origem_fonte_recursos_osc := objeto.cd_origem_fonte_recursos_osc;
				dado_posterior.ft_fonte_recursos_osc := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_fonte_recursos_osc::TEXT, dado_anterior.ft_fonte_recursos_osc, objeto.cd_fonte_recursos_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				IF objeto.cd_fonte_recursos_osc IS NOT null THEN
					dado_posterior.cd_origem_fonte_recursos_osc := null;
				END IF;
				
				dado_posterior.cd_fonte_recursos_osc := objeto.cd_fonte_recursos_osc;
				dado_posterior.ft_fonte_recursos_osc := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_ano_recursos_osc::TEXT, dado_anterior.ft_ano_recursos_osc, objeto.dt_ano_recursos_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.dt_ano_recursos_osc := objeto.dt_ano_recursos_osc;
				dado_posterior.ft_ano_recursos_osc := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_valor_recursos_osc::TEXT, dado_anterior.ft_valor_recursos_osc, objeto.nr_valor_recursos_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				dado_posterior.nr_valor_recursos_osc := objeto.nr_valor_recursos_osc;
				dado_posterior.ft_valor_recursos_osc := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.bo_nao_possui::TEXT, dado_anterior.ft_nao_possui, objeto.bo_nao_possui::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
				IF objeto.bo_nao_possui IS true THEN
					IF objeto.cd_origem_fonte_recursos_osc IS null AND objeto.cd_fonte_recursos_osc IS null AND objeto.dt_ano_recursos_osc IS null THEN
						RAISE EXCEPTION 'nao_possui_invalido';
					ELSE
						dado_posterior.nr_valor_recursos_osc := null;
						dado_posterior.ft_valor_recursos_osc := null;
					END IF;
				END IF;
				
				dado_posterior.bo_nao_possui := objeto.bo_nao_possui;
				dado_posterior.ft_nao_possui := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;

			IF flag_update THEN
				UPDATE osc.tb_recursos_osc
				SET cd_origem_fonte_recursos_osc = dado_posterior.cd_origem_fonte_recursos_osc,
					cd_fonte_recursos_osc = dado_posterior.cd_fonte_recursos_osc,
					ft_fonte_recursos_osc = dado_posterior.ft_fonte_recursos_osc,
					dt_ano_recursos_osc = dado_posterior.dt_ano_recursos_osc,
					ft_ano_recursos_osc = dado_posterior.ft_ano_recursos_osc,
					nr_valor_recursos_osc = dado_posterior.nr_valor_recursos_osc,
					ft_valor_recursos_osc = dado_posterior.ft_valor_recursos_osc,
					bo_nao_possui = dado_posterior.bo_nao_possui,
					ft_nao_possui = dado_posterior.ft_nao_possui
				WHERE id_recursos_osc = dado_posterior.id_recursos_osc;

				PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior),id_carga);
			END IF;

		END IF;

	END LOOP;

	IF delete_valido THEN
		IF ano IS null THEN
			FOR objeto IN (SELECT * FROM osc.tb_recursos_osc WHERE id_osc = identificador AND id_recursos_osc != ALL(dado_nao_delete))
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_fonte_recursos_osc, objeto.ft_ano_recursos_osc, objeto.ft_valor_recursos_osc, objeto.ft_nao_possui]) AS a) THEN
					DELETE FROM osc.tb_recursos_osc WHERE id_recursos_osc = objeto.id_recursos_osc;
					PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, row_to_json(objeto), null,id_carga);
				END IF;
			END LOOP;
		ELSE
			FOR objeto IN (SELECT * FROM osc.tb_recursos_osc WHERE id_osc = identificador AND id_recursos_osc != ALL(dado_nao_delete) AND dt_ano_recursos_osc = ano)
			LOOP
				IF (SELECT a.flag FROM portal.verificar_delete(fonte_dados.prioridade, ARRAY[objeto.ft_fonte_recursos_osc, objeto.ft_ano_recursos_osc, objeto.ft_valor_recursos_osc, objeto.ft_nao_possui]) AS a) THEN
					DELETE FROM osc.tb_recursos_osc WHERE id_recursos_osc = objeto.id_recursos_osc;
					PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, row_to_json(objeto), null,id_carga);
				END IF;
			END LOOP;
		END IF;
	END IF;

	flag := true;
	mensagem := 'Recursos de OSC atualizado.';

	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, osc, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
