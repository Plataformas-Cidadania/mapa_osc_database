-- Function: portal.inserir_participacao_social_outra(integer, text, text, boolean)

DROP FUNCTION portal.inserir_participacao_social_outra(integer, text, text, boolean);

CREATE OR REPLACE FUNCTION portal.inserir_participacao_social_outra(id integer, nomeparticipacaosocialoutra text, ftparticipacaosocialoutra text, oficial boolean, naopossui boolean)
  RETURNS boolean AS
$BODY$

DECLARE
	status BOOLEAN;	

BEGIN
	INSERT INTO osc.tb_participacao_social_outra (id_osc, tx_nome_participacao_social_outra, ft_participacao_social_outra, bo_oficial, bo_nao_possui) 
	VALUES (id, nomeparticipacaosocialoutra, ftparticipacaosocialoutra, oficial, naopossui);

	status := true;
	RETURN status;

EXCEPTION 
	WHEN others THEN 
		status := false;
		RETURN status;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION portal.inserir_participacao_social_outra(integer, text, text, boolean, boolean)
  OWNER TO postgres;
