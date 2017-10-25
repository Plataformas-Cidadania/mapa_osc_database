DROP FUNCTION IF EXISTS portal.atualizar_localizacao_osc(registro JSONB, fonte TEXT, dataatualizacao TIMESTAMP, nullvalido BOOLEAN, errovalido BOOLEAN);

CREATE OR REPLACE FUNCTION portal.atualizar_localizacao_osc(registro JSONB, fonte TEXT, dataatualizacao TIMESTAMP, nullvalido BOOLEAN, errovalido BOOLEAN) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$

DECLARE 
	fonte_dados_nao_oficiais TEXT[];
	tipo_usuario TEXT;
	objeto RECORD;
	registro_anterior RECORD;
	registro_posterior RECORD;
	flag_log BOOLEAN;
	
BEGIN 
	SELECT INTO fonte_dados_nao_oficiais array_agg(tx_nome_tipo_usuario) 
	FROM syst.dc_tipo_usuario;
	
	SELECT INTO tipo_usuario (
		SELECT dc_tipo_usuario.tx_nome_tipo_usuario 
		FROM portal.tb_usuario 
		INNER JOIN syst.dc_tipo_usuario 
		ON tb_usuario.cd_tipo_usuario = dc_tipo_usuario.cd_tipo_usuario 
		WHERE tb_usuario.id_usuario::TEXT = fonte 
		UNION 
		SELECT cd_sigla_fonte_dados 
		FROM syst.dc_fonte_dados 
		WHERE dc_fonte_dados.cd_sigla_fonte_dados::TEXT = fonte
	);
	
	SELECT INTO objeto * 
	FROM json_populate_record(null::osc.tb_localizacao, registro::JSON);
	
	SELECT INTO registro_anterior * 
	FROM osc.tb_localizacao 
	WHERE id_osc = objeto.id_osc;
	
	IF COUNT(registro_anterior) = 0 THEN 
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
			objeto.id_osc, 
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
		) RETURNING * INTO registro_posterior;
		
		INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
		VALUES ('osc.tb_localizacao', registro_posterior.id_osc, fonte::INTEGER, dataatualizacao, null, row_to_json(registro_posterior));
		
	ELSE 
		registro_posterior := registro_anterior;
		flag_log := false;
		
		IF (
			(nullvalido = true AND registro_anterior.tx_endereco <> objeto.tx_endereco) 
			OR (nullvalido = false AND registro_anterior.tx_endereco <> objeto.tx_endereco AND objeto.tx_endereco IS NOT null)
		) AND (
			registro_anterior.ft_endereco IS null OR registro_anterior.ft_endereco = ANY(fonte_dados_nao_oficiais)
		) THEN 
			registro_posterior.tx_endereco := objeto.tx_endereco;
			registro_posterior.ft_endereco := tipo_usuario;
			flag_log := true;
		END IF;
		
		IF (
			(nullvalido = true AND registro_anterior.nr_localizacao <> objeto.nr_localizacao) 
			OR (nullvalido = false AND registro_anterior.nr_localizacao <> objeto.nr_localizacao AND objeto.nr_localizacao IS NOT null) 
		) AND (
			registro_anterior.ft_localizacao IS null OR registro_anterior.ft_localizacao = ANY(fonte_dados_nao_oficiais)
		) THEN 
			registro_posterior.nr_localizacao := objeto.nr_localizacao;
			registro_posterior.ft_localizacao := tipo_usuario;
			flag_log := true;
		END IF;
		
		IF (
			(nullvalido = true AND registro_anterior.tx_endereco_complemento <> objeto.tx_endereco_complemento) 
			OR (nullvalido = false AND registro_anterior.tx_endereco_complemento <> objeto.tx_endereco_complemento AND objeto.tx_endereco_complemento IS NOT null)
		) AND (
			registro_anterior.ft_endereco_complemento IS null OR registro_anterior.ft_endereco_complemento = ANY(fonte_dados_nao_oficiais)
		) THEN 
			registro_posterior.tx_endereco_complemento := objeto.tx_endereco_complemento;
			registro_posterior.ft_endereco_complemento := tipo_usuario;
			flag_log := true;
		END IF;
		
		IF (
			(nullvalido = true AND registro_anterior.tx_bairro <> objeto.tx_bairro) 
			OR (nullvalido = false AND registro_anterior.tx_bairro <> objeto.tx_bairro AND objeto.tx_bairro IS NOT null)
		) AND (
			registro_anterior.ft_bairro IS null OR registro_anterior.ft_bairro = ANY(fonte_dados_nao_oficiais)
		) THEN 
			registro_posterior.tx_bairro := objeto.tx_bairro;
			registro_posterior.ft_bairro := tipo_usuario;
			flag_log := true;
		END IF;
		
		IF (
			(nullvalido = true AND registro_anterior.cd_municipio <> objeto.cd_municipio) 
			OR (nullvalido = false AND registro_anterior.cd_municipio <> objeto.cd_municipio AND objeto.cd_municipio IS NOT null)
		) AND (
			registro_anterior.ft_municipio IS null OR registro_anterior.ft_municipio = ANY(fonte_dados_nao_oficiais)
		) THEN 
			registro_posterior.cd_municipio := objeto.cd_municipio;
			registro_posterior.ft_municipio := tipo_usuario;
			flag_log := true;
		END IF;
		
		IF (
			(nullvalido = true AND registro_anterior.nr_cep <> objeto.nr_cep) 
			OR (nullvalido = false AND registro_anterior.nr_cep <> objeto.nr_cep AND objeto.nr_cep IS NOT null)
		) AND (
			registro_anterior.ft_cep IS null OR registro_anterior.ft_cep = ANY(fonte_dados_nao_oficiais)
		) THEN 
			registro_posterior.nr_cep := objeto.nr_cep;
			registro_posterior.ft_cep := tipo_usuario;
			flag_log := true;
		END IF;
		
		UPDATE osc.tb_localizacao 
		SET tx_endereco = registro_posterior.tx_endereco, 
			ft_endereco = registro_posterior.ft_endereco, 
			nr_localizacao = registro_posterior.nr_localizacao, 
			ft_localizacao = registro_posterior.ft_localizacao, 
			tx_endereco_complemento = registro_posterior.tx_endereco_complemento, 
			ft_endereco_complemento = registro_posterior.ft_endereco_complemento, 
			tx_bairro = registro_posterior.tx_bairro, 
			ft_bairro = registro_posterior.ft_bairro, 
			cd_municipio = registro_posterior.cd_municipio, 
			ft_municipio = registro_posterior.ft_municipio, 
			nr_cep = registro_posterior.nr_cep, 
			ft_cep = registro_posterior.ft_cep 
		WHERE id_osc = registro_posterior.id_osc; 
		
		IF flag_log THEN 		
			INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
			VALUES ('osc.tb_localizacao', registro_posterior.id_osc, fonte::INTEGER, dataatualizacao, row_to_json(registro_anterior), row_to_json(registro_posterior));
		END IF;
		
	END IF;
	
	flag := true;
	mensagem := 'Localização de OSC atualizado.';
	RETURN NEXT;
	
EXCEPTION 
	WHEN not_null_violation THEN 
		IF errovalido THEN 
			RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;
		END IF;
		
		flag := false;
		mensagem := 'Dado(s) obrigatório(s) não enviado(s).';
		RETURN NEXT;
		
	WHEN unique_violation THEN 
		IF errovalido THEN 
			RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;
		END IF;
		
		flag := false;
		mensagem := 'Dado(s) único(s) violado(s).';
		RETURN NEXT;
		
	WHEN foreign_key_violation THEN 
		IF errovalido THEN 
			RAISE EXCEPTION '(%) %', SQLSTATE, SQLERRM;
		END IF;
		
		flag := false;
		mensagem := 'Dado(s) com chave(s) estrangeira(s) violada(s).';
		RETURN NEXT;
		
	WHEN others THEN 
		IF errovalido THEN 
			RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;
		END IF;
		
		flag := false;
		mensagem := 'Ocorreu um erro.';
		RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';



SELECT * FROM portal.atualizar_localizacao_osc('{
	"id_osc": 789809, 
	"tx_endereco": "RUA CAPITAO SILVIO GONCALVES DE FARIAS", 
	"nr_localizacao": "981", 
	"tx_endereco_complemento": "Lote 2", 
	"tx_bairro": "BOSQUE", 
	"cd_municipio": 1100155, 
	"nr_cep": 76920000
}'::JSONB, '828'::TEXT, '2017-10-25'::TIMESTAMP, false, true);
