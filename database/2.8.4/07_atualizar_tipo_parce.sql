ALTER TABLE osc.tb_tipo_parceria_projeto DISABLE TRIGGER ALL;

UPDATE osc.tb_tipo_parceria_projeto
 set ft_tipo_parceria_projeto = 'Representante de OSC'
	where ft_tipo_parceria_projeto = 'Representante';
	
ALTER TABLE osc.tb_tipo_parceria_projeto ENABLE TRIGGER ALL;