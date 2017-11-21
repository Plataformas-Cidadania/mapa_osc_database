DROP FUNCTION portal.ativar_representante(integer);

CREATE OR REPLACE FUNCTION portal.ativar_representante(id integer)
  RETURNS boolean AS
$BODY$ 

BEGIN 

	UPDATE 
		portal.tb_usuario 
	SET 
		bo_ativo = true, 
		dt_atualizacao = NOW() 
	WHERE 
		id_usuario = id AND 
		cd_tipo_usuario = 2;

	IF FOUND THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION portal.ativar_representante(integer)
  OWNER TO postgres;