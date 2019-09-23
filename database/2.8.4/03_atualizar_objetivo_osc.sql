ALTER TABLE osc.tb_objetivo_osc DISABLE TRIGGER ALL;

UPDATE osc.tb_objetivo_osc
 set ft_objetivo_osc = 'Representante de OSC'
	where ft_objetivo_osc = 'Representante' or ft_objetivo_osc = 'Representante de Organização da Sociedade Cívil';
	
ALTER TABLE osc.tb_objetivo_osc ENABLE TRIGGER ALL;