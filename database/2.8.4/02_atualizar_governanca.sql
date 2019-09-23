ALTER TABLE osc.tb_governanca DISABLE TRIGGER ALL;

UPDATE osc.tb_governanca
 set ft_cargo_dirigente = 'Representante de OSC'
	where ft_cargo_dirigente = 'Representante';

UPDATE osc.tb_governanca
 set ft_nome_dirigente = 'Representante de OSC'
	where ft_nome_dirigente = 'Representante';
	
ALTER TABLE osc.tb_governanca ENABLE TRIGGER ALL;