DROP FUNCTION IF EXISTS portal.atualizar_graficos();

CREATE OR REPLACE FUNCTION portal.atualizar_graficos() RETURNS VOID AS $$ 

DECLARE 
	grafico RECORD;
	id INTEGER;
	parametros_grafico JSONB;
	
BEGIN
	id := 1;
	FOR grafico IN SELECT * FROM portal.obter_grafico_distribuicao_osc_empregados_regiao(1) LOOP				
		UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
	END LOOP;

	FOR grafico IN SELECT * FROM portal.obter_grafico_distribuicao_osc_empregados_regiao(2) LOOP
		UPDATE portal.tb_analise 
			SET series_2 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
	END LOOP;
	
	id := 2;
	FOR grafico IN SELECT * FROM portal.obter_grafico_empregos_formais_oscs_regiao() LOOP
		UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
	END LOOP;
	
	id := 3;
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_area_atuacao() LOOP
		UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
	END LOOP;
	
	id := 4;
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_assistencia_social_tipo_servico() LOOP
		UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
	END LOOP;
	
	id := 5;
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_saude_tipo_estabelecimento() LOOP
		UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
	END LOOP;
	
	id := 6;
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_saude_regiao_tipo_gestao(1) LOOP
		UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_saude_regiao_tipo_gestao(2) LOOP
		UPDATE portal.tb_analise 
			SET series_2 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
	END LOOP;
	
	id := 7;
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_economia_solidaria_regiao_tipo_vinculo(1) LOOP
		UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_economia_solidaria_regiao_tipo_vinculo(2) LOOP
		UPDATE portal.tb_analise 
			SET series_2 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
	END LOOP;
	
	id := 8;
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_economia_solidaria_regiao_abrangencia(1) LOOP
		UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_economia_solidaria_regiao_abrangencia(2) LOOP
		UPDATE portal.tb_analise 
			SET series_2 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
	END LOOP;
	
	id := 9;
	parametros_grafico := COALESCE((SELECT parametros FROM portal.tb_analise WHERE id_analise = 9), '[{"bar": true, "color": "#ccf"}, {"color": "#ff7f0e"}]'::JSONB);
	FOR grafico IN SELECT * FROM portal.obter_grafico_total_osc_ano(parametros_grafico) LOOP
		UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
	END LOOP;
	
	id := 10;
	FOR grafico IN SELECT * FROM portal.obter_grafico_osc_natureza_juridica_regiao(1) LOOP
		UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
	END LOOP;

	FOR grafico IN SELECT * FROM portal.obter_grafico_osc_natureza_juridica_regiao(2) LOOP
		UPDATE portal.tb_analise 
			SET series_2 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
	END LOOP;
	
	id := 11;
	parametros_grafico := COALESCE((SELECT parametros FROM portal.tb_analise WHERE id_analise = 11), '[{"tipo_valor": "$"}, {"tipo_valor": "$"}, {"tipo_valor": "$"}]'::JSONB);
	FOR grafico IN SELECT * FROM portal.obter_grafico_evolucao_recursos_transferidos(parametros_grafico) LOOP
		UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
	END LOOP;
	
	id := 12;
	FOR grafico IN SELECT * FROM portal.obter_grafico_osc_titulos_certificados() LOOP
		UPDATE portal.tb_analise 
			SET series_1 = grafico.dados, fontes = grafico.fontes 
			WHERE id_analise = id;
	END LOOP;
	
END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_graficos();
