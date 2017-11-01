DROP FUNCTION IF EXISTS portal.atualizar_area_atuacao_osc(fonte TEXT, osc INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN, tipobusca INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_area_atuacao_osc(fonte TEXT, osc INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN, deletevalido BOOLEAN, tipobusca INTEGER) RETURNS TABLE(
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
	nome_tabela := 'osc.tb_area_atuacao';
	operacao := 'portal.atualizar_area_atuacao_osc(' || fonte::TEXT || ', ' || osc::TEXT || ', ' || dataatualizacao::TEXT || ', ' || json::TEXT || ', ' || nullvalido::TEXT || ', ' || errolog::TEXT || ', ' || deletevalido::TEXT || ', ' || tipobusca::TEXT || ')';
	
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
		
		FOR objeto IN (SELECT *FROM json_populate_recordset(null::osc.tb_area_atuacao, json::JSON)) 
		LOOP 
			registro_anterior := null;
			
			IF tipobusca = 1 THEN 
				SELECT INTO registro_anterior * 
				FROM osc.tb_area_atuacao 
				WHERE id_area_atuacao = objeto.id_area_atuacao;
				
			ELSIF tipobusca = 2 THEN 
				SELECT INTO registro_anterior * 
				FROM osc.tb_area_atuacao 
				WHERE (id_osc = objeto.id_osc AND cd_area_atuacao = objeto.cd_area_atuacao AND cd_subarea_atuacao = objeto.cd_subarea_atuacao);
				
			END IF;
			
			IF count(registro_anterior.id_projeto) = 0 THEN 
				INSERT INTO osc.tb_area_atuacao (
					id_osc, 
					cd_area_atuacao, 
					cd_subarea_atuacao, 
					tx_nome_outra, 
					ft_area_atuacao
				) VALUES (
					objeto.id_osc, 
					objeto.cd_area_atuacao, 
					objeto.cd_subarea_atuacao, 
					objeto.tx_nome_outra, 
					tipo_usuario
				) RETURNING * INTO registro_posterior;
				
				registro_nao_delete := array_append(registro_nao_delete, registro_posterior.id_projeto);
				
				INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
				VALUES (nome_tabela, osc, fonte::INTEGER, dataatualizacao, null, row_to_json(registro_posterior));
				
			ELSE 
				registro_posterior := registro_anterior;
				registro_nao_delete := array_append(registro_nao_delete, registro_posterior.id_projeto);
				flag_log := false;
				
				IF (
					(nullvalido = true AND registro_anterior.cd_area_atuacao <> objeto.cd_area_atuacao) OR 
					(nullvalido = false AND registro_anterior.cd_area_atuacao <> objeto.cd_area_atuacao AND (objeto.cd_area_atuacao::TEXT = '') IS FALSE)
				) AND (
					registro_anterior.ft_area_atuacao IS null OR registro_anterior.ft_area_atuacao = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.cd_area_atuacao := objeto.cd_area_atuacao;
					registro_posterior.ft_area_atuacao := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.cd_subarea_atuacao <> objeto.cd_subarea_atuacao) OR 
					(nullvalido = false AND registro_anterior.cd_subarea_atuacao <> objeto.cd_subarea_atuacao AND (objeto.cd_subarea_atuacao::TEXT = '') IS FALSE)
				) AND (
					registro_anterior.ft_area_atuacao IS null OR registro_anterior.ft_area_atuacao = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.cd_subarea_atuacao := objeto.cd_subarea_atuacao;
					registro_posterior.ft_area_atuacao := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF (
					(nullvalido = true AND registro_anterior.tx_nome_outra <> objeto.tx_nome_outra) OR 
					(nullvalido = false AND registro_anterior.tx_nome_outra <> objeto.tx_nome_outra AND (objeto.tx_nome_outra::TEXT = '') IS FALSE)
				) AND (
					registro_anterior.ft_area_atuacao IS null OR registro_anterior.ft_area_atuacao = ANY(fonte_dados_nao_oficiais)
				) THEN 
					registro_posterior.tx_nome_outra := objeto.tx_nome_outra;
					registro_posterior.ft_area_atuacao := tipo_usuario;
					flag_log := true;
				END IF;
				
				IF flag_log THEN 
					UPDATE osc.tb_area_atuacao 
					SET	cd_area_atuacao = registro_posterior.cd_area_atuacao, 
						cd_subarea_atuacao = registro_posterior.cd_subarea_atuacao, 
						tx_nome_outra = registro_posterior.tx_nome_outra, 
						ft_area_atuacao = registro_posterior.ft_area_atuacao 
					WHERE id_area_atuacao = registro_posterior.id_area_atuacao;
					
					INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
					VALUES (nome_tabela, osc, fonte::INTEGER, dataatualizacao, row_to_json(registro_anterior), row_to_json(registro_posterior));
				END IF;
			
			END IF;
			
		END LOOP;
		
		IF deletevalido THEN 
			DELETE FROM osc.tb_area_atuacao WHERE id_area_atuacao != ALL(registro_nao_delete);
		END IF;
		
		flag := true;
		mensagem := 'Área de atuação de OSC atualizado.';
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
		mensagem := 'Ocorreu um erro. ' || json;
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT || ' Operação: ' || operacao, dataatualizacao::TIMESTAMP);
		END IF;
		
		RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
