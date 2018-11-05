DELETE FROM syst.tb_tipo_grafico;

INSERT INTO 
	syst.tb_tipo_grafico 
		(nome_tipo_grafico) 
	VALUES 
		('BarChart'), 
		('MultiBarChart'), 
		('LineChart'), 
		('LinePlusBarChart'), 
		('DonutChart');
