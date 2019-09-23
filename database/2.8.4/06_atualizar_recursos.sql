SELECT id_recursos_osc, id_osc, cd_fonte_recursos_osc, ft_fonte_recursos_osc, dt_ano_recursos_osc, ft_ano_recursos_osc, nr_valor_recursos_osc, ft_valor_recursos_osc, bo_nao_possui, ft_nao_possui, cd_origem_fonte_recursos_osc
	FROM osc.tb_recursos_osc;
	
ALTER TABLE osc.tb_recursos_osc DISABLE TRIGGER ALL;

UPDATE osc.tb_recursos_osc
 set ft_nao_possui = 'Representante de OSC'
	where ft_nao_possui = 'Representante de Organização da Sociedade Cívil';
	
ALTER TABLE osc.tb_recursos_osc ENABLE TRIGGER ALL;