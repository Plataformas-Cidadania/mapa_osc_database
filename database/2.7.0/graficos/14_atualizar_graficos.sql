DROP FUNCTION IF EXISTS portal.atualizar_graficos();

CREATE OR REPLACE FUNCTION portal.atualizar_graficos() RETURNS VOID AS $$ 

DECLARE 
	grafico RECORD;
	id INTEGER;
	lista_id INTEGER[];
	parametros_grafico JSONB;
	
BEGIN 	
	lista_id := (SELECT ARRAY_AGG(id_analise) FROM portal.tb_analise)::INTEGER[];
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_distribuicao_osc_empregados_regiao(2) LOOP
		id := 1;
		IF (SELECT id = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes) 
			VALUES (id, '{",f", 1, ""}'::TEXT[], 'MultiBarChart', 'Distribuição de OSCs por número de empregados e região', null, null, 'Quantidade de OSC', 'Região', null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_empregos_formais_oscs_regiao() LOOP
		id := 2;
		IF (SELECT id = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes) 
			VALUES (id, '{",f", 1, ""}'::TEXT[], 'BarChart', 'Número de empregos formais nas OSCs por região', null, null, 'Quantidade de empregos', 'Região', null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_area_atuacao() LOOP
		id := 3;
		IF (SELECT id = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes) 
			VALUES (id, '{",f", 1, ""}'::TEXT[], 'DonutChart', 'Distribuição de OSCs por área de atuação', null, null, null, null, null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_assistencia_social_tipo_servico() LOOP
		id := 4;
		IF (SELECT id = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes) 
			VALUES (id, '{",f", 1, ""}'::TEXT[], 'DonutChart', 'Distribuição de OSCs de assistência social por tipo de serviço prestado', null, null, null, null, null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_saude_tipo_estabelecimento() LOOP
		id := 5;
		IF (SELECT id = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes) 
			VALUES (id, '{",f", 1, ""}'::TEXT[], 'DonutChart', 'Distribuição de OSCs de saúde por tipo de estabelecimento de saúde', null, null, null, null, null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_saude_regiao_tipo_gestao() LOOP
		id := 6;
		IF (SELECT id = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes) 
			VALUES (id, '{",f", 1, ""}'::TEXT[], 'MultiBarChart', 'Distribuição de OSCs de saúde por região e tipo de gestão', null, null, 'Quantidade de OSC', 'Região', null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_economia_solidaria_regiao_tipo_vinculo() LOOP
		id := 7;
		IF (SELECT id = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes) 
			VALUES (id, '{",f", 1, ""}'::TEXT[], 'DonutChart', 'Distribuição de OSCs de economia solidária por região e tipo de vínculo com outras entidades', null, null, null, null, null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_economia_solidaria_regiao_abrangencia() LOOP
		id := 8;
		IF (SELECT id = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes) 
			VALUES (id, '{",f", 1, ""}'::TEXT[], 'DonutChart', 'Distribuição de OSCs de economia solidária por região e abrangência da atuação', null, null, null, null, null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	parametros_grafico := COALESCE((SELECT parametros FROM portal.tb_analise WHERE id_analise = 9), '[{"barra": true, "cor": "#ccf"}, {"cor": "#ff7f0e"}]'::JSONB);
	FOR grafico IN SELECT * FROM portal.obter_grafico_total_osc_ano(parametros_grafico) LOOP
		id := 9;
		IF (SELECT id = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes) 
			VALUES (id, '{",f", 1000000, "M", ",f"}'::TEXT[], 'LinePlusBarChart', 'Total de OSC, por ano', null, null, 'Quantidade de OSC', 'Ano', null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_osc_natureza_juridica_regiao() LOOP
		id := 10;
		IF (SELECT id = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes) 
			VALUES (id, '{",f", 1, ""}'::TEXT[], 'MultiBarChart', 'Número de OSCs por natureza jurídica e região', null, null, 'Quantidade de OSC', 'Região', null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	parametros_grafico := COALESCE((SELECT parametros FROM portal.tb_analise WHERE id_analise = 11), '[{"tipo_valor": "$"}, {"tipo_valor": "$"}, {"tipo_valor": "$"}]'::JSONB);
	FOR grafico IN SELECT * FROM portal.obter_grafico_evolucao_recursos_transferidos(parametros_grafico) LOOP
		id := 11;
		IF (SELECT id = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes) 
			VALUES (id, '{",.1f", 1000000000, ""}'::TEXT[], 'LineChart', 'Evolução de recursos públicos federais transferidos para entidades sem fins lucrativos e somente para OSCs', null, null, 'em Bilhões R$', 'Ano', null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_osc_titulos_certificados() LOOP
		id := 12;
		IF (SELECT id = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes) 
			VALUES (id, '{",f", 1, ""}'::TEXT[], 'BarChart', 'Número de organizações civis com títulos e certificações', null, null, 'Quantidade de OSC', 'Tipo de título ou certificação', null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_graficos();
