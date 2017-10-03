DROP FUNCTION IF EXISTS portal.logar_usuario(login TEXT, senha TEXT);

CREATE OR REPLACE FUNCTION portal.logar_usuario(login TEXT, senha TEXT) RETURNS TABLE(
	id_usuario INTEGER, 
	cd_tipo_usuario INTEGER, 
	tx_nome_usuario TEXT, 
	cd_municipio INTEGER, 
	cd_uf INTEGER, 
	bo_email_confirmado BOOLEAN, 
	bo_ativo BOOLEAN 
) AS $$

BEGIN 
	RETURN QUERY 
		SELECT 
			tb_usuario.id_usuario, 
			tb_usuario.cd_tipo_usuario, 
			tb_usuario.tx_nome_usuario,
        	tb_usuario.cd_municipio, 
			tb_usuario.cd_uf, 
			tb_usuario.bo_email_confirmado, 
			tb_usuario.bo_ativo 
		FROM 
			portal.tb_usuario 
		WHERE 
			(tb_usuario.tx_email_usuario = login AND tx_senha_usuario = senha AND tb_usuario.cd_tipo_usuario = 2) OR 
			(tb_usuario.cd_municipio::TEXT = login AND tx_senha_usuario = senha AND tb_usuario.cd_tipo_usuario = 3) OR 
			(tb_usuario.cd_uf::TEXT = login AND tx_senha_usuario = senha AND tb_usuario.cd_tipo_usuario = 4); 
END; 

$$ LANGUAGE 'plpgsql';
