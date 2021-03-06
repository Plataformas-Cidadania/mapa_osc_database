DROP FUNCTION IF EXISTS portal.atualizar_contato_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_contato_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER) RETURNS TABLE(
	mensagem TEXT,
	flag BOOLEAN
)AS $$

DECLARE
	nome_tabela TEXT;
	fonte_dados RECORD;
	objeto RECORD;
	dado_anterior RECORD;
	dado_posterior RECORD;
	flag_update BOOLEAN;
	osc INTEGER;

BEGIN
	nome_tabela := 'osc.tb_contato';
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

	SELECT INTO objeto * FROM jsonb_populate_record(null::osc.tb_contato, json);

	SELECT INTO dado_anterior * FROM osc.tb_contato WHERE id_osc = osc;

	IF COUNT(dado_anterior.id_osc) = 0 THEN
		INSERT INTO osc.tb_contato(
			id_osc,
			tx_telefone,
			ft_telefone,
			tx_email,
			bo_nao_possui_email,
			ft_email,
			nm_representante,
			ft_representante,
			tx_site,
			bo_nao_possui_site,
			ft_site,
			tx_facebook,
			ft_facebook,
			tx_google,
			ft_google,
			tx_linkedin,
			ft_linkedin,
			tx_twitter,
			ft_twitter
		) VALUES (
		 	osc,
			objeto.tx_telefone,
	 		fonte_dados.nome_fonte,
	 		objeto.tx_email,
	 		objeto.bo_nao_possui_email,
	 		fonte_dados.nome_fonte,
	 		objeto.nm_representante,
	 		fonte_dados.nome_fonte,
	 		objeto.tx_site,
	 		objeto.bo_nao_possui_site,
	 		fonte_dados.nome_fonte,
	 		objeto.tx_facebook,
	 		fonte_dados.nome_fonte,
	 		objeto.tx_google,
	 		fonte_dados.nome_fonte,
	 		objeto.tx_linkedin,
	 		fonte_dados.nome_fonte,
	 		objeto.tx_twitter,
	 		fonte_dados.nome_fonte
		) RETURNING * INTO dado_posterior;

		PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, null, row_to_json(dado_posterior), id_carga);

	ELSE
		dado_posterior := dado_anterior;
		flag_update := false;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_telefone::TEXT, dado_anterior.ft_telefone, objeto.tx_telefone::TEXT, 0, null_valido) AS a) THEN
			dado_posterior.tx_telefone := objeto.tx_telefone;
			dado_posterior.ft_telefone := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_email::TEXT, dado_anterior.ft_email, objeto.tx_email::TEXT, 0, null_valido) AS a) THEN
			dado_posterior.tx_email := objeto.tx_email;
			dado_posterior.ft_email := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.bo_nao_possui_email::TEXT, dado_anterior.ft_email, objeto.bo_nao_possui_email::TEXT, 0, null_valido) AS a) THEN
			IF (objeto.bo_nao_possui_email IS true) THEN
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_email::TEXT, dado_anterior.ft_email, null::TEXT, 0, null_valido) AS a) THEN
					dado_posterior.tx_email := null;
					dado_posterior.bo_nao_possui_email := true;
					dado_posterior.ft_email := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;				
			ELSE
				dado_posterior.bo_nao_possui_email := false;
				dado_posterior.ft_email := fonte_dados.nome_fonte;
				flag_update := true;	
			END IF;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nm_representante::TEXT, dado_anterior.ft_representante, objeto.nm_representante::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.nm_representante := objeto.nm_representante;
			dado_posterior.ft_representante := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_site::TEXT, dado_anterior.ft_site, objeto.tx_site::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_site := objeto.tx_site;
			dado_posterior.ft_site := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.bo_nao_possui_site::TEXT, dado_anterior.ft_site, objeto.bo_nao_possui_site::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			IF (objeto.bo_nao_possui_site IS true) THEN
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_site::TEXT, dado_anterior.ft_site, null::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.tx_site := null;
					dado_posterior.bo_nao_possui_site := true;
					dado_posterior.ft_site := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;				
			ELSE
				dado_posterior.bo_nao_possui_site := false;
				dado_posterior.ft_site := fonte_dados.nome_fonte;
				flag_update := true;	
			END IF;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_facebook::TEXT, dado_anterior.ft_facebook, objeto.tx_facebook::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_facebook := objeto.tx_facebook;
			dado_posterior.ft_facebook := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_google::TEXT, dado_anterior.ft_google, objeto.tx_google::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_google := objeto.tx_google;
			dado_posterior.ft_google := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_linkedin::TEXT, dado_anterior.ft_linkedin, objeto.tx_linkedin::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_linkedin := objeto.tx_linkedin;
			dado_posterior.ft_linkedin := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_twitter::TEXT, dado_anterior.ft_twitter, objeto.tx_twitter::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_twitter := objeto.tx_twitter;
			dado_posterior.ft_twitter := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF flag_update THEN
			UPDATE osc.tb_contato
			SET	tx_telefone = dado_posterior.tx_telefone,
				ft_telefone = dado_posterior.ft_telefone,
				tx_email = dado_posterior.tx_email,
				bo_nao_possui_email = dado_posterior.bo_nao_possui_email,
				ft_email = dado_posterior.ft_email,
				nm_representante = dado_posterior.nm_representante,
				ft_representante = dado_posterior.ft_representante,
				tx_site = dado_posterior.tx_site,
				bo_nao_possui_site = dado_posterior.bo_nao_possui_site,
				ft_site = dado_posterior.ft_site,
				tx_facebook = dado_posterior.tx_facebook,
				ft_facebook = dado_posterior.ft_facebook,
				tx_google = dado_posterior.tx_google,
				ft_google = dado_posterior.ft_google,
				tx_linkedin = dado_posterior.tx_linkedin,
				ft_linkedin = dado_posterior.ft_linkedin,
				tx_twitter = dado_posterior.tx_twitter,
				ft_twitter = dado_posterior.ft_twitter
			WHERE id_osc = osc;

			PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior),id_carga);

		END IF;
	END IF;

	flag := true;
	mensagem := 'Contato atualizado.';

	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, identificador, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';