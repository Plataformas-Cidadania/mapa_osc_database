ALTER TABLE osc.tb_publico_beneficiado DISABLE TRIGGER ALL;

UPDATE osc.tb_publico_beneficiado
 set ft_publico_beneficiado = 'Representante de OSC'
	where ft_publico_beneficiado = 'Representante';
	
ALTER TABLE osc.tb_publico_beneficiado ENABLE TRIGGER ALL;