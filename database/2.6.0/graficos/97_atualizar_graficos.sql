DROP FUNCTION IF EXISTS portal.atualizar_graficos();

CREATE OR REPLACE FUNCTION portal.atualizar_graficos() RETURNS VOID AS $$ 

DECLARE
	grafico RECORD;
	lista_id INTEGER[];
	
BEGIN 
	lista_id := (SELECT ARRAY_AGG(id_analise) FROM portal.tb_analise)::INTEGER[];
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_distribuicao_osc_empregados_regiao() LOOP
		IF (SELECT 1 = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = 1;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series, fontes) 
			VALUES (1, '{'',f'', 1,''''}', 'MultiBarChart', 'Distribuição de OSCs por número de empregados e região', null, null, 'Quantidade de OSC', 'Região', null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_empregos_formais_oscs_regiao() LOOP		
		IF (SELECT 2 = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = 2;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series, fontes) 
			VALUES (2, '{'',f'', 1,''''}', 'BarChart', 'Número de empregos formais nas OSCs por região', null, null, 'Quantidade de empregos', 'Região', null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_area_atuacao() LOOP
		IF (SELECT 3 = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = 3;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series, fontes) 
			VALUES (3, '{'',f'', 1,''''}', 'DonutChart', 'Distribuição de OSCs por área de atuação', null, null, null, null, null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_assistencia_social_tipo_servico() LOOP
		IF (SELECT 4 = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = 4;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series, fontes) 
			VALUES (4, '{'',f'', 1,''''}', 'DonutChart', 'Distribuição de OSCs de assistência social por tipo de serviço prestado', null, null, null, null, null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_saude_tipo_estabelecimento() LOOP
		IF (SELECT 5 = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = 5;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series, fontes) 
			VALUES (5, '{'',f'', 1,''''}', 'DonutChart', 'Distribuição de OSCs de saúde por tipo de estabelecimento de saúde', null, null, null, null, null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_saude_regiao_tipo_gestao() LOOP
		IF (SELECT 6 = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = 6;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series, fontes) 
			VALUES (6, '{'',f'', 1,''''}', 'MultiBarChart', 'Distribuição de OSCs de saúde por região e tipo de gestão', null, null, 'Quantidade de OSC', 'Região', null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_osc_natureza_juridica_regiao() LOOP
		IF (SELECT 10 = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = 10;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series, fontes) 
			VALUES (10, '{'',f'', 1,''''}', 'MultiBarChart', 'Número de OSCs por natureza jurídica e região', null, null, 'Quantidade de OSC', 'Região', null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_osc_titulos_certificados() LOOP
		IF (SELECT 11 = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = 11;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series, fontes) 
			VALUES (11, '{'',f'', 1,''''}', 'BarChart', 'Número de organizações civis com títulos e certificações', null, null, 'Quantidade de OSC', 'Tipo de título ou certificação', null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_graficos();
