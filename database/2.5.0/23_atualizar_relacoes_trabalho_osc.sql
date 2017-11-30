DROP FUNCTION IF EXISTS portal.atualizar_relacoes_trabalho_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_relacoes_trabalho_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER) RETURNS TABLE(
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
	nome_tabela := 'osc.tb_relacoes_trabalho';
	tipo_identificador := lower(tipo_identificador);
	operacao := 'portal.atualizar_relacoes_trabalho_osc(' || fonte::TEXT || ', ' || identificador::TEXT ||', ' || tipo_identificador::TEXT || ', ' || data_atualizacao::TEXT || ', ' || json::TEXT || ', ' || null_valido::TEXT || ', ' || erro_log::TEXT || ', ' || id_carga::TEXT || ')';

	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);

	IF fonte_dados IS null THEN
		RAISE EXCEPTION 'fonte_invalida';
	ELSIF identificador != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	ELSIF tipo_identificador != 'cnpj' AND tipo_identificador != 'id_osc' THEN
		RAISE EXCEPTION 'tipo_identificador_invalido';
	ELSIF identificador IS null THEN
		RAISE EXCEPTION 'identificador_invalido';
	END IF;

	SELECT INTO objeto * FROM jsonb_populate_record(null::osc.tb_relacoes_trabalho, json);

	IF tipo_identificador = 'cnpj' THEN
		SELECT id_osc INTO osc FROM osc.tb_osc WHERE cd_identificador_osc = identificador;
	ELSE
		osc:=identificador;
	END IF;

	SELECT INTO dado_anterior * FROM osc.tb_relacoes_trabalho WHERE id_osc = osc;

	IF COUNT(dado_anterior.id_osc) = 0 THEN
		INSERT INTO osc.tb_relacoes_trabalho (
			id_osc,
			nr_trabalhadores_vinculo,
			ft_trabalhadores_vinculo,
			nr_trabalhadores_deficiencia,
			ft_trabalhadores_deficiencia,
			nr_trabalhadores_voluntarios,
			ft_trabalhadores_voluntarios
		) VALUES (
			osc,
			objeto.nr_trabalhadores_vinculo,
			fonte_dados.nome_fonte,
			objeto.nr_trabalhadores_deficiencia,
			fonte_dados.nome_fonte,
			objeto.nr_trabalhadores_voluntarios,
			fonte_dados.nome_fonte
		) RETURNING * INTO dado_posterior;

		PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, null, row_to_json(dado_posterior),id_carga);

	ELSE
		dado_posterior := dado_anterior;
		flag_update := false;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_trabalhadores_vinculo::TEXT, dado_anterior.ft_trabalhadores_vinculo, objeto.nr_trabalhadores_vinculo::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.nr_trabalhadores_vinculo := objeto.nr_trabalhadores_vinculo;
			dado_posterior.ft_trabalhadores_vinculo := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_trabalhadores_deficiencia::TEXT, dado_anterior.nr_trabalhadores_deficiencia, objeto.nr_trabalhadores_deficiencia::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.nr_trabalhadores_deficiencia := objeto.nr_trabalhadores_deficiencia;
			dado_posterior.ft_trabalhadores_deficiencia := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_trabalhadores_voluntarios::TEXT, dado_anterior.ft_trabalhadores_voluntarios, objeto.nr_trabalhadores_voluntarios::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.nr_trabalhadores_voluntarios := objeto.nr_trabalhadores_voluntarios;
			dado_posterior.ft_trabalhadores_voluntarios := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;


		IF flag_update THEN
			UPDATE osc.tb_relacoes_trabalho	SET
			nr_trabalhadores_vinculo = dado_posterior.nr_trabalhadores_vinculo,
			ft_trabalhadores_vinculo = dado_posterior.ft_trabalhadores_vinculo,
			nr_trabalhadores_deficiencia = dado_posterior.nr_trabalhadores_deficiencia,
			ft_trabalhadores_deficiencia = dado_posterior.ft_trabalhadores_deficiencia,
			nr_trabalhadores_voluntarios = dado_posterior.nr_trabalhadores_voluntarios,
			ft_trabalhadores_voluntarios = dado_posterior.ft_trabalhadores_voluntarios
			WHERE id_osc = osc;

			PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior),id_carga);

		END IF;
	END IF;

	flag := true;
	mensagem := 'Relação de trabalho atualizada.';

	RETURN NEXT;

	EXCEPTION
		WHEN others THEN
			flag := false;
			SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, identificador, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
			RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
