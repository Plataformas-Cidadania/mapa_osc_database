DROP FUNCTION IF EXISTS portal.atualizar_localizacao_osc(fonte TEXT, osc INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN, idcarga INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_localizacao_osc(fonte TEXT, osc INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN, idcarga INTEGER) RETURNS TABLE(
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
	
BEGIN 
	nome_tabela := 'osc.tb_localizacao';
	
	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);
	
	IF fonte_dados IS null THEN 
		RAISE EXCEPTION 'fonte_invalida';
	ELSIF osc != ALL(fonte_dados.representacao) THEN 
		RAISE EXCEPTION 'permissao_negada_usuario';
	END IF;
	
	SELECT INTO objeto * FROM json_populate_record(null::osc.tb_localizacao, json::JSON);
	
	SELECT INTO dado_anterior * FROM osc.tb_localizacao WHERE id_osc = osc;
	
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
			fonte_dados.nome_fonte, 
			objeto.nr_localizacao, 
			fonte_dados.nome_fonte, 
			objeto.tx_endereco_complemento, 
			fonte_dados.nome_fonte, 
			objeto.tx_bairro, 
			fonte_dados.nome_fonte, 
			objeto.cd_municipio, 
			fonte_dados.nome_fonte, 
			objeto.nr_cep, 
			fonte_dados.nome_fonte
		) RETURNING * INTO dado_posterior;
		
		PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, dataatualizacao, null, row_to_json(dado_posterior));
		
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
		
		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.nr_cep::TEXT, dado_anterior.ft_cep, objeto.nr_cep::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
			dado_posterior.nr_cep := objeto.nr_cep;
			dado_posterior.ft_cep := fonte_dados.nome_fonte;
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
			
			PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, dataatualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior));
		END IF;
		
	END IF;
	
	flag := true;
	mensagem := 'Localização de OSC atualizado.';
	
	RETURN NEXT;
	
EXCEPTION 
	WHEN others THEN 
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, osc, dataatualizacao::TIMESTAMP, errolog, idcarga) AS a;
		RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
