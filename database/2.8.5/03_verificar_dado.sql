create or replace function portal.verificar_dado(dado_anterior text, fonte_dado_anterior text, dado_posterior text, dado_posterior_prioridade integer, nome_campo_ed text, nullvalido boolean) returns TABLE(flag boolean)
	language plpgsql
as $$
DECLARE
	fonte_ajustada TEXT;
BEGIN
	flag := false;

	fonte_ajustada := SUBSTRING(fonte_dado_anterior FROM 0 FOR char_length(fonte_dado_anterior) - position(' ' in reverse(fonte_dado_anterior)) + 1);

	IF (dado_anterior IS null) THEN dado_anterior = ''; END IF;

	dado_posterior := COALESCE(dado_posterior, '');

	IF ( ( nullvalido = true AND dado_anterior <> dado_posterior) OR (nullvalido = false AND dado_anterior <> dado_posterior AND (dado_posterior::TEXT = '') IS false) )
       AND ( fonte_dado_anterior IS null OR dado_posterior_prioridade <= ( SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = fonte_dado_anterior OR cd_sigla_fonte_dados = fonte_ajustada ) )
       OR (SELECT ce.editavel FROM syst.tb_campos_editaveis ce WHERE ce.nome_campo = nome_campo_ed::text)
    THEN
		flag := true;
	END IF;

	RETURN NEXT;

END;
$$;

alter function portal.verificar_dado(text, text, text, integer, boolean) owner to i3geo;