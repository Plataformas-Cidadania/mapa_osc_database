DROP FUNCTION IF EXISTS portal.atualizar_graficos();

CREATE OR REPLACE FUNCTION portal.atualizar_graficos() RETURNS VOID AS $$ 

DECLARE 
	grafico RECORD;
	id INTEGER;
	lista_id INTEGER[];
	parametros_grafico JSONB;
	
BEGIN 	
	lista_id := (SELECT ARRAY_AGG(id_analise) FROM portal.tb_analise)::INTEGER[];

	id := 1;
	FOR grafico IN SELECT * FROM portal.obter_grafico_distribuicao_osc_empregados_regiao(1) LOOP				
		IF (SELECT id = ANY(lista_id)) AND lista_id IS NOT null THEN 
			UPDATE portal.tb_analise 
				SET series_1 = grafico.dados, fontes = grafico.fontes 
				WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes, inverter_eixo, slug, ativo) 
				VALUES (id, '{",f", 1, ""}'::TEXT[], 2, 'Distribuição de OSCs por número de empregados e região', null, null, 'Quantidade de OSC', 'Região', null, grafico.dados, grafico.fontes, null, null, true);
			
			lista_id := ARRAY_APPEND(lista_id, id);
		END IF;
	END LOOP;

	FOR grafico IN SELECT * FROM portal.obter_grafico_distribuicao_osc_empregados_regiao(2) LOOP
		IF (SELECT id = ANY(lista_id)) AND lista_id IS NOT null THEN 
			UPDATE portal.tb_analise 
				SET series_2 = grafico.dados, fontes = grafico.fontes 
				WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_2, fontes, inverter_eixo, slug, ativo) 
				VALUES (id, '{",f", 1, ""}'::TEXT[], 2, 'Distribuição de OSCs por número de empregados e região', null, null, 'Quantidade de OSC', 'Região', null, grafico.dados, grafico.fontes, null, null, true);
			
			lista_id := ARRAY_APPEND(lista_id, id);
		END IF;
	END LOOP;
	
	id := 2;
	FOR grafico IN SELECT * FROM portal.obter_grafico_empregos_formais_oscs_regiao() LOOP
		IF (SELECT id = ANY(lista_id)) AND lista_id IS NOT null THEN 
			UPDATE portal.tb_analise 
				SET series_1 = grafico.dados, fontes = grafico.fontes 
				WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes, inverter_eixo, slug, ativo) 
				VALUES (id, '{",f", 1, ""}'::TEXT[], 1, 'Número de empregos formais nas OSCs por região', null, null, 'Quantidade de empregos', 'Região', null, grafico.dados, grafico.fontes, null, null, true);
			
			lista_id := ARRAY_APPEND(lista_id, id);
		END IF;
	END LOOP;
	
	id := 3;
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_area_atuacao() LOOP
		IF (SELECT id = ANY(lista_id)) AND lista_id IS NOT null THEN 
			UPDATE portal.tb_analise 
				SET series_1 = grafico.dados, fontes = grafico.fontes 
				WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes, inverter_eixo, slug, ativo) 
				VALUES (id, '{",f", 1, ""}'::TEXT[], 5, 'Distribuição de OSCs por área de atuação', null, null, null, null, null, grafico.dados, grafico.fontes, null, null, true);
			
			lista_id := ARRAY_APPEND(lista_id, id);
		END IF;
	END LOOP;
	
	id := 4;
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_assistencia_social_tipo_servico() LOOP
		IF (SELECT id = ANY(lista_id)) AND lista_id IS NOT null THEN 
			UPDATE portal.tb_analise 
				SET series_1 = grafico.dados, fontes = grafico.fontes 
				WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes, inverter_eixo, slug, ativo) 
				VALUES (id, '{",f", 1, ""}'::TEXT[], 5, 'Distribuição de OSCs de assistência social por tipo de serviço prestado', null, null, null, null, null, grafico.dados, grafico.fontes, null, null, true);
			
			lista_id := ARRAY_APPEND(lista_id, id);
		END IF;
	END LOOP;
	
	id := 5;
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_saude_tipo_estabelecimento() LOOP
		IF (SELECT id = ANY(lista_id)) AND lista_id IS NOT null THEN 
			UPDATE portal.tb_analise 
				SET series_1 = grafico.dados, fontes = grafico.fontes 
				WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes, inverter_eixo, slug, ativo) 
				VALUES (id, '{",f", 1, ""}'::TEXT[], 5, 'Distribuição de OSCs de saúde por tipo de estabelecimento de saúde', null, null, null, null, null, grafico.dados, grafico.fontes, null, null, true);
			
			lista_id := ARRAY_APPEND(lista_id, id);
		END IF;
	END LOOP;
	
	id := 6;
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_saude_regiao_tipo_gestao(1) LOOP
		IF (SELECT id = ANY(lista_id)) AND lista_id IS NOT null THEN 
			UPDATE portal.tb_analise 
				SET series_1 = grafico.dados, fontes = grafico.fontes 
				WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes, inverter_eixo, slug, ativo) 
				VALUES (id, '{",f", 1, ""}'::TEXT[], 2, 'Distribuição de OSCs de saúde por região e tipo de gestão', null, null, 'Quantidade de OSC', 'Região', null, grafico.dados, grafico.fontes, null, null, true);
			
			lista_id := ARRAY_APPEND(lista_id, id);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_saude_regiao_tipo_gestao(2) LOOP
		IF (SELECT id = ANY(lista_id)) AND lista_id IS NOT null THEN 
			UPDATE portal.tb_analise 
				SET series_2 = grafico.dados, fontes = grafico.fontes 
				WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_2, fontes, inverter_eixo, slug, ativo) 
				VALUES (id, '{",f", 1, ""}'::TEXT[], 2, 'Distribuição de OSCs de saúde por região e tipo de gestão', null, null, 'Quantidade de OSC', 'Região', null, grafico.dados, grafico.fontes, null, null, true);
			
			lista_id := ARRAY_APPEND(lista_id, id);
		END IF;
	END LOOP;
	
	id := 7;
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_economia_solidaria_regiao_tipo_vinculo(1) LOOP
		IF (SELECT id = ANY(lista_id)) AND lista_id IS NOT null THEN 
			UPDATE portal.tb_analise 
				SET series_1 = grafico.dados, fontes = grafico.fontes 
				WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes, inverter_eixo, slug, ativo) 
				VALUES (id, '{",f", 1, ""}'::TEXT[], 5, 'Distribuição de OSCs de economia solidária por região e tipo de vínculo com outras entidades', null, null, null, null, null, grafico.dados, grafico.fontes, null, null, true);
			
			lista_id := ARRAY_APPEND(lista_id, id);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_economia_solidaria_regiao_tipo_vinculo(2) LOOP
		IF (SELECT id = ANY(lista_id)) AND lista_id IS NOT null THEN 
			UPDATE portal.tb_analise 
				SET series_2 = grafico.dados, fontes = grafico.fontes 
				WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_2, fontes, inverter_eixo, slug, ativo) 
				VALUES (id, '{",f", 1, ""}'::TEXT[], 5, 'Distribuição de OSCs de economia solidária por região e tipo de vínculo com outras entidades', null, null, null, null, null, grafico.dados, grafico.fontes, null, null, true);
			
			lista_id := ARRAY_APPEND(lista_id, id);
		END IF;
	END LOOP;
	
	id := 8;
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_economia_solidaria_regiao_abrangencia(1) LOOP
		IF (SELECT id = ANY(lista_id)) AND lista_id IS NOT null THEN 
			UPDATE portal.tb_analise 
				SET series_1 = grafico.dados, fontes = grafico.fontes 
				WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes, inverter_eixo, slug, ativo) 
				VALUES (id, '{",f", 1, ""}'::TEXT[], 5, 'Distribuição de OSCs de economia solidária por região e abrangência da atuação', null, null, null, null, null, grafico.dados, grafico.fontes, null, null, true);
			
			lista_id := ARRAY_APPEND(lista_id, id);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_economia_solidaria_regiao_abrangencia(2) LOOP
		IF (SELECT id = ANY(lista_id)) AND lista_id IS NOT null THEN 
			UPDATE portal.tb_analise 
				SET series_2 = grafico.dados, fontes = grafico.fontes 
				WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_2, fontes, inverter_eixo, slug, ativo) 
				VALUES (id, '{",f", 1, ""}'::TEXT[], 5, 'Distribuição de OSCs de economia solidária por região e abrangência da atuação', null, null, null, null, null, grafico.dados, grafico.fontes, null, null, true);
			
			lista_id := ARRAY_APPEND(lista_id, id);
		END IF;
	END LOOP;
	
	id := 9;
	parametros_grafico := COALESCE((SELECT parametros FROM portal.tb_analise WHERE id_analise = 9), '[{"bar": true, "color": "#ccf"}, {"color": "#ff7f0e"}]'::JSONB);
	FOR grafico IN SELECT * FROM portal.obter_grafico_total_osc_ano(parametros_grafico) LOOP
		IF (SELECT id = ANY(lista_id)) AND lista_id IS NOT null THEN 
			UPDATE portal.tb_analise 
				SET series_1 = grafico.dados, fontes = grafico.fontes 
				WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes, inverter_eixo, slug, ativo) 
				VALUES (id, '{",f", 1000000, "M", ",f"}'::TEXT[], 4, 'Total de OSC, por ano', null, null, 'Quantidade de OSC', 'Ano', null, grafico.dados, grafico.fontes, null, null, true);
			
			lista_id := ARRAY_APPEND(lista_id, id);
		END IF;
	END LOOP;
	
	id := 10;
	FOR grafico IN SELECT * FROM portal.obter_grafico_osc_natureza_juridica_regiao() LOOP
		IF (SELECT id = ANY(lista_id)) AND lista_id IS NOT null THEN 
			UPDATE portal.tb_analise 
				SET series_1 = grafico.dados, fontes = grafico.fontes 
				WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes, inverter_eixo, slug, ativo) 
				VALUES (id, '{",f", 1, ""}'::TEXT[], 2, 'Número de OSCs por natureza jurídica e região', null, null, 'Quantidade de OSC', 'Região', null, grafico.dados, grafico.fontes, null, null, true);
			
			lista_id := ARRAY_APPEND(lista_id, id);
		END IF;
	END LOOP;
	
	id := 11;
	parametros_grafico := COALESCE((SELECT parametros FROM portal.tb_analise WHERE id_analise = 11), '[{"tipo_valor": "$"}, {"tipo_valor": "$"}, {"tipo_valor": "$"}]'::JSONB);
	FOR grafico IN SELECT * FROM portal.obter_grafico_evolucao_recursos_transferidos(parametros_grafico) LOOP
		IF (SELECT id = ANY(lista_id)) AND lista_id IS NOT null THEN 
			UPDATE portal.tb_analise 
				SET series_1 = grafico.dados, fontes = grafico.fontes 
				WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes, inverter_eixo, slug, ativo) 
				VALUES (id, '{",.1f", 1000000000, ""}'::TEXT[], 3, 'Evolução de recursos públicos federais transferidos para entidades sem fins lucrativos e somente para OSCs', null, null, 'em Bilhões R$', 'Ano', null, grafico.dados, grafico.fontes, null, null, true);
			
			lista_id := ARRAY_APPEND(lista_id, id);
		END IF;
	END LOOP;
	
	id := 12;
	FOR grafico IN SELECT * FROM portal.obter_grafico_osc_titulos_certificados() LOOP
		IF (SELECT id = ANY(lista_id)) AND lista_id IS NOT null THEN 
			UPDATE portal.tb_analise 
				SET series_1 = grafico.dados, fontes = grafico.fontes 
				WHERE id_analise = id;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series_1, fontes, inverter_eixo, slug, ativo) 
				VALUES (id, '{",f", 1, ""}'::TEXT[], 1, 'Número de organizações civis com títulos e certificações', null, null, 'Quantidade de OSC', 'Tipo de título ou certificação', null, grafico.dados, grafico.fontes, null, null, true);
			
			lista_id := ARRAY_APPEND(lista_id, id);
		END IF;
	END LOOP;
	
END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_graficos();
