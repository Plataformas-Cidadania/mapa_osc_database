CREATE OR REPLACE FUNCTION syst.atualizar_fontes_dados_governanca(
    IN fonte_antiga text,
    IN fonte_nova text)
  RETURNS TABLE(mensagem text, flag boolean) AS
$BODY$

BEGIN
	UPDATE osc.tb_governanca
	SET	ft_cargo_dirigente = fonte_nova
	WHERE ft_cargo_dirigente = fonte_antiga;

	UPDATE osc.tb_governanca
	SET	ft_nome_dirigente = fonte_nova
	WHERE ft_nome_dirigente = fonte_antiga;

	flag := true;
	mensagem := 'Fontes de dados atualizado.';
	RETURN NEXT;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
