DROP FUNCTION IF EXISTS portal.atualizar_fonte_recursos_projeto(fonte TEXT, osc INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN, deletevalido BOOLEAN, tipobusca INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_fonte_recursos_projeto(fonte TEXT, osc INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN, deletevalido BOOLEAN, tipobusca INTEGER) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$

DECLARE 
	nome_tabela TEXT;
	operacao TEXT;
	fonte_dados_nao_oficiais TEXT[];
	tipo_usuario TEXT;
	objeto RECORD;
	registro_anterior RECORD;
	registro_posterior RECORD;
	registro_nao_delete INTEGER[];
	flag_log BOOLEAN;
	
BEGIN 
	nome_tabela := 'osc.tb_fonte_recursos_projeto';
	operacao := 'portal.atualizar_fonte_recursos_projeto(' || fonte::TEXT || ', ' || osc::TEXT || ', ' || dataatualizacao::TEXT || ', ' || json::TEXT || ', ' || nullvalido::TEXT || ', ' || errolog::TEXT || ', ' || deletevalido::TEXT || ', ' || tipobusca::TEXT || ')';
	
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
	
	IF tipo_usuario IS null THEN 
		flag := false;
		mensagem := 'Fonte de dados inválida.';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT || ' Operação: ' || operacao, dataatualizacao::TIMESTAMP);
		END IF;
		
	ELSE 
		IF tipobusca IS null THEN 
			tipobusca := 1;
		END IF;
		
		SELECT INTO fonte_dados_nao_oficiais array_agg(tx_nome_tipo_usuario) 
		FROM syst.dc_tipo_usuario;
		
		registro_nao_delete := '{}';
		
		IF json_typeof(json::JSON) = 'object' THEN 
			json := ('[' || json || ']');
		END IF;
		
		FOR objeto IN (SELECT *FROM json_populate_recordset(null::osc.tb_fonte_recursos_projeto, json::JSON)) 
		LOOP 
			registro_anterior := null;
			
			IF tipobusca = 1 THEN 
				SELECT INTO registro_anterior * 
				FROM osc.tb_fonte_recursos_projeto 
				WHERE id_fonte_recursos_projeto = objeto.id_fonte_recursos_projeto;
				
			ELSIF tipobusca = 2 THEN 
				SELECT INTO registro_anterior * 
				FROM osc.tb_fonte_recursos_projeto 
				WHERE id_projeto = objeto.id_projeto 
				AND (
					cd_fonte_recursos_projeto = objeto.cd_fonte_recursos_projeto 
					OR cd_origem_fonte_recursos_projeto = objeto.cd_origem_fonte_recursos_projeto
				) 
				AND cd_tipo_parceria = objeto.cd_tipo_parceria;
			END IF;
			
			IF registro_anterior.id_fonte_recursos_projeto IS null THEN 
				INSERT INTO osc.tb_fonte_recursos_projeto (
					id_projeto, 
					cd_fonte_recursos_projeto, 
					cd_origem_fonte_recursos_projeto, 
					ft_fonte_recursos_projeto, 
					cd_tipo_parceria, 
					tx_tipo_parceria_outro, 
					ft_tipo_parceria, 
					tx_orgao_concedente, 
					ft_orgao_concedente
				) VALUES (
					objeto.id_projeto, 
					objeto.cd_fonte_recursos_projeto, 
					objeto.cd_origem_fonte_recursos_projeto, 
					tipo_usuario, 
					objeto.cd_tipo_parceria, 
					objeto.tx_tipo_parceria_outro, 
					tipo_usuario, 
					objeto.tx_orgao_concedente, 
					tipo_usuario
				) RETURNING * INTO registro_posterior;
				
				registro_nao_delete := array_append(registro_nao_delete, registro_posterior.id_fonte_recursos_projeto);
				
				INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
				VALUES (nome_tabela, osc, fonte::INTEGER, dataatualizacao, null, row_to_json(registro_posterior));
				
			ELSE 
				registro_posterior := registro_anterior;
				registro_nao_delete := array_append(registro_nao_delete, registro_posterior.id_fonte_recursos_projeto);
				flag_log := false;
				
				IF (
					(nullvalido = true AND registro_anterior.cd_fonte_recursos_projeto <> objeto.cd_fonte_recursos_projeto) 
					OR (nullvalido = false AND registro_anterior.cd_fonte_recursos_projeto <> objeto.cd_fonte_recursos_projeto AND (objeto.cd_fonte_recursos_projeto::TEXT = '') IS FALSE)
				) AND (
					registro_anterior.ft_fonte_recursos_projeto IS null OR registro_anterior.ft_fonte_recursos_projeto = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.cd_fonte_recursos_projeto := objeto.cd_fonte_recursos_projeto;
					registro_posterior.ft_fonte_recursos_projeto := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.cd_origem_fonte_recursos_projeto <> objeto.cd_origem_fonte_recursos_projeto) OR 
					(nullvalido = false AND registro_anterior.cd_origem_fonte_recursos_projeto <> objeto.cd_origem_fonte_recursos_projeto AND (objeto.cd_origem_fonte_recursos_projeto::TEXT = '') IS FALSE)
				) AND (
					registro_anterior.ft_fonte_recursos_projeto IS null OR registro_anterior.ft_fonte_recursos_projeto = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.cd_origem_fonte_recursos_projeto := objeto.cd_origem_fonte_recursos_projeto;
					registro_posterior.ft_fonte_recursos_projeto := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.cd_tipo_parceria <> objeto.cd_tipo_parceria) OR 
					(nullvalido = false AND registro_anterior.cd_tipo_parceria <> objeto.cd_tipo_parceria AND (objeto.cd_tipo_parceria::TEXT = '') IS FALSE)
				) AND (
					registro_anterior.ft_tipo_parceria IS null OR registro_anterior.ft_tipo_parceria = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.cd_tipo_parceria := objeto.cd_tipo_parceria;
					registro_posterior.ft_tipo_parceria := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.tx_tipo_parceria_outro <> objeto.tx_tipo_parceria_outro) OR 
					(nullvalido = false AND registro_anterior.tx_tipo_parceria_outro <> objeto.tx_tipo_parceria_outro AND (objeto.tx_tipo_parceria_outro::TEXT = '') IS FALSE)
				) AND (
					registro_anterior.ft_tipo_parceria IS null OR registro_anterior.ft_tipo_parceria = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.tx_tipo_parceria_outro := objeto.tx_tipo_parceria_outro;
					registro_posterior.ft_tipo_parceria := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.tx_orgao_concedente <> objeto.tx_orgao_concedente) OR 
					(nullvalido = false AND registro_anterior.tx_orgao_concedente <> objeto.tx_orgao_concedente AND (objeto.tx_orgao_concedente::TEXT = '') IS FALSE)
				) AND (
					registro_anterior.ft_orgao_concedente IS null OR registro_anterior.ft_orgao_concedente = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.tx_orgao_concedente := objeto.tx_orgao_concedente;
					registro_posterior.ft_orgao_concedente := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF flag_log THEN 
					UPDATE osc.tb_fonte_recursos_projeto 
					SET cd_fonte_recursos_projeto = registro_posterior.cd_fonte_recursos_projeto, 
						cd_origem_fonte_recursos_projeto = registro_posterior.cd_origem_fonte_recursos_projeto, 
						ft_fonte_recursos_projeto = registro_posterior.ft_fonte_recursos_projeto, 
						cd_tipo_parceria = registro_posterior.cd_tipo_parceria, 
						tx_tipo_parceria_outro = registro_posterior.tx_tipo_parceria_outro, 
						ft_tipo_parceria = registro_posterior.ft_tipo_parceria, 
						tx_orgao_concedente = registro_posterior.tx_orgao_concedente, 
						ft_orgao_concedente = registro_posterior.ft_orgao_concedente 
					WHERE id_fonte_recursos_projeto = registro_posterior.id_fonte_recursos_projeto;
					
					INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
					VALUES (nome_tabela, osc, fonte::INTEGER, dataatualizacao, row_to_json(registro_anterior), row_to_json(registro_posterior));
				END IF;
			
			END IF;
			
		END LOOP;
		
		IF deletevalido THEN 
			DELETE FROM osc.tb_fonte_recursos_projeto WHERE id_fonte_recursos_projeto != ALL(registro_nao_delete);
		END IF;
		
		flag := true;
		mensagem := 'Fonte de recursos de projeto atualizado.';
	END IF;
	
	RETURN NEXT;

EXCEPTION 
	WHEN not_null_violation THEN 
		flag := false;
		mensagem := 'Dado(s) obrigatório(s) não enviado(s).';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT || ' Operação: ' || operacao, dataatualizacao::TIMESTAMP);
		END IF;
		
		RETURN NEXT;
		
	WHEN unique_violation THEN 
		flag := false;
		mensagem := 'Dado(s) único(s) violado(s).';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT || ' Operação: ' || operacao, dataatualizacao::TIMESTAMP);
		END IF;
		
		RETURN NEXT;
		
	WHEN foreign_key_violation THEN 
		flag := false;
		mensagem := 'Dado(s) com chave(s) estrangeira(s) violada(s).';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT || ' Operação: ' || operacao, dataatualizacao::TIMESTAMP);
		END IF;
		
		RETURN NEXT;
		
	WHEN others THEN 
		flag := false;
		mensagem := 'Ocorreu um erro.';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT || ' Operação: ' || operacao, dataatualizacao::TIMESTAMP);
		END IF;
		
		RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
