DROP FUNCTION IF EXISTS portal.atualizar_osc(fonte TEXT, cnpj INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN, id_carga INTEGER);

DROP FUNCTION IF EXISTS portal.atualizar_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN, id_carga INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN, id_carga INTEGER) RETURNS TABLE(
	mensagem TEXT,
	flag BOOLEAN
)AS $$

DECLARE
	nome_tabela TEXT;
	operacao TEXT;
	fonte_dados RECORD;
	objeto RECORD;
	dado_anterior RECORD;
	dado_posterior RECORD;
	flag_update BOOLEAN;
	osc NUMERIC;

BEGIN
	nome_tabela := 'osc.atualizar_osc';
	tipo_identificador := lower(tipo_identificador);
	operacao := 'portal.atualizar_osc(' || fonte::TEXT || ', ' || cnpj::TEXT || ', ' || dataatualizacao::TEXT || ', ' || json::TEXT || ', ' || nullvalido::TEXT || ', ' || errolog::TEXT || ', ' || id_carga::TEXT || ')';

	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);

	IF fonte_dados IS null THEN
		RAISE EXCEPTION 'fonte_invalida';
	ELSIF osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	ELSIF tipo_identificador != 'cnpj' OR tipo_identificador != 'id_osc' THEN
		RAISE EXCEPTION 'tipo_identificador';
	END IF;

	SELECT INTO objeto * FROM json_populate_record(null::osc.tb_osc, json::JSON);

	IF tipo_identificador = 'cnpj' THEN
		SELECT id_osc INTO osc FROM osc.tb_osc WHERE cd_identificador_osc = identificador;
	ELSE
		osc:=identificador;
	END IF;

	SELECT INTO dado_anterior * FROM osc.tb_osc WHERE id_osc = osc;

	IF COUNT(dado_anterior) = 0 THEN
		INSERT INTO osc.tb_osc (
			tx_apelido_osc,
			ft_apelido_osc,
			cd_identificador_osc,
			ft_identificador_osc,
			ft_osc_ativa,
			bo_osc_ativa
		) VALUES (
			objeto.tx_apelido_osc,
			objeto.ft_apelido_osc,
			cnpj,
			fonte_dados.nome_fonte,
			fonte_dados.nome_fonte,
			objeto.bo_osc_ativa
		) RETURNING * INTO dado_posterior;

		INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior)
		VALUES (nome_tabela, osc, fonte::INTEGER, dataatualizacao, null, row_to_json(dado_posterior));

	ELSE
		dado_posterior := dado_anterior;
		flag_update := false;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_identificador_osc::TEXT, dado_anterior.ft_identificador_osc, objeto.cd_identificador_osc::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
			dado_posterior.cd_identificador_osc := objeto.cd_identificador_osc;
			dado_posterior.ft_identificador_osc := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_apelido_osc::TEXT, dado_anterior.ft_apelido_osc, objeto.tx_apelido_osc::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
			dado_posterior.tx_apelido_osc := objeto.tx_apelido_osc;
			dado_posterior.ft_apelido_osc := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.bo_osc_ativa::TEXT, dado_anterior.ft_osc_ativa, objeto.bo_osc_ativa::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
			dado_posterior.bo_osc_ativa := objeto.bo_osc_ativa;
			dado_posterior.ft_osc_ativa := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;


		IF flag_update THEN
			UPDATE osc.tb_osc
			SET tx_apelido_osc = dado_posterior.tx_apelido_osc,
			ft_apelido_osc = dado_posterior.ft_apelido_osc,
			cd_identificador_osc = dado_posterior.cd_identificador_osc,
			ft_identificador_osc = dado_posterior.ft_identificador_osc,
			ft_osc_ativa = dado_posterior.ft_osc_ativa,
			bo_osc_ativa = dado_posterior.bo_osc_ativa
			WHERE id_osc = osc;

			INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior)
			VALUES (nome_tabela, osc, fonte::INTEGER, dataatualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior));

		END IF;
	END IF;

	flag := true;
	mensagem := 'OSC atualizada.';

	RETURN NEXT;

	EXCEPTION
		WHEN others THEN
			flag := false;
			SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, osc, dataatualizacao::TIMESTAMP, errolog, id_carga) AS a;
			RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
