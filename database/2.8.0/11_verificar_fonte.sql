DROP FUNCTION IF EXISTS portal.verificar_fonte(fonte TEXT);

CREATE OR REPLACE FUNCTION portal.verificar_fonte(fonte TEXT) RETURNS TABLE(
	nome_fonte TEXT,
	prioridade INTEGER,
	ativo BOOLEAN,
	representacao INTEGER[]
) AS $$

DECLARE 
	fonte_usuario TEXT;
	fonte_ajustada TEXT;

BEGIN 
	fonte_ajustada := SUBSTRING(fonte FROM 0 FOR char_length(fonte) - position(' ' in reverse(fonte)) + 1);

	IF (SELECT fonte ~ '^[0-9]+$') THEN
		SELECT INTO fonte_usuario, ativo, representacao
			(
				SELECT tx_nome_tipo_usuario
				FROM syst.dc_tipo_usuario
				WHERE dc_tipo_usuario.cd_tipo_usuario = tb_usuario.cd_tipo_usuario
			),
			bo_ativo,
			(
				SELECT array_agg(id_osc)
				FROM portal.tb_representacao
				WHERE tb_representacao.id_usuario = tb_usuario.id_usuario
			)
			FROM portal.tb_usuario
			WHERE tb_usuario.id_usuario = fonte::INTEGER;
	END IF;

	IF fonte_usuario IS NOT null THEN
		SELECT INTO nome_fonte, prioridade cd_sigla_fonte_dados, nr_prioridade
		FROM syst.dc_fonte_dados
		WHERE dc_fonte_dados.cd_sigla_fonte_dados = fonte_usuario;

	ELSE
		nome_fonte := fonte;

		ativo := null;
		representacao := null;

		SELECT INTO nome_fonte, prioridade cd_sigla_fonte_dados, nr_prioridade
		FROM syst.dc_fonte_dados
		WHERE dc_fonte_dados.cd_sigla_fonte_dados = fonte
		OR dc_fonte_dados.cd_sigla_fonte_dados = fonte_ajustada
		AND (
			SELECT true
			FROM (SELECT array_agg(tx_nome_tipo_usuario) AS tipos_usuario FROM syst.dc_tipo_usuario) AS dc_tipo_usuario
			WHERE fonte != ALL(tipos_usuario)
			AND fonte_ajustada != ALL(tipos_usuario)
		);

	END IF;

	RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';