-- Materialized View: portal.vw_osc_barra_transparencia

DROP MATERIALIZED VIEW IF EXISTS portal.vw_osc_barra_transparencia CASCADE;

CREATE MATERIALIZED VIEW portal.vw_osc_barra_transparencia AS 
	SELECT 
		dados_gerais.id_osc, 
		dados_gerais.transparencia AS transparencia_dados_gerais, 
		20 AS peso_dados_gerais, 
		area_atuacao.transparencia AS transparencia_area_atuacao, 
		15 AS peso_area_atuacao, 
		descricao.transparencia AS transparencia_descricao, 
		10 AS peso_descricao_osc, 
		titulos_certificacoes.transparencia AS transparencia_titulos_certificacoes, 
		5 AS peso_titulos_certificacoes, 
		relacoes_trabalho_governanca.transparencia AS transparencia_relacoes_trabalho_governanca, 
		15 AS peso_relacoes_trabalho_governanca, 
		espacos_participacao_social.transparencia AS transparencia_espacos_participacao_social, 
		10 AS peso_espacos_participacao_social, 
		projetos_atividades_programas.transparencia AS transparencia_projetos_atividades_programas, 
		20 AS peso_projetos_atividades_programas, 
		fontes_recursos.transparencia AS transparencia_fontes_recursos, 
		5 AS peso_fontes_recursos, 
		CAST((
			COALESCE(dados_gerais.transparencia, 0) + 
			COALESCE(area_atuacao.transparencia, 0) + 
			COALESCE(descricao.transparencia, 0) + 
			COALESCE(titulos_certificacoes.transparencia, 0) + 
			COALESCE(relacoes_trabalho_governanca.transparencia, 0) + 
			COALESCE(espacos_participacao_social.transparencia, 0) + 
			COALESCE(projetos_atividades_programas.transparencia, 0) + 
			COALESCE(fontes_recursos.transparencia, 0)
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

ALTER MATERIALIZED VIEW portal.vw_osc_barra_transparencia OWNER TO postgres;