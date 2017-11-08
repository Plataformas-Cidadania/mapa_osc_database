DROP FUNCTION IF EXISTS portal.verificar_erro(mensagemerro TEXT, operacao TEXT, fonte TEXT, osc INTEGER, dataoperacao TIMESTAMP, errolog BOOLEAN);

CREATE OR REPLACE FUNCTION portal.verificar_erro(mensagemerro TEXT, operacao TEXT, fonte TEXT, osc INTEGER, dataoperacao TIMESTAMP, errolog BOOLEAN) RETURNS TABLE(
	mensagem TEXT
) AS $$

DECLARE 
	identificador_osc NUMERIC;

BEGIN 
	IF mensagemerro = 'fonte_invalida' THEN 
		mensagem := 'Fonte de dados inválida.';
		
	ELSIF mensagemerro = 'permissao_negada_usuario' THEN 
		mensagem := 'Usuário não tem permissão para acessar o conteúdo informado.';
		
	ELSIF mensagemerro = 'dado_invalido' THEN 
		mensagem := 'Dado inválido.';
		
	ELSIF mensagemerro = 'osc_nao_confere' THEN 
		mensagem := 'ID de OSC informado não confere com os dados enviados.';
		
	ELSE 
		mensagem := mensagemerro;
		
	END IF;
	
	SELECT INTO identificador_osc cd_identificador_osc FROM osc.tb_osc WHERE cd_identificador_osc = osc OR id_osc::NUMERIC = osc;
	
	IF errolog AND identificador_osc IS NOT null THEN 
		INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
		VALUES (identificador_osc, fonte, 2, mensagem || ' Operação: ' || operacao, dataoperacao);
	END IF;
	
	RETURN NEXT;
	
END;
$$ LANGUAGE 'plpgsql';
