DROP FUNCTION IF EXISTS portal.ativar_representante_osc(idusuario integer);

CREATE OR REPLACE FUNCTION portal.ativar_representante_osc(idusuario integer) RETURNS TABLE(
	flag BOOLEAN,
	mensagem TEXT
)AS $$

BEGIN 
	UPDATE 
		portal.tb_usuario 
	SET 
		bo_ativo = true, 
		dt_atualizacao = NOW() 
	WHERE 
		id_usuario = idusuario AND 
		cd_tipo_usuario = 2;
	
	flag := true;
	mensagem := 'Usuário ativado.';
	RETURN NEXT;

EXCEPTION 
	WHEN others THEN 
		flag := false;
		mensagem := 'Ocorreu um erro na ativação do usuário no banco de dados.';
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
