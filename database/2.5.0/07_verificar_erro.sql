DROP FUNCTION IF EXISTS portal.verificar_erro(codigoerro TEXT, operacao TEXT, fonte TEXT, osc INTEGER, dataoperacao TIMESTAMP, errolog BOOLEAN);
DROP FUNCTION IF EXISTS portal.verificar_erro(codigoerro TEXT, operacao TEXT, osc INTEGER, dataoperacao TIMESTAMP, errolog BOOLEAN, id_carga INTEGER);

CREATE OR REPLACE FUNCTION portal.verificar_erro(codigoerro TEXT, operacao TEXT, osc INTEGER, dataoperacao TIMESTAMP, errolog BOOLEAN, id_carga INTEGER) RETURNS TABLE(
	mensagem TEXT
) AS $$

DECLARE
	identificador_osc NUMERIC;

BEGIN
	IF codigoerro = 'fonte_invalida' THEN
		mensagem := 'Fonte de dados inválida.';

	ELSIF codigoerro = 'permissao_negada_usuario' THEN
		mensagem := 'Usuário não tem permissão para acessar este conteúdo.';

	ELSIF codigoerro = 'dado_invalido' THEN
		mensagem := 'Dado inválido.';

	ELSIF codigoerro = 'osc_nao_confere' THEN
		mensagem := 'ID de OSC informado não confere com os dados enviados.';

	ELSIF codigoerro = '23502' THEN -- not_null_violation
		mensagem := 'Dado(s) obrigatório(s) não enviado(s).';

	ELSIF codigoerro = '23505' THEN -- unique_violation
		mensagem := 'Dado(s) único(s) violado(s).';

	ELSIF codigoerro = '23503' THEN -- foreign_key_violation
		mensagem := 'Dado(s) com chave(s) estrangeira(s) violada(s).';

	ELSE
		mensagem := 'Ocorreu um erro.';

	END IF;

	SELECT INTO identificador_osc cd_identificador_osc FROM osc.tb_osc WHERE cd_identificador_osc = osc OR id_osc::NUMERIC = osc;

	IF errolog AND identificador_osc IS NOT null AND id_carga IS NOT NULL THEN
		INSERT INTO log.tb_log_erro_carga(cd_identificador_osc, cd_status, tx_mensagem, dt_carregamento_dados, id_carga)
		VALUES (identificador_osc, 2, mensagem || ' Operação: ' || operacao, dataoperacao, id_carga);
	ELSIF errolog AND identificador_osc IS NOT null AND id_carga IS NULL THEN
		INSERT INTO log.tb_log_erro_carga(cd_identificador_osc, cd_status, tx_mensagem, dt_carregamento_dados)
		VALUES (identificador_osc, 2, mensagem || ' Operação: ' || operacao, dataoperacao);
	END IF;

	RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
