DROP FUNCTION IF EXISTS portal.atualizar_graficos();

CREATE OR REPLACE FUNCTION portal.atualizar_graficos() RETURNS VOID AS $$ 

DECLARE
	grafico RECORD;

BEGIN 
	FOR grafico IN SELECT * FROM portal.obter_grafico_distribuicao_osc_empregados_regiao() LOOP
		UPDATE portal.tb_analise 
		SET series = grafico.dados, fontes = grafico.fontes 
		WHERE id_analise = 1;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_empregos_formais_oscs_regiao() LOOP
		UPDATE portal.tb_analise 
		SET series = grafico.dados, fontes = grafico.fontes 
		WHERE id_analise = 2;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_area_atuacao() LOOP
		UPDATE portal.tb_analise 
		SET series = grafico.dados, fontes = grafico.fontes 
		WHERE id_analise = 3;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_oscs_saude_tipo_estabelecimento() LOOP
		UPDATE portal.tb_analise 
		SET series = grafico.dados, fontes = grafico.fontes 
		WHERE id_analise = 5;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_oscs_saude_regiao_tipo_gestao() LOOP
		UPDATE portal.tb_analise 
		SET series = grafico.dados, fontes = grafico.fontes 
		WHERE id_analise = 6;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_osc_natureza_juridica_regiao() LOOP
		UPDATE portal.tb_analise 
		SET series = grafico.dados, fontes = grafico.fontes 
		WHERE id_analise = 10;
	END LOOP;
	
	FOR grafico IN SELECT * FROM portal.obter_grafico_osc_titulos_certificados() LOOP
		UPDATE portal.tb_analise 
		SET series = grafico.dados, fontes = grafico.fontes 
		WHERE id_analise = 11;
	END LOOP;
	
END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_graficos();
