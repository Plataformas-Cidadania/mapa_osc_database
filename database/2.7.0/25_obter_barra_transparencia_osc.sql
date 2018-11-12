DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_osc2(INTEGER) CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_osc2(id_osc_req INTEGER) RETURNS TABLE (
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

BEGIN 	
	RETURN QUERY 
		SELECT
			tb_barra_transparencia.transparencia_dados_gerais, 
			tb_barra_transparencia.peso_dados_gerais, 
			tb_barra_transparencia.transparencia_area_atuacao, 
			tb_barra_transparencia.peso_area_atuacao, 
			tb_barra_transparencia.transparencia_descricao, 
			tb_barra_transparencia.peso_descricao, 
			tb_barra_transparencia.transparencia_titulos_certificacoes, 
			tb_barra_transparencia.peso_titulos_certificacoes, 
			tb_barra_transparencia.transparencia_relacoes_trabalho_governanca, 
			tb_barra_transparencia.peso_relacoes_trabalho_governanca, 
			tb_barra_transparencia.transparencia_espacos_participacao_social, 
			tb_barra_transparencia.peso_espacos_participacao_social, 
			tb_barra_transparencia.transparencia_projetos_atividades_programas, 
			tb_barra_transparencia.peso_projetos_atividades_programas, 
			tb_barra_transparencia.transparencia_fontes_recursos, 
			tb_barra_transparencia.peso_fontes_recursos, 
			tb_barra_transparencia.transparencia_osc 
		FROM 
			portal.tb_barra_transparencia 
		WHERE 
			id_osc = id_osc_req;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_barra_transparencia_osc2(789809::INTEGER);
