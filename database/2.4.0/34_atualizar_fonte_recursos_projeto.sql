--DROP FUNCTION IF EXISTS portal.atualizar_fonte_recursos_projeto(registro_json JSONB, osc INTEGER, fonte TEXT, dataatualizacao TIMESTAMP, nullvalido BOOLEAN, deletevalido BOOLEAN, errovalido BOOLEAN);

CREATE OR REPLACE FUNCTION portal.atualizar_fonte_recursos_projeto(registro_json JSONB, osc INTEGER, fonte TEXT, dataatualizacao TIMESTAMP, nullvalido BOOLEAN, deletevalido BOOLEAN, errovalido BOOLEAN) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$

DECLARE 
	fonte_dados_nao_oficiais TEXT[];
	tipo_usuario TEXT;
	objeto RECORD;
	registro_anterior RECORD;
	registro_posterior RECORD;
	registro_nao_delete INTEGER[];
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
	
	registro_nao_delete := '{}';
	
	IF json_typeof(registro_json::JSON) = 'object' THEN 
		registro_json := ('[' || registro_json || ']');
	END IF;
	
	FOR objeto IN (SELECT *FROM json_populate_recordset(null::osc.tb_fonte_recursos_projeto, registro_json::JSON)) 
	LOOP 
		SELECT INTO registro_anterior * 
		FROM osc.tb_fonte_recursos_projeto 
		WHERE id_fonte_recursos_projeto = objeto.id_fonte_recursos_projeto 
		OR (id_projeto = objeto.id_projeto 
			AND (
				cd_fonte_recursos_projeto = objeto.cd_fonte_recursos_projeto 
				OR cd_origem_fonte_recursos_projeto = objeto.cd_origem_fonte_recursos_projeto
			) 
			AND cd_tipo_parceria = objeto.cd_tipo_parceria
		);
		
		IF COUNT(registro_anterior) = 0 THEN 
			INSERT INTO osc.tb_fonte_recursos_projeto (
				id_projeto, 
				cd_fonte_recursos_projeto, 
				cd_origem_fonte_recursos_projeto, 
				ft_fonte_recursos_projeto, 
				cd_tipo_parceria, 
				ft_tipo_parceria, 
				tx_orgao_concedente, 
				ft_orgao_concedente
			) VALUES (
				objeto.id_projeto, 
				objeto.cd_fonte_recursos_projeto, 
				objeto.cd_origem_fonte_recursos_projeto, 
				fonte, 
				objeto.cd_tipo_parceria, 
				fonte, 
				objeto.tx_orgao_concedente, 
				fonte
			) RETURNING * INTO registro_posterior;
			
			registro_nao_delete := array_append(registro_nao_delete, registro_posterior.id_fonte_recursos_projeto);
			
			INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
			VALUES ('osc.tb_fonte_recursos_projeto', osc, fonte, dataatualizacao, null, row_to_json(registro_posterior));
			
		ELSE 
			registro_posterior := registro_anterior;
			registro_nao_delete := array_append(registro_nao_delete, registro_posterior.id_fonte_recursos_projeto);
			flag_log := false;
			
			IF (
				(nullvalido = true AND registro_anterior.cd_fonte_recursos_projeto <> objeto.cd_fonte_recursos_projeto) 
				OR (nullvalido = false AND registro_anterior.cd_fonte_recursos_projeto <> objeto.cd_fonte_recursos_projeto AND objeto.cd_fonte_recursos_projeto IS NOT null)
			) AND (
				registro_anterior.ft_fonte_recursos_projeto IS null OR registro_anterior.ft_fonte_recursos_projeto = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.cd_fonte_recursos_projeto := objeto.cd_fonte_recursos_projeto;
				registro_posterior.ft_fonte_recursos_projeto := fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.cd_origem_fonte_recursos_projeto <> objeto.cd_origem_fonte_recursos_projeto) OR 
				(nullvalido = false AND registro_anterior.cd_origem_fonte_recursos_projeto <> objeto.cd_origem_fonte_recursos_projeto AND objeto.cd_origem_fonte_recursos_projeto IS NOT null)
			) AND (
				registro_anterior.ft_fonte_recursos_projeto IS null OR registro_anterior.ft_fonte_recursos_projeto = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.cd_origem_fonte_recursos_projeto := objeto.cd_origem_fonte_recursos_projeto;
				registro_posterior.ft_fonte_recursos_projeto := fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.cd_tipo_parceria <> objeto.cd_tipo_parceria) OR 
				(nullvalido = false AND registro_anterior.cd_tipo_parceria <> objeto.cd_tipo_parceria AND objeto.cd_tipo_parceria IS NOT null)
			) AND (
				registro_anterior.ft_tipo_parceria IS null OR registro_anterior.ft_tipo_parceria = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.cd_tipo_parceria := objeto.cd_tipo_parceria;
				registro_posterior.ft_tipo_parceria := fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_orgao_concedente <> objeto.tx_orgao_concedente) OR 
				(nullvalido = false AND registro_anterior.tx_orgao_concedente <> objeto.tx_orgao_concedente AND objeto.tx_orgao_concedente IS NOT null)
			) AND (
				registro_anterior.ft_orgao_concedente IS null OR registro_anterior.ft_orgao_concedente = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.tx_orgao_concedente := objeto.tx_orgao_concedente;
				registro_posterior.ft_orgao_concedente := fonte;
				flag_log := true;
			END IF;
			
			UPDATE osc.tb_fonte_recursos_projeto 
			SET cd_fonte_recursos_projeto = registro_posterior.cd_fonte_recursos_projeto, 
				cd_origem_fonte_recursos_projeto = registro_posterior.cd_origem_fonte_recursos_projeto, 
				ft_fonte_recursos_projeto = registro_posterior.ft_fonte_recursos_projeto, 
				cd_tipo_parceria = registro_posterior.cd_tipo_parceria, 
				ft_tipo_parceria = registro_posterior.ft_tipo_parceria, 
				tx_orgao_concedente = registro_posterior.tx_orgao_concedente, 
				ft_orgao_concedente = registro_posterior.ft_orgao_concedente 
			WHERE id_fonte_recursos_projeto = registro_posterior.id_fonte_recursos_projeto; 
			
			IF flag_log THEN 		
				INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
				VALUES ('osc.tb_fonte_recursos_projeto', osc, fonte, dataatualizacao, row_to_json(registro_anterior), row_to_json(registro_posterior));
			END IF;
		
		END IF;
		
	END LOOP;
	
	IF deletevalido THEN 
		DELETE FROM osc.tb_fonte_recursos_projeto WHERE id_fonte_recursos_projeto != ALL(registro_nao_delete);
	END IF;
	
	flag := true;
	mensagem := 'Fonte de recursos de projeto atualizado.';
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



SELECT * FROM portal.atualizar_fonte_recursos_projeto(
	'[
		{
			"id_projeto": 1, "id_fonte_recursos_projeto": 780, "id_projeto": 24213, "cd_fonte_recursos_projeto": 1, "cd_origem_fonte_recursos_projeto": null, "cd_tipo_parceria": 2, "tx_orgao_concedente": "Secretária Estadual de Educação"
		},
		{
			"id_projeto": 1, "id_fonte_recursos_projeto": 781, "id_projeto": 24213, "cd_fonte_recursos_projeto": 1, "cd_origem_fonte_recursos_projeto": null, "cd_tipo_parceria": 3, "tx_orgao_concedente": "Secretária Estadual de Educação"
		},
		{
			"id_projeto": 1, "id_fonte_recursos_projeto": 782, "id_projeto": 24213, "cd_fonte_recursos_projeto": 1, "cd_origem_fonte_recursos_projeto": null, "cd_tipo_parceria": 4, "tx_orgao_concedente": "Secretária Estadual de Educação"
		}
	]'::JSONB, 
	'987654'::INTEGER, 
	'252'::TEXT, 
	'20-10-2017'::TIMESTAMP, 
	true::BOOLEAN, 
	true::BOOLEAN, 
	true::BOOLEAN
);
