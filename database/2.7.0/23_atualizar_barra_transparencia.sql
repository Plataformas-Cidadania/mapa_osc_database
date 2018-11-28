DROP FUNCTION IF EXISTS portal.atualizar_barra_transparencia(INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_barra_transparencia(id_osc_req INTEGER) RETURNS VOID AS $$ 

DECLARE 
	transpararencia RECORD;
	peso_dados_gerais DOUBLE PRECISION;
	peso_area_atuacao DOUBLE PRECISION;
	peso_descricao DOUBLE PRECISION;
	peso_titulos_certificacoes DOUBLE PRECISION;
	peso_relacoes_trabalho_governanca DOUBLE PRECISION;
	peso_espacos_participacao_social DOUBLE PRECISION;
	peso_projetos_atividades_programas DOUBLE PRECISION;
	peso_fontes_recursos DOUBLE PRECISION;
	pontuacao_dados_gerais DOUBLE PRECISION;
	pontuacao_area_atuacao DOUBLE PRECISION;
	pontuacao_descricao DOUBLE PRECISION;
	pontuacao_titulos_certificacoes DOUBLE PRECISION;
	pontuacao_relacoes_trabalho_governanca DOUBLE PRECISION;
	pontuacao_espacos_participacao_social DOUBLE PRECISION;
	pontuacao_projetos_atividades_programas DOUBLE PRECISION;
	pontuacao_fontes_recursos DOUBLE PRECISION;
	
BEGIN 
	DELETE FROM portal.tb_barra_transparencia WHERE id_osc = id_osc_req;

	peso_dados_gerais := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 1);
	peso_area_atuacao := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 2);
	peso_descricao := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 3);
	peso_titulos_certificacoes := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 4);
	peso_relacoes_trabalho_governanca := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 5);
	peso_espacos_participacao_social := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 6);
	peso_projetos_atividades_programas := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 7);
	peso_fontes_recursos := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 8);

	pontuacao_dados_gerais := (SELECT pontuacao FROM portal.obter_barra_transparencia_dados_gerais(id_osc_req));
	pontuacao_area_atuacao := (SELECT pontuacao FROM portal.obter_barra_transparencia_area_atuacao(id_osc_req));
	pontuacao_descricao := (SELECT pontuacao FROM portal.obter_barra_transparencia_descricao(id_osc_req));
	pontuacao_titulos_certificacoes := (SELECT pontuacao FROM portal.obter_barra_transparencia_titulos_certificacoes(id_osc_req));
	pontuacao_relacoes_trabalho_governanca := (SELECT pontuacao FROM portal.obter_barra_transparencia_relacoes_trabalho_governanca(id_osc_req));
	pontuacao_espacos_participacao_social := (SELECT pontuacao FROM portal.obter_barra_transparencia_espacos_participacao_social(id_osc_req));
	pontuacao_projetos_atividades_programas := (SELECT pontuacao FROM portal.obter_barra_transparencia_projetos_atividades_programas(id_osc_req));
	pontuacao_fontes_recursos := (SELECT pontuacao FROM portal.obter_barra_transparencia_fontes_recursos(id_osc_req));
	
    FOR transpararencia IN 
		SELECT  
			CAST(pontuacao_dados_gerais AS NUMERIC(7,2)) AS transparencia_dados_gerais, 
			peso_dados_gerais, 
			CAST(pontuacao_area_atuacao AS NUMERIC(7,2)) AS transparencia_area_atuacao, 
			peso_area_atuacao, 
			CAST(pontuacao_descricao AS NUMERIC(7,2)) AS transparencia_descricao, 
			peso_descricao, 
			CAST(pontuacao_titulos_certificacoes AS NUMERIC(7,2)) AS transparencia_titulos_certificacoes, 
			peso_titulos_certificacoes, 
			CAST(pontuacao_relacoes_trabalho_governanca AS NUMERIC(7,2)) AS transparencia_relacoes_trabalho_governanca, 
			peso_relacoes_trabalho_governanca, 
			CAST(pontuacao_espacos_participacao_social AS NUMERIC(7,2)) AS transparencia_espacos_participacao_social, 
			peso_espacos_participacao_social, 
			CAST(pontuacao_projetos_atividades_programas AS NUMERIC(7,2)) AS transparencia_projetos_atividades_programas, 
			peso_projetos_atividades_programas, 
			CAST(pontuacao_fontes_recursos AS NUMERIC(7,2)) AS transparencia_fontes_recursos, 
			peso_fontes_recursos, 
			CAST((
				((pontuacao_dados_gerais * peso_dados_gerais) / 100) + 
				((pontuacao_area_atuacao * peso_area_atuacao) / 100) + 
				((pontuacao_descricao * peso_descricao) / 100) + 
				((pontuacao_titulos_certificacoes * peso_titulos_certificacoes) / 100) + 
				((pontuacao_relacoes_trabalho_governanca * peso_relacoes_trabalho_governanca) / 100) + 
				((pontuacao_espacos_participacao_social * peso_espacos_participacao_social) / 100) + 
				((pontuacao_projetos_atividades_programas * peso_projetos_atividades_programas) / 100) + 
				((pontuacao_fontes_recursos * peso_fontes_recursos) / 100)
			) AS NUMERIC(7,2)) AS transparencia_osc
	LOOP 
		INSERT INTO 
			portal.tb_barra_transparencia(
				id_osc, 
				transparencia_dados_gerais, 
				peso_dados_gerais, 
				transparencia_area_atuacao, 
				peso_area_atuacao, 
				transparencia_descricao, 
				peso_descricao, 
				transparencia_titulos_certificacoes, 
				peso_titulos_certificacoes, 
				transparencia_relacoes_trabalho_governanca, 
				peso_relacoes_trabalho_governanca, 
				transparencia_espacos_participacao_social, 
				peso_espacos_participacao_social, 
				transparencia_projetos_atividades_programas, 
				peso_projetos_atividades_programas, 
				transparencia_fontes_recursos, 
				peso_fontes_recursos, 
				transparencia_osc
			) 
			VALUES (
				id_osc_req, 
				transpararencia.transparencia_dados_gerais, 
				transpararencia.peso_dados_gerais, 
				transpararencia.transparencia_area_atuacao, 
				transpararencia.peso_area_atuacao, 
				transpararencia.transparencia_descricao, 
				transpararencia.peso_descricao, 
				transpararencia.transparencia_titulos_certificacoes, 
				transpararencia.peso_titulos_certificacoes, 
				transpararencia.transparencia_relacoes_trabalho_governanca, 
				transpararencia.peso_relacoes_trabalho_governanca, 
				transpararencia.transparencia_espacos_participacao_social, 
				transpararencia.peso_espacos_participacao_social, 
				transpararencia.transparencia_projetos_atividades_programas, 
				transpararencia.peso_projetos_atividades_programas, 
				transpararencia.transparencia_fontes_recursos, 
				transpararencia.peso_fontes_recursos, 
				transpararencia.transparencia_osc
			);
	END LOOP;
	
END;
$$ LANGUAGE 'plpgsql';
