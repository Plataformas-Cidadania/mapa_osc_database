DROP FUNCTION IF EXISTS portal.atualizar_localizacao_osc(fonte TEXT, osc INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN);

CREATE OR REPLACE FUNCTION portal.atualizar_localizacao_osc(fonte TEXT, osc INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN) RETURNS TABLE(
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
	
BEGIN 
	nome_tabela := 'osc.tb_localizacao';
	operacao := 'portal.atualizar_localizacao_osc(' || fonte::TEXT || ', ' || osc::TEXT || ', ' || dataatualizacao::TEXT || ', ' || json::TEXT || ', ' || nullvalido::TEXT || ', ' || errolog::TEXT || ')';
	
	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);
	
	IF fonte_dados.nome_fonte IS null THEN 
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro('permissao_negada_usuario', operacao, fonte, osc, dataatualizacao::TIMESTAMP, errolog) AS a;
	
	ELSIF osc != ALL(fonte_dados.representacao) THEN 
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro('permissao_negada_usuario', operacao, fonte, osc, dataatualizacao::TIMESTAMP, errolog) AS a;
	
	ELSE 
		SELECT INTO objeto * 
		FROM json_populate_record(null::osc.tb_localizacao, json::JSON);
		
		SELECT INTO dado_anterior * 
		FROM osc.tb_localizacao 
		WHERE id_osc = osc;
		
		IF COUNT(dado_anterior) = 0 THEN 
			INSERT INTO osc.tb_localizacao (
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
				nr_cep, 
				ft_cep
			) VALUES (
				osc, 
				objeto.tx_endereco, 
				tipo_usuario, 
				objeto.nr_localizacao, 
				tipo_usuario, 
				objeto.tx_endereco_complemento, 
				tipo_usuario, 
				objeto.tx_bairro, 
				tipo_usuario, 
				objeto.cd_municipio, 
				tipo_usuario, 
				objeto.nr_cep, 
				tipo_usuario
			) RETURNING * INTO dado_posterior;
			
			INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
			VALUES (nome_tabela, dado_posterior.id_osc, fonte::INTEGER, dataatualizacao, null, row_to_json(dado_posterior));
			
		ELSE 
			dado_posterior := dado_anterior;
			flag_update := false;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_endereco::TEXT, dado_anterior.ft_endereco, objeto.tx_endereco::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.tx_endereco := objeto.tx_endereco;
				dado_posterior.ft_endereco := tipo_usuario;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_localizacao::TEXT, dado_anterior.ft_localizacao, objeto.nr_localizacao::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.nr_localizacao := objeto.nr_localizacao;
				dado_posterior.ft_localizacao := tipo_usuario;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_endereco_complemento::TEXT, dado_anterior.ft_endereco_complemento, objeto.tx_endereco_complemento::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.tx_endereco_complemento := objeto.tx_endereco_complemento;
				dado_posterior.ft_endereco_complemento := tipo_usuario;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_bairro::TEXT, dado_anterior.ft_bairro, objeto.tx_bairro::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.tx_bairro := objeto.tx_bairro;
				dado_posterior.ft_bairro := tipo_usuario;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_municipio::TEXT, dado_anterior.ft_municipio, objeto.cd_municipio::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.cd_municipio := objeto.cd_municipio;
				dado_posterior.ft_municipio := tipo_usuario;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_cep::TEXT, dado_anterior.ft_cep, objeto.nr_cep::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.nr_cep := objeto.nr_cep;
				dado_posterior.ft_cep := tipo_usuario;
				flag_update := true;
			END IF;
			
			IF flag_update THEN 
				UPDATE osc.tb_localizacao 
				SET tx_endereco = dado_posterior.tx_endereco, 
					ft_endereco = dado_posterior.ft_endereco, 
					nr_localizacao = dado_posterior.nr_localizacao, 
					ft_localizacao = dado_posterior.ft_localizacao, 
					tx_endereco_complemento = dado_posterior.tx_endereco_complemento, 
					ft_endereco_complemento = dado_posterior.ft_endereco_complemento, 
					tx_bairro = dado_posterior.tx_bairro, 
					ft_bairro = dado_posterior.ft_bairro, 
					cd_municipio = dado_posterior.cd_municipio, 
					ft_municipio = dado_posterior.ft_municipio, 
					nr_cep = dado_posterior.nr_cep, 
					ft_cep = dado_posterior.ft_cep 
				WHERE id_osc = osc;
				
				INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
				VALUES (nome_tabela, dado_posterior.id_osc, fonte::INTEGER, dataatualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior));
			END IF;
			
		END IF;
		
		flag := true;
		mensagem := 'Localização de OSC atualizado.';
	END IF;
	
	RETURN NEXT;
	
EXCEPTION 
	WHEN others THEN 
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro('permissao_negada_usuario', operacao, fonte, osc, dataatualizacao::TIMESTAMP, errolog) AS a;
		
		RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
