DROP FUNCTION IF EXISTS portal.atualizar_localizacao_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN, id_carga INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_localizacao_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN, id_carga INTEGER) RETURNS TABLE(
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
	nome_tabela := 'osc.atualizar_localizacao';
	tipo_identificador := lower(tipo_identificador);
	
	operacao := 'portal.atualizar_localizacao(' || fonte::TEXT || ', ' || cnpj::TEXT || ', ' || dataatualizacao::TEXT || ', ' || json::TEXT || ', ' || nullvalido::TEXT || ', ' || errolog::TEXT || ', ' || id_carga::TEXT || ')';

	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);

	IF fonte_dados IS null THEN
		RAISE EXCEPTION 'fonte_invalida';
	ELSIF osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	END IF;
	
	IF tipo_identificador = 'cnpj' THEN 
		SELECT id_osc INTO osc FROM osc.tb_osc WHERE cd_identificador_osc = identificador;
	ELSIF tipo_identificador = 'id_osc' THEN 
		osc := identificador;
	END IF;
	
	IF tipo_identificador != 'cnpj' OR tipo_identificador != 'id_osc' THEN
		RAISE EXCEPTION 'tipo_identificador_invalido';
	ELSIF osc IS null THEN 
		RAISE EXCEPTION 'identificador_invalido';
	END IF;
	
	SELECT INTO objeto * FROM json_populate_record(null::osc.tb_osc, json::JSON);
	
	SELECT INTO dado_anterior * FROM osc.tb_localizacao WHERE id_osc = osc;

	IF COUNT(dado_anterior) = 0 THEN
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
			qualidade_classificacao
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
			objeto.qualidade_classificacao
		) RETURNING * INTO dado_posterior;

		INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior)
		VALUES (nome_tabela, osc, fonte::INTEGER, dataatualizacao, null, row_to_json(dado_posterior));
		
	ELSE
		dado_posterior := dado_anterior;
		flag_update := false;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_endereco::TEXT, dado_anterior.ft_endereco, objeto.tx_endereco::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
			dado_posterior.tx_endereco := objeto.tx_endereco;
			dado_posterior.ft_endereco := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_localizacao::TEXT, dado_anterior.ft_localizacao, objeto.nr_localizacao::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
			dado_posterior.nr_localizacao := objeto.nr_localizacao;
			dado_posterior.ft_localizacao := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_endereco_complemento::TEXT, dado_anterior.ft_endereco_complemento, objeto.tx_endereco_complemento::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
			dado_posterior.tx_endereco_complemento := objeto.tx_endereco_complemento;
			dado_posterior.ft_endereco_complemento := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_bairro::TEXT, dado_anterior.ft_bairro, objeto.tx_bairro::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
			dado_posterior.tx_bairro := objeto.tx_bairro;
			dado_posterior.ft_bairro := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_municipio::TEXT, dado_anterior.ft_municipio, objeto.cd_municipio::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
			dado_posterior.cd_municipio := objeto.cd_municipio;
			dado_posterior.ft_municipio := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.geo_localizacao::TEXT, dado_anterior.ft_geo_localizacao, objeto.geo_localizacao::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
			dado_posterior.geo_localizacao := objeto.geo_localizacao;
			dado_posterior.ft_geo_localizacao := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_cep::TEXT, dado_anterior.ft_cep, objeto.nr_cep::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
			dado_posterior.nr_cep := objeto.nr_cep;
			dado_posterior.ft_cep := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_endereco_corrigido::TEXT, dado_anterior.ft_endereco_corrigido, objeto.tx_endereco_corrigido::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
			dado_posterior.tx_endereco_corrigido := objeto.tx_endereco_corrigido;
			dado_posterior.ft_endereco_corrigido := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_bairro_encontrado::TEXT, dado_anterior.ft_bairro_encontrado, objeto.tx_bairro_encontrado::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
			dado_posterior.tx_bairro_encontrado := objeto.tx_bairro_encontrado;
			dado_posterior.ft_bairro_encontrado := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_fonte_geocodificacao::TEXT, dado_anterior.ft_fonte_geocodificacao, objeto.cd_fonte_geocodificacao::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
			dado_posterior.cd_fonte_geocodificacao := objeto.cd_fonte_geocodificacao;
			dado_posterior.ft_fonte_geocodificacao := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.qualidade_classificacao::TEXT, dado_anterior.ft_fonte_geocodificacao, objeto.qualidade_classificacao::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
			dado_posterior.qualidade_classificacao := objeto.qualidade_classificacao;
			dado_posterior.ft_fonte_geocodificacao := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_geocodificacao::TEXT, dado_anterior.ft_data_geocodificacao, objeto.dt_geocodificacao::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN
			dado_posterior.dt_geocodificacao := objeto.dt_geocodificacao;
			dado_posterior.ft_data_geocodificacao := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF flag_update THEN
			UPDATE osc.tb_localizacao SET
			tx_endereco = dado_posterior.tx_endereco,
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
			qualidade_classificacao = dado_posterior.qualidade_classificacao
			WHERE id_osc = osc;

			INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior)
			VALUES (nome_tabela, osc, fonte::INTEGER, dataatualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior));

		END IF;
	END IF;

	flag := true;
	mensagem := 'Localização atualizada.';

	RETURN NEXT;

	EXCEPTION
		WHEN others THEN
			flag := false;
			SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, osc, dataatualizacao::TIMESTAMP, errolog, id_carga) AS a;
			RETURN NEXT;


END;
$$ LANGUAGE 'plpgsql';
