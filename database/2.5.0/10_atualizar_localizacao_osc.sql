DROP FUNCTION IF EXISTS portal.atualizar_localizacao_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_localizacao_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER) RETURNS TABLE(
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
	nome_tabela := 'osc.tb_localizacao';
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

	SELECT INTO objeto * FROM jsonb_populate_record(null::osc.tb_localizacao, json);

	SELECT INTO dado_anterior * FROM osc.tb_localizacao WHERE id_osc = osc;

	IF COUNT(dado_anterior.id_osc) = 0 THEN
		INSERT INTO osc.tb_localizacao(
			id_osc,
			tx_endereco,
			ft_endereco,
			nr_localizacao,
			ft_localizacao,
			tx_endereco_complemento,
			ft_endereco_complemento,
			tx_bairro,
			ft_bairro,
			cd_municipio,
			ft_municipio,
			geo_localizacao,
			ft_geo_localizacao,
			nr_cep,
			ft_cep,
			tx_endereco_corrigido,
			ft_endereco_corrigido,
			tx_bairro_encontrado,
			ft_bairro_encontrado,
			cd_fonte_geocodificacao,
			ft_fonte_geocodificacao,
			dt_geocodificacao,
			ft_data_geocodificacao,
			qualidade_classificacao,
			bo_oficial
		)
		VALUES (
			osc,
			objeto.tx_endereco,
			fonte_dados.nome_fonte,
			objeto.nr_localizacao,
			fonte_dados.nome_fonte,
			objeto.tx_endereco_complemento,
			fonte_dados.nome_fonte,
			objeto.tx_bairro,
			fonte_dados.nome_fonte,
			objeto.cd_municipio,
			fonte_dados.nome_fonte,
			objeto.geo_localizacao,
			fonte_dados.nome_fonte,
			objeto.nr_cep,
			fonte_dados.nome_fonte,
			objeto.tx_endereco_corrigido,
			fonte_dados.nome_fonte,
			objeto.tx_bairro_encontrado,
			fonte_dados.nome_fonte,
			objeto.cd_fonte_geocodificacao,
			fonte_dados.nome_fonte,
			objeto.dt_geocodificacao,
			fonte_dados.nome_fonte,
			objeto.qualidade_classificacao,
			objeto.bo_oficial
		) RETURNING * INTO dado_posterior;

		PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, null, row_to_json(dado_posterior),id_carga);

	ELSE
		dado_posterior := dado_anterior;
		flag_update := false;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_endereco::TEXT, dado_anterior.ft_endereco, objeto.tx_endereco::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_endereco := objeto.tx_endereco;
			dado_posterior.ft_endereco := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_localizacao::TEXT, dado_anterior.ft_localizacao, objeto.nr_localizacao::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.nr_localizacao := objeto.nr_localizacao;
			dado_posterior.ft_localizacao := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_endereco_complemento::TEXT, dado_anterior.ft_endereco_complemento, objeto.tx_endereco_complemento::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_endereco_complemento := objeto.tx_endereco_complemento;
			dado_posterior.ft_endereco_complemento := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_bairro::TEXT, dado_anterior.ft_bairro, objeto.tx_bairro::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_bairro := objeto.tx_bairro;
			dado_posterior.ft_bairro := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_municipio::TEXT, dado_anterior.ft_municipio, objeto.cd_municipio::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.cd_municipio := objeto.cd_municipio;
			dado_posterior.ft_municipio := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.geo_localizacao::TEXT, dado_anterior.ft_geo_localizacao, objeto.geo_localizacao::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.geo_localizacao := objeto.geo_localizacao;
			dado_posterior.ft_geo_localizacao := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_cep::TEXT, dado_anterior.ft_cep, objeto.nr_cep::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.nr_cep := objeto.nr_cep;
			dado_posterior.ft_cep := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_endereco_corrigido::TEXT, dado_anterior.ft_endereco_corrigido, objeto.tx_endereco_corrigido::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_endereco_corrigido := objeto.tx_endereco_corrigido;
			dado_posterior.ft_endereco_corrigido := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_bairro_encontrado::TEXT, dado_anterior.ft_bairro_encontrado, objeto.tx_bairro_encontrado::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_bairro_encontrado := objeto.tx_bairro_encontrado;
			dado_posterior.ft_bairro_encontrado := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_fonte_geocodificacao::TEXT, dado_anterior.ft_fonte_geocodificacao, objeto.cd_fonte_geocodificacao::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.cd_fonte_geocodificacao := objeto.cd_fonte_geocodificacao;
			dado_posterior.ft_fonte_geocodificacao := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.qualidade_classificacao::TEXT, dado_anterior.ft_fonte_geocodificacao, objeto.qualidade_classificacao::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.qualidade_classificacao := objeto.qualidade_classificacao;
			dado_posterior.ft_fonte_geocodificacao := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_geocodificacao::TEXT, dado_anterior.ft_data_geocodificacao, objeto.dt_geocodificacao::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.dt_geocodificacao := objeto.dt_geocodificacao;
			dado_posterior.ft_data_geocodificacao := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.bo_oficial::TEXT, dado_anterior.ft_endereco, objeto.bo_oficial::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.bo_oficial := objeto.bo_oficial;
			flag_update := true;
		END IF;

		IF flag_update THEN
			UPDATE osc.tb_localizacao
			SET	tx_endereco = dado_posterior.tx_endereco,
				ft_endereco = dado_posterior.ft_endereco,
				nr_localizacao = dado_posterior.nr_localizacao,
				ft_localizacao = dado_posterior.ft_localizacao,
				tx_endereco_complemento = dado_posterior.tx_endereco_complemento,
				ft_endereco_complemento = dado_posterior.ft_endereco_complemento,
				tx_bairro = dado_posterior.tx_bairro,
				ft_bairro = dado_posterior.ft_bairro,
				cd_municipio = dado_posterior.cd_municipio,
				ft_municipio = dado_posterior.ft_municipio,
				geo_localizacao = dado_posterior.geo_localizacao,
				ft_geo_localizacao = dado_posterior.ft_geo_localizacao,
				nr_cep = dado_posterior.nr_cep,
				ft_cep = dado_posterior.ft_cep,
				tx_endereco_corrigido = dado_posterior.tx_endereco_corrigido,
				ft_endereco_corrigido = dado_posterior.ft_endereco_corrigido,
				tx_bairro_encontrado = dado_posterior.tx_bairro_encontrado,
				ft_bairro_encontrado = dado_posterior.ft_bairro_encontrado,
				cd_fonte_geocodificacao = dado_posterior.cd_fonte_geocodificacao,
				ft_fonte_geocodificacao = dado_posterior.ft_fonte_geocodificacao,
				dt_geocodificacao = dado_posterior.dt_geocodificacao,
				ft_data_geocodificacao = dado_posterior.ft_data_geocodificacao,
				qualidade_classificacao = dado_posterior.qualidade_classificacao,
				bo_oficial = dado_posterior.bo_oficial
			WHERE id_osc = osc;

      PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior),id_carga);

		END IF;
	END IF;

	flag := true;
	mensagem := 'Localização de OSC atualizada.';

	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, identificador, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
