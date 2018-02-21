UPDATE syst.dc_tipo_usuario 
SET tx_nome_tipo_usuario = 'Administrador' 
WHERE cd_tipo_usuario = 1;

UPDATE syst.dc_tipo_usuario 
SET tx_nome_tipo_usuario = 'Representante de OSC' 
WHERE cd_tipo_usuario = 2;

UPDATE syst.dc_tipo_usuario 
SET tx_nome_tipo_usuario = 'Representante de Governo Municipal' 
WHERE cd_tipo_usuario = 3;

UPDATE syst.dc_tipo_usuario 
SET tx_nome_tipo_usuario = 'Representante de Governo Estadual' 
WHERE cd_tipo_usuario = 4;
