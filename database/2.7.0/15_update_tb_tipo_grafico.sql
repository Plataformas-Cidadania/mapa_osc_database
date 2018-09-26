DELETE FROM syst.tb_tipo_grafico;

INSERT INTO 
	syst.tb_tipo_grafico 
		(id_grafico, nome_tipo_grafico) 
	VALUES 
		(1, 'BarChart'), 
		(2, 'MultiBarChart'), 
		(3, 'LineChart'), 
		(4, 'LinePlusBarChart'), 
		(5, 'DonutChart');