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
			VALUES (1, null, null, null, null, null, null, null, null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_empregos_formais_oscs_regiao() LOOP		
		IF (SELECT 2 = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = 2;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series, fontes) 
			VALUES (2, null, null, null, null, null, null, null, null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_area_atuacao() LOOP
		IF (SELECT 3 = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = 3;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series, fontes) 
			VALUES (3, null, null, null, null, null, null, null, null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_oscs_saude_tipo_estabelecimento() LOOP
		IF (SELECT 5 = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = 5;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series, fontes) 
			VALUES (5, null, null, null, null, null, null, null, null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_saude_regiao_tipo_gestao() LOOP
		IF (SELECT 6 = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = 6;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series, fontes) 
			VALUES (6, null, null, null, null, null, null, null, null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_osc_natureza_juridica_regiao() LOOP
		IF (SELECT 10 = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = 10;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series, fontes) 
			VALUES (10, null, null, null, null, null, null, null, null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_osc_titulos_certificados() LOOP
		IF (SELECT 11 = ANY(lista_id)) THEN 
			UPDATE portal.tb_analise 
			SET series = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = 11;
		ELSE 
			INSERT INTO portal.tb_analise(id_analise, configuracao, tipo_grafico, titulo, legenda, titulo_colunas, legenda_x, legenda_y, parametros, series, fontes) 
			VALUES (11, null, null, null, null, null, null, null, null, grafico.dados, grafico.fontes);
		END IF;
	END LOOP;
	
END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_graficos();
