UPDATE portal.tb_analise
 SET titulo='Evolução de recursos públicos federais transferidos para OSCs (2010-2018)', 
	legenda='Nota: Valores deflacionados para dez/2018, IPCA IBGE 2018.', 
	series_1='[{"key": "OSCs", "values": [{"x": 2010, "y": 14245567150.0223}, {"x": 2011, "y": 11816294203.0254}, {"x": 2012, "y": 13503943781.3592}, {"x": 2013, "y": 13149580804.0524},
	 {"x": 2014, "y": 13731267477.4746}, {"x": 2015, "y": 11449107201.6616}, {"x": 2016, "y": 12091572648.1983}, {"x": 2017, "y": 15650671798.4152}, {"x": 2018, "y":12904723282.8219}],"tipo_valor": "$"}]',
	fontes='{SIGA Brasil 2010-2018}'
WHERE id_analise=11;
