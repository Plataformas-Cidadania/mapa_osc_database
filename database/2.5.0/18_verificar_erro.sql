DROP FUNCTION IF EXISTS portal.verificar_erro(codigoerro TEXT, mensagemerro TEXT, fonte TEXT, identificador NUMERIC, dataoperacao TIMESTAMP, errolog BOOLEAN, idcarga INTEGER);

CREATE OR REPLACE FUNCTION portal.verificar_erro(codigoerro TEXT, mensagemerro TEXT, fonte TEXT, identificador NUMERIC, dataoperacao TIMESTAMP, errolog BOOLEAN, idcarga INTEGER) RETURNS TABLE(
	mensagem TEXT
) AS $$

DECLARE 
	identificador_osc NUMERIC;
	mensagem_log TEXT;
	
BEGIN 
	mensagem_log := mensagemerro;
	
	IF codigoerro = 'P0001' THEN 
		IF mensagemerro = 'fonte_invalida' THEN 
			mensagem := 'Fonte de dados inválida.';
			
		ELSIF mensagemerro = 'permissao_negada_usuario' THEN 
			mensagem := 'Usuário não tem permissão para acessar o conteúdo informado.';
			
		ELSIF mensagemerro = 'dado_invalido' THEN 
			mensagem := 'Dado inválido.';
			
		ELSIF mensagemerro = 'osc_nao_confere' THEN 
			mensagem := 'ID de OSC informado não confere com os dados enviados.';
			
		ELSIF mensagemerro = 'tipo_identificador_invalido' THEN 
			mensagem := 'Tipo de identificador inválido.';
			
		ELSIF mensagemerro = 'identificador_invalido' THEN 
			mensagem := 'Identificador inválido.';
			
		END IF;
		
		mensagem_log := mensagem;
		
	ELSE 
		IF codigoerro = '23502' THEN -- not_null_violation
			mensagem := 'Dado(s) obrigatório(s) não enviado(s).';
			
		ELSIF codigoerro = '23505' THEN -- unique_violation
			mensagem := 'Dado(s) único(s) violado(s).';
			
		ELSIF codigoerro = '23503' THEN -- foreign_key_violation
			mensagem := 'Dado(s) com chave(s) estrangeira(s) violada(s).';
			
		ELSE 
			mensagem := 'Ocorreu um erro.';
			
		END IF;
		
	END IF;
	
	IF errolog AND identificador_osc IS NOT null THEN 
		INSERT INTO log.tb_log_erro_carga (cd_identificador_osc, cd_status, tx_mensagem, dt_carregamento_dados, tx_fonte_dados, id_carga) 
		VALUES (identificador, 2, mensagem_log, dataoperacao, fonte, idcarga);
	END IF;
	
	RETURN NEXT;
	
END;
$$ LANGUAGE 'plpgsql';
