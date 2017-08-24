-- Materialized View: portal.vw_barra_transparencia

DROP MATERIALIZED VIEW IF EXISTS portal.vw_barra_transparencia CASCADE;

CREATE MATERIALIZED VIEW portal.vw_barra_transparencia AS 
	SELECT 
		x.id_osc, 
		x.dados_gerais, 
		20 AS peso_dados_gerais, 
		x.areas_subareas_atuacao_osc, 
		15 AS peso_areas_subareas_atuacao_osc, 
		x.descricao_osc,
		10 AS peso_descricao_osc, 
		x.titulos_certificacoes, 
		5 AS peso_titulos_certificacoes, 
		x.relacoes_trabalho_governanca, 
		15 AS peso_relacoes_trabalho_governanca, 
		x.espacos_participacao_social, 
		10 AS peso_espacos_participacao_social, 
		CAST(x.projetos_atividades_programas AS NUMERIC(7, 2)), 
		20 AS peso_projetos_atividades_programas, 
		x.fontes_recursos_osc, 
		5 AS peso_fontes_recursos_osc, 
		(SELECT CAST((x.dados_gerais + x.areas_subareas_atuacao_osc + x.descricao_osc + x.titulos_certificacoes + x.relacoes_trabalho_governanca + x.espacos_participacao_social + x.projetos_atividades_programas + x.fontes_recursos_osc) AS NUMERIC(7,2))) total 
	FROM 
		(SELECT d.id_osc, (
			(CASE WHEN NOT(d.tx_nome_fantasia_osc IS NULL) THEN 1 ELSE 0 END) +
			(CASE WHEN NOT(d.tx_sigla_osc IS NULL) THEN 1 ELSE 0 END) +
			(CASE WHEN NOT(d.tx_nome_situacao_imovel_osc IS NULL) THEN 1 ELSE 0 END) +
			(CASE WHEN NOT(d.tx_nome_responsavel_legal IS NULL) THEN 3 ELSE 0 END) +
			(CASE WHEN NOT(d.dt_ano_cadastro_cnpj IS NULL) THEN 1 ELSE 0 END) +
			(CASE WHEN NOT(d.dt_fundacao_osc IS NULL) THEN 2 ELSE 0 END) +
			(CASE WHEN NOT(d.tx_email IS NULL) THEN 1 ELSE 0 END) +
			(CASE WHEN NOT(d.tx_resumo_osc IS NULL) THEN 4 ELSE 0 END) +
			(CASE WHEN NOT(d.tx_site IS NULL) THEN 2 ELSE 0 END) +
			(CASE WHEN NOT(d.tx_telefone IS NULL) THEN 4 ELSE 0 END)
		) dados_gerais, 
		(SELECT(
			(CASE WHEN NOT(a.tx_nome_area_atuacao IS NULL) OR NOT(tx_nome_area_atuacao_outra IS NULL) THEN 15 ELSE 0 END)
		)) areas_subareas_atuacao_osc, 
		(SELECT(
			(CASE WHEN NOT(des.tx_historico IS NULL) THEN 3 ELSE 0 END) + 
			(CASE WHEN NOT(des.tx_missao_osc IS NULL) THEN 1 ELSE 0 END) + 
			(CASE WHEN NOT(des.tx_visao_osc IS NULL) THEN 1 ELSE 0 END) + 
			(CASE WHEN NOT(des.tx_finalidades_estatutarias IS NULL) THEN 4.5 ELSE 0 END) + 
			(CASE WHEN NOT(des.tx_link_estatuto_osc IS NULL) THEN 0.5 ELSE 0 END)
		)) descricao_osc, 
		(SELECT(
			(CASE WHEN NOT(c.tx_nome_certificado IS NULL) THEN 5 ELSE 0 END)
		)) titulos_certificacoes, 
		(SELECT(
			(CASE WHEN NOT(dir.tx_cargo_dirigente IS NULL) AND NOT(dir.tx_nome_dirigente is null) THEN 9 ELSE 0 END) +
			(CASE WHEN NOT(cf.tx_nome_conselheiro IS NULL) THEN 3 ELSE 0 END) +
			(CASE WHEN NOT(t.nr_trabalhadores_voluntarios IS NULL) THEN 3 ELSE 0 END)
		)) relacoes_trabalho_governanca, 
		(SELECT(
			(CASE WHEN NOT(cons.tx_nome_conselho IS NULL) THEN 1 ELSE 0 END) +
			(CASE WHEN NOT(cons.tx_nome_tipo_participacao IS NULL) THEN 1 ELSE 0 END) +
			(CASE WHEN NOT(r.tx_nome_representante_conselho IS NULL) THEN 1 ELSE 0 END) +
			(CASE WHEN NOT(cons.tx_nome_periodicidade_reuniao_conselho IS NULL) THEN 1 ELSE 0 END) +
			(CASE WHEN NOT(cons.dt_data_inicio_conselho IS NULL) THEN 1 ELSE 0 END) +
			(CASE WHEN NOT(cons.dt_data_fim_conselho IS NULL) THEN 1 ELSE 0 END) +
			(CASE WHEN NOT(conf.tx_nome_conferencia IS NULL) THEN 1 ELSE 0 END) +
			(CASE WHEN NOT(conf.dt_ano_realizacao IS NULL) THEN 1 ELSE 0 END) +
			(CASE WHEN NOT(conf.tx_nome_forma_participacao_conferencia IS NULL) THEN 1 ELSE 0 END) +
			(CASE WHEN NOT(outra.tx_nome_participacao_social_outra IS NULL) THEN 1 ELSE 0 END)
		)) espacos_participacao_social, 
		(SELECT(
			(CASE WHEN NOT(p.tx_descricao_projeto IS NULL) THEN 1.111111111111111 ELSE 0 END) +
			(CASE WHEN NOT(p.tx_nome_status_projeto IS NULL) THEN 1.111111111111111 ELSE 0 END) +
			(CASE WHEN NOT(p.dt_data_inicio_projeto IS NULL) THEN 1.111111111111111 ELSE 0 END) +
			(CASE WHEN NOT(p.dt_data_fim_projeto IS NULL) THEN 1.111111111111111 ELSE 0 END) +
			(CASE WHEN NOT(p.tx_link_projeto IS NULL) THEN 1.111111111111111 ELSE 0 END) +
			(CASE WHEN NOT(p.nr_total_beneficiarios IS NULL) THEN 1.111111111111111 ELSE 0 END) +
			(CASE WHEN NOT(p.nr_valor_total_projeto IS NULL) THEN 1.111111111111111 ELSE 0 END) +
			(CASE WHEN NOT(p.nr_valor_captado_projeto IS NULL) THEN 1.111111111111111 ELSE 0 END) +
			(CASE WHEN NOT(f.tx_nome_origem_fonte_recursos_projeto IS NULL) THEN 1.111111111111111 ELSE 0 END) +
			(CASE WHEN NOT(p.tx_nome_abrangencia_projeto IS NULL) THEN 1.111111111111111 ELSE 0 END) +
			(CASE WHEN NOT(p.tx_nome_zona_atuacao IS NULL) THEN 1.111111111111111 ELSE 0 END) +
			(CASE WHEN NOT(pub.tx_nome_publico_beneficiado IS NULL) THEN 1.111111111111111 ELSE 0 END) +
			(CASE WHEN NOT(par.tx_nome_osc_parceira_projeto IS NULL) THEN 1.111111111111111 ELSE 0 END) +
			(CASE WHEN NOT(ap.tx_nome_area_atuacao_projeto IS NULL) THEN 1.111111111111111 ELSE 0 END) +
			(CASE WHEN NOT(fin.tx_nome_financiador IS NULL) THEN 1.111111111111111 ELSE 0 END) +
			(CASE WHEN NOT(p.tx_metodologia_monitoramento IS NULL) THEN 1.111111111111111 ELSE 0 END) +
			(CASE WHEN NOT(o.tx_nome_objetivo_projeto IS NULL) THEN 1.111111111111111 ELSE 0 END) +
			(CASE WHEN NOT(o.tx_nome_meta_projeto IS NULL) THEN 1.111111111111111 ELSE 0 END)
		)) projetos_atividades_programas, 
		(SELECT(
			(CASE WHEN NOT(rec.tx_nome_origem_fonte_recursos_osc IS NULL) AND (rec.tx_nome_origem_fonte_recursos_osc = 'Recursos públicos') THEN 1.25 ELSE 0 END) +
			(CASE WHEN NOT(rec.tx_nome_origem_fonte_recursos_osc IS NULL) AND (rec.tx_nome_origem_fonte_recursos_osc = 'Recursos privados') THEN 1.25 ELSE 0 END) +
			(CASE WHEN NOT(rec.tx_nome_origem_fonte_recursos_osc IS NULL) AND (rec.tx_nome_origem_fonte_recursos_osc = 'Recursos não financeiros') THEN 1.25 ELSE 0 END) +
			(CASE WHEN NOT(rec.tx_nome_origem_fonte_recursos_osc IS NULL) AND (rec.tx_nome_origem_fonte_recursos_osc = 'Recursos próprios') THEN 1.25 ELSE 0 END)
		)) fontes_recursos_osc 
	FROM
		portal.vw_osc_dados_gerais AS d LEFT JOIN 
		portal.vw_osc_area_atuacao AS a ON a.id_osc = d.id_osc LEFT JOIN 
		portal.vw_osc_descricao AS des ON des.id_osc = d.id_osc LEFT JOIN 
		portal.vw_osc_certificado AS c ON c.id_osc = d.id_osc LEFT JOIN 
		portal.vw_osc_governanca AS dir ON dir.id_osc = d.id_osc LEFT JOIN 
		portal.vw_osc_conselho_fiscal AS cf ON cf.id_osc = d.id_osc LEFT JOIN 
		portal.vw_osc_relacoes_trabalho AS t ON t.id_osc = d.id_osc LEFT JOIN 
		portal.vw_osc_participacao_social_conselho AS cons ON cons.id_osc = d.id_osc LEFT JOIN 
		portal.vw_osc_representante_conselho AS r ON r.id_osc = d.id_osc LEFT JOIN 
		portal.vw_osc_participacao_social_conferencia AS conf ON conf.id_osc = d.id_osc LEFT JOIN 
		portal.vw_osc_participacao_social_outra AS outra ON outra.id_osc = d.id_osc LEFT JOIN 
		portal.vw_osc_projeto AS p ON p.id_osc = d.id_osc LEFT JOIN 
		portal.vw_osc_fonte_recursos_projeto AS f ON f.id_projeto = p.id_projeto LEFT JOIN 
		portal.vw_osc_publico_beneficiado_projeto AS pub ON pub.id_projeto = f.id_projeto LEFT JOIN 
		portal.vw_osc_parceira_projeto AS par ON par.id_projeto = pub.id_projeto LEFT JOIN 
		portal.vw_osc_area_atuacao_projeto AS ap ON ap.id_projeto = par.id_projeto LEFT JOIN 
		portal.vw_osc_financiador_projeto AS fin ON fin.id_projeto = ap.id_projeto LEFT JOIN 
		portal.vw_osc_objetivo_projeto AS o ON o.id_projeto = fin.id_projeto LEFT JOIN 
		portal.vw_osc_recursos_osc AS rec ON rec.id_osc = d.id_osc) x
	GROUP BY 
		x.id_osc, x.dados_gerais, peso_dados_gerais, x.areas_subareas_atuacao_osc, 
		peso_areas_subareas_atuacao_osc, x.descricao_osc, peso_descricao_osc, 
		x.titulos_certificacoes, peso_titulos_certificacoes, x.relacoes_trabalho_governanca, 
		peso_relacoes_trabalho_governanca, x.espacos_participacao_social, 
		peso_espacos_participacao_social, x.projetos_atividades_programas, 
		peso_projetos_atividades_programas, x.fontes_recursos_osc, peso_fontes_recursos_osc, total ;

ALTER MATERIALIZED VIEW portal.vw_barra_transparencia OWNER TO postgres;