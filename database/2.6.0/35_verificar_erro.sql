DROP FUNCTION IF EXISTS portal.verificar_erro(codigo_erro TEXT, mensagem_erro TEXT, fonte TEXT, osc NUMERIC, data_operacao TIMESTAMP, erro_log BOOLEAN, id_carga INTEGER);

CREATE OR REPLACE FUNCTION portal.verificar_erro(codigo_erro TEXT, mensagem_erro TEXT, fonte TEXT, osc NUMERIC, data_operacao TIMESTAMP, erro_log BOOLEAN, id_carga INTEGER) RETURNS TABLE(
	mensagem TEXT
) AS $$

DECLARE
	identificador_osc NUMERIC;
	mensagem_log TEXT;
	status_log INTEGER;

BEGIN
	mensagem_log := mensagem_erro;

	IF codigo_erro = 'P0001' THEN
		IF mensagem_erro = 'fonte_invalida' THEN
			mensagem := 'Fonte de dados inválida.';

		ELSIF mensagem_erro = 'permissao_negada_usuario' THEN
			mensagem := 'Usuário não tem permissão para acessar o conteúdo informado.';

		ELSIF mensagem_erro = 'tipo_busca_invalido' THEN
			mensagem := 'Tipo de busca inválido.';

		ELSIF mensagem_erro = 'dado_invalido' THEN
			mensagem := 'Dado inválido.';

		ELSIF mensagem_erro = 'tipo_identificador_invalido' THEN
			mensagem := 'Tipo de identificador inválido.';

		ELSIF mensagem_erro = 'osc_nao_encontrada' THEN
			mensagem := 'OSC não encontrada.';
			status_log := 1;

		ELSIF mensagem_erro = 'projeto_nao_encontrado' THEN
			mensagem := 'Projeto não encontrado.';
			status_log := 1;
		
		ELSIF mensagem_erro = 'tipo_obter_projeto_invalido' THEN
			mensagem := 'Tipo de resultado do obter projeto inválido.';
			status_log := 1;
		
		ELSIF mensagem_erro = 'nao_possui_invalido' THEN
			mensagem := 'Informação de não possui inválido.';
			status_log := 1;
		
		ELSIF mensagem_erro = 'prioridade_fonte_nao_possui' THEN
			mensagem := 'Atualização de dados não permitida pela prioridade mais elevada da fonte de dados da informação de não possui.';
			status_log := 1;
		
		END IF;

		mensagem_log := mensagem;

	ELSE
		IF codigo_erro = '23502' THEN -- not_null_violation
			mensagem := 'Dado(s) obrigatório(s) não enviado(s).';

		ELSIF codigo_erro = '23505' THEN -- unique_violation
			mensagem := 'Dado(s) único(s) violado(s).';

		ELSIF codigo_erro = '23503' THEN -- foreign_key_violation
			mensagem := 'Dado(s) com chave(s) estrangeira(s) violada(s).';

		ELSE
			mensagem := 'Ocorreu um erro.';

		END IF;

	END IF;

	IF erro_log THEN 
		INSERT INTO log.tb_log_erro_carga (cd_identificador_osc, cd_status, tx_mensagem, dt_carregamento_dados, id_carga)
		VALUES (osc::NUMERIC, 2, mensagem_log::TEXT, data_operacao::TIMESTAMP, id_carga::INTEGER);
	END IF;

	RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
