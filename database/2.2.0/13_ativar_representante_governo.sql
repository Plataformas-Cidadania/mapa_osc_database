-- DROP FUNCTION portal.ativar_representante_governo(integer);

CREATE OR REPLACE FUNCTION portal.ativar_representante_governo(id integer)
  RETURNS boolean AS
$BODY$ 

BEGIN 

	UPDATE 
		portal.tb_usuario 
	SET 
		bo_ativo = true, 
		dt_atualizacao = NOW() 
	WHERE 
		id_usuario = id;

	IF FOUND THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION portal.ativar_representante_governo(integer)
  OWNER TO postgres;