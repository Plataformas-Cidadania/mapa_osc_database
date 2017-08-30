DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_osc();

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_osc() RETURNS TABLE (
	id_osc INTEGER, 
	transparencia_dados_gerais NUMERIC, 
	peso_dados_gerais DOUBLE PRECISION, 
	transparencia_area_atuacao NUMERIC, 
	peso_area_atuacao DOUBLE PRECISION, 
	transparencia_descricao NUMERIC, 
	peso_descricao DOUBLE PRECISION, 
	transparencia_titulos_certificacoes NUMERIC, 
	peso_titulos_certificacoes DOUBLE PRECISION, 
	transparencia_relacoes_trabalho_governanca NUMERIC, 
	peso_relacoes_trabalho_governanca DOUBLE PRECISION, 
	transparencia_espacos_participacao_social NUMERIC, 
	peso_espacos_participacao_social DOUBLE PRECISION, 
	transparencia_projetos_atividades_programas NUMERIC, 
	peso_projetos_atividades_programas DOUBLE PRECISION, 
	transparencia_fontes_recursos NUMERIC, 
	peso_fontes_recursos DOUBLE PRECISION, 
	transparencia_osc NUMERIC
) AS $$ 

DECLARE 
	peso_dados_gerais DOUBLE PRECISION;
	peso_area_atuacao DOUBLE PRECISION;
	peso_descricao DOUBLE PRECISION;
	peso_titulos_certificacoes DOUBLE PRECISION;
	peso_relacoes_trabalho_governanca DOUBLE PRECISION;
	peso_espacos_participacao_social DOUBLE PRECISION;
	peso_projetos_atividades_programas DOUBLE PRECISION;
	peso_fontes_recursos DOUBLE PRECISION;

BEGIN 
	peso_dados_gerais := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 1);
	peso_area_atuacao := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 2);
	peso_descricao := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 3);
	peso_titulos_certificacoes := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 4);
	peso_relacoes_trabalho_governanca := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 5);
	peso_espacos_participacao_social := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 6);
	peso_projetos_atividades_programas := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 7);
	peso_fontes_recursos := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 8);
	
	RETURN QUERY 
        SELECT 
			dados_gerais.id_osc, 
			COALESCE(dados_gerais.transparencia, 0.00) AS transparencia_dados_gerais, 
			peso_dados_gerais, 
			COALESCE(area_atuacao.transparencia, 0.00) AS transparencia_area_atuacao, 
			peso_area_atuacao, 
			COALESCE(descricao.transparencia, 0.00) AS transparencia_descricao, 
			peso_descricao, 
			COALESCE(titulos_certificacoes.transparencia, 0.00) AS transparencia_titulos_certificacoes, 
			peso_titulos_certificacoes, 
			COALESCE(relacoes_trabalho_governanca.transparencia, 0.00) AS transparencia_relacoes_trabalho_governanca, 
			peso_relacoes_trabalho_governanca, 
			COALESCE(espacos_participacao_social.transparencia, 0.00) AS transparencia_espacos_participacao_social, 
			peso_espacos_participacao_social, 
			COALESCE(projetos_atividades_programas.transparencia, 0.00) AS transparencia_projetos_atividades_programas, 
			peso_projetos_atividades_programas, 
			COALESCE(fontes_recursos.transparencia, 0.00) AS transparencia_fontes_recursos, 
			peso_fontes_recursos, 
			CAST((
				((COALESCE(dados_gerais.transparencia, 0) * peso_dados_gerais) / 100) + 
				((COALESCE(area_atuacao.transparencia, 0) * peso_area_atuacao) / 100) + 
				((COALESCE(descricao.transparencia, 0) * peso_descricao) / 100) + 
				((COALESCE(titulos_certificacoes.transparencia, 0) * peso_titulos_certificacoes) / 100) + 
				((COALESCE(relacoes_trabalho_governanca.transparencia, 0) * peso_relacoes_trabalho_governanca) / 100) + 
				((COALESCE(espacos_participacao_social.transparencia, 0) * peso_espacos_participacao_social) / 100) + 
				((COALESCE(projetos_atividades_programas.transparencia, 0) * peso_projetos_atividades_programas) / 100) + 
				((COALESCE(fontes_recursos.transparencia, 0) * peso_fontes_recursos) / 100)
			) AS NUMERIC(7,2)) AS transparencia_osc 
		FROM 
			(SELECT * FROM portal.obter_barra_transparencia_dados_gerais()) AS dados_gerais FULL JOIN  
			(SELECT * FROM portal.obter_barra_transparencia_area_atuacao()) AS area_atuacao ON dados_gerais.id_osc = area_atuacao.id_osc FULL JOIN 
			(SELECT * FROM portal.obter_barra_transparencia_descricao()) AS descricao ON dados_gerais.id_osc = descricao.id_osc FULL JOIN 
			(SELECT * FROM portal.obter_barra_transparencia_titulos_certificacoes()) AS titulos_certificacoes ON dados_gerais.id_osc = titulos_certificacoes.id_osc FULL JOIN 
			(SELECT * FROM portal.obter_barra_transparencia_relacoes_trabalho_governanca()) AS relacoes_trabalho_governanca ON dados_gerais.id_osc = relacoes_trabalho_governanca.id_osc FULL JOIN 
			(SELECT * FROM portal.obter_barra_transparencia_espacos_participacao_social()) AS espacos_participacao_social ON dados_gerais.id_osc = espacos_participacao_social.id_osc FULL JOIN 
			(SELECT * FROM portal.obter_barra_transparencia_projetos_atividades_programas()) AS projetos_atividades_programas ON dados_gerais.id_osc = projetos_atividades_programas.id_osc FULL JOIN 
			(SELECT * FROM portal.obter_barra_transparencia_fontes_recursos()) AS fontes_recursos ON dados_gerais.id_osc = fontes_recursos.id_osc;
END;

$$ LANGUAGE 'plpgsql';
