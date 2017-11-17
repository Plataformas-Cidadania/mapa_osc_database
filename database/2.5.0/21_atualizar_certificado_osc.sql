DROP FUNCTION IF EXISTS portal.atualizar_certificado_osc(fonte TEXT, osc INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, deletevalido BOOLEAN, errolog BOOLEAN, idcarga INTEGER, tipobusca INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_certificado_osc(fonte TEXT, osc INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, deletevalido BOOLEAN, errolog BOOLEAN, idcarga INTEGER, tipobusca INTEGER) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$

DECLARE 
	nome_tabela TEXT;
	fonte_dados RECORD;
	objeto RECORD;
	dado_anterior RECORD;
	dado_posterior RECORD;
	registro_nao_delete INTEGER[];
	flag_update BOOLEAN;
	
BEGIN 
	nome_tabela := 'osc.tb_certificado';
	
	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);
	
	IF fonte_dados IS null THEN 
		RAISE EXCEPTION 'fonte_invalida';
	ELSIF osc != ALL(fonte_dados.representacao) THEN 
		RAISE EXCEPTION 'permissao_negada_usuario';
	END IF;
	
	registro_nao_delete := '{}';
	
	IF json_typeof(json::JSON) = 'object' THEN 
		json := ('[' || json || ']');
	END IF;
	
	FOR objeto IN (SELECT * FROM json_populate_recordset(null::osc.tb_certificado, json::JSON)) 
	LOOP 
		dado_anterior := null;
		
		IF tipobusca = 1 THEN 
			SELECT INTO dado_anterior * 
			FROM osc.tb_certificado 
			WHERE id_certificado = objeto.id_certificado;
			
		ELSIF tipobusca = 2 THEN 
			SELECT INTO dado_anterior * 
			FROM osc.tb_certificado 
			WHERE (id_osc = osc AND cd_certificado = objeto.cd_certificado);
			
		ELSE 
			RAISE EXCEPTION 'dado_invalido';
			
		END IF;
		
		IF dado_anterior.id_certificado IS null THEN 
			INSERT INTO osc.tb_certificado (
				id_osc, 
				cd_certificado, 
				ft_certificado, 
				dt_inicio_certificado,
				ft_inicio_certificado,
				dt_fim_certificado,
				ft_fim_certificado
			) VALUES (
				osc, 
				objeto.cd_certificado, 
				fonte_dados.nome_fonte, 
				objeto.dt_inicio_certificado,
				fonte_dados.nome_fonte,
				objeto.dt_fim_certificado,
				fonte_dados.nome_fonte
			) RETURNING * INTO dado_posterior;
			
			registro_nao_delete := array_append(registro_nao_delete, dado_posterior.id_certificado);
			
			PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, dataatualizacao, null, row_to_json(dado_posterior));
			
		ELSE 
			dado_posterior := dado_anterior;
			registro_nao_delete := array_append(registro_nao_delete, dado_posterior.id_certificado);
			flag_update := false;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_certificado::TEXT, dado_anterior.ft_certificado, objeto.cd_certificado::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.cd_certificado := objeto.cd_certificado;
				dado_posterior.ft_certificado := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_inicio_certificado::TEXT, dado_anterior.ft_certificado, objeto.dt_inicio_certificado::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.dt_inicio_certificado := objeto.dt_inicio_certificado;
				dado_posterior.ft_inicio_certificado := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_fim_certificado::TEXT, dado_anterior.ft_certificado, objeto.dt_fim_certificado::TEXT, fonte_dados.prioridade, nullvalido) AS a) THEN 
				dado_posterior.dt_fim_certificado := objeto.dt_fim_certificado;
				dado_posterior.ft_fim_certificado := fonte_dados.nome_fonte;
				flag_update := true;
			END IF;
			
			IF flag_update THEN 
				UPDATE osc.tb_certificado 
				SET	cd_certificado = dado_posterior.cd_certificado, 
					ft_certificado = dado_posterior.ft_certificado, 
					dt_inicio_certificado = dado_posterior.dt_inicio_certificado,
					ft_inicio_certificado = dado_posterior.ft_inicio_certificado,  
					dt_fim_certificado = dado_posterior.dt_fim_certificado, 
					ft_fim_certificado = dado_posterior.ft_fim_certificado,
					ft_certificado = dado_posterior.ft_certificado 
				WHERE id_certificado = dado_posterior.id_certificado;
				
				PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, dataatualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior));
			END IF;
		
		END IF;
		
	END LOOP;
	
	IF deletevalido THEN 
		DELETE FROM osc.tb_certificado WHERE id_certificado != ALL(registro_nao_delete);
	END IF;
	
	flag := true;
	mensagem := 'Certificado de OSC atualizado.';
	
	RETURN NEXT;
	
EXCEPTION 
	WHEN others THEN 
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, osc, dataatualizacao::TIMESTAMP, errolog, idcarga) AS a;
		RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';

