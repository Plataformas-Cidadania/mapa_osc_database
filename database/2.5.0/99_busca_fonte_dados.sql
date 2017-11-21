SELECT dc_fonte_dados.cd_sigla_fonte_dados, fonte_dados.nome_fonte FROM syst.dc_fonte_dados AS dc_fonte_dados FULL OUTER JOIN (
	-- tb_osc
	SELECT ft_apelido_osc AS nome_fonte FROM osc.tb_osc GROUP BY ft_apelido_osc UNION 
	SELECT ft_identificador_osc AS nome_fonte FROM osc.tb_osc GROUP BY ft_identificador_osc UNION 
	SELECT ft_osc_ativa AS nome_fonte FROM osc.tb_osc GROUP BY ft_osc_ativa UNION 

	-- tb_dados_gerais
	SELECT ft_natureza_juridica_osc AS nome_fonte FROM osc.tb_dados_gerais GROUP BY ft_natureza_juridica_osc UNION 
	SELECT ft_subclasse_atividade_economica_osc AS nome_fonte FROM osc.tb_dados_gerais GROUP BY ft_subclasse_atividade_economica_osc UNION 
	SELECT ft_razao_social_osc AS nome_fonte FROM osc.tb_dados_gerais GROUP BY ft_razao_social_osc UNION 
	SELECT ft_nome_fantasia_osc AS nome_fonte FROM osc.tb_dados_gerais GROUP BY ft_nome_fantasia_osc UNION 
	SELECT ft_logo AS nome_fonte FROM osc.tb_dados_gerais GROUP BY ft_logo UNION 
	SELECT ft_missao_osc AS nome_fonte FROM osc.tb_dados_gerais GROUP BY ft_missao_osc UNION 
	SELECT ft_visao_osc AS nome_fonte FROM osc.tb_dados_gerais GROUP BY ft_visao_osc UNION 
	SELECT ft_fundacao_osc AS nome_fonte FROM osc.tb_dados_gerais GROUP BY ft_fundacao_osc UNION 
	SELECT ft_ano_cadastro_cnpj AS nome_fonte FROM osc.tb_dados_gerais GROUP BY ft_ano_cadastro_cnpj UNION 
	SELECT ft_sigla_osc AS nome_fonte FROM osc.tb_dados_gerais GROUP BY ft_sigla_osc UNION 
	SELECT ft_resumo_osc AS nome_fonte FROM osc.tb_dados_gerais GROUP BY ft_resumo_osc UNION 
	SELECT ft_situacao_imovel_osc AS nome_fonte FROM osc.tb_dados_gerais GROUP BY ft_situacao_imovel_osc UNION 
	SELECT ft_link_estatuto_osc AS nome_fonte FROM osc.tb_dados_gerais GROUP BY ft_link_estatuto_osc UNION 
	SELECT ft_historico AS nome_fonte FROM osc.tb_dados_gerais GROUP BY ft_historico UNION 
	SELECT ft_finalidades_estatutarias AS nome_fonte FROM osc.tb_dados_gerais GROUP BY ft_finalidades_estatutarias UNION 
	SELECT ft_link_relatorio_auditoria AS nome_fonte FROM osc.tb_dados_gerais GROUP BY ft_link_relatorio_auditoria UNION 
	SELECT ft_link_demonstracao_contabil AS nome_fonte FROM osc.tb_dados_gerais GROUP BY ft_link_demonstracao_contabil UNION 
	SELECT ft_nome_responsavel_legal AS nome_fonte FROM osc.tb_dados_gerais GROUP BY ft_nome_responsavel_legal UNION 

	-- tb_contato
	SELECT ft_telefone AS nome_fonte FROM osc.tb_contato GROUP BY ft_telefone UNION 
	SELECT ft_email AS nome_fonte FROM osc.tb_contato GROUP BY ft_email UNION 
	SELECT ft_representante AS nome_fonte FROM osc.tb_contato GROUP BY ft_representante UNION 
	SELECT ft_site AS nome_fonte FROM osc.tb_contato GROUP BY ft_site UNION 
	SELECT ft_facebook AS nome_fonte FROM osc.tb_contato GROUP BY ft_facebook UNION 
	SELECT ft_google AS nome_fonte FROM osc.tb_contato GROUP BY ft_google UNION 
	SELECT ft_linkedin AS nome_fonte FROM osc.tb_contato GROUP BY ft_linkedin UNION 
	SELECT ft_twitter AS nome_fonte FROM osc.tb_contato GROUP BY ft_twitter UNION 

	-- tb_localizacao
	SELECT ft_endereco AS nome_fonte FROM osc.tb_localizacao GROUP BY ft_endereco UNION 
	SELECT ft_localizacao AS nome_fonte FROM osc.tb_localizacao GROUP BY ft_localizacao UNION 
	SELECT ft_endereco_complemento AS nome_fonte FROM osc.tb_localizacao GROUP BY ft_endereco_complemento UNION 
	SELECT ft_bairro AS nome_fonte FROM osc.tb_localizacao GROUP BY ft_bairro UNION 
	SELECT ft_municipio AS nome_fonte FROM osc.tb_localizacao GROUP BY ft_municipio UNION 
	SELECT ft_geo_localizacao AS nome_fonte FROM osc.tb_localizacao GROUP BY ft_geo_localizacao UNION 
	SELECT ft_cep AS nome_fonte FROM osc.tb_localizacao GROUP BY ft_cep UNION 
	SELECT ft_endereco_corrigido AS nome_fonte FROM osc.tb_localizacao GROUP BY ft_endereco_corrigido UNION 
	SELECT ft_bairro_encontrado AS nome_fonte FROM osc.tb_localizacao GROUP BY ft_bairro_encontrado UNION 
	SELECT ft_fonte_geocodificacao AS nome_fonte FROM osc.tb_localizacao GROUP BY ft_fonte_geocodificacao UNION 
	SELECT ft_data_geocodificacao AS nome_fonte FROM osc.tb_localizacao GROUP BY ft_data_geocodificacao UNION 

	-- tb_relacoes_trabalho
	SELECT ft_trabalhadores_vinculo AS nome_fonte FROM osc.tb_relacoes_trabalho GROUP BY ft_trabalhadores_vinculo UNION 
	SELECT ft_trabalhadores_deficiencia AS nome_fonte FROM osc.tb_relacoes_trabalho GROUP BY ft_trabalhadores_deficiencia UNION 
	SELECT ft_trabalhadores_voluntarios AS nome_fonte FROM osc.tb_relacoes_trabalho GROUP BY ft_trabalhadores_voluntarios UNION 

	-- tb_relacoes_trabalho_outra
	SELECT ft_trabalhadores AS nome_fonte FROM osc.tb_relacoes_trabalho_outra GROUP BY ft_trabalhadores UNION 
	SELECT ft_tipo_relacao_trabalho AS nome_fonte FROM osc.tb_relacoes_trabalho_outra GROUP BY ft_tipo_relacao_trabalho UNION 

	-- tb_conselho_fiscal
	SELECT ft_nome_conselheiro AS nome_fonte FROM osc.tb_conselho_fiscal GROUP BY ft_nome_conselheiro UNION 

	-- tb_area_atuacao
	SELECT ft_area_atuacao AS nome_fonte FROM osc.tb_area_atuacao GROUP BY ft_area_atuacao UNION 

	-- tb_certificado
	SELECT ft_certificado AS nome_fonte FROM osc.tb_certificado GROUP BY ft_certificado UNION 
	SELECT ft_inicio_certificado AS nome_fonte FROM osc.tb_certificado GROUP BY ft_inicio_certificado UNION 
	SELECT ft_fim_certificado AS nome_fonte FROM osc.tb_certificado GROUP BY ft_fim_certificado UNION 

	-- tb_participacao_social_conferencia
	SELECT ft_conferencia AS nome_fonte FROM osc.tb_participacao_social_conferencia GROUP BY ft_conferencia UNION 
	SELECT ft_ano_realizacao AS nome_fonte FROM osc.tb_participacao_social_conferencia GROUP BY ft_ano_realizacao UNION 
	SELECT ft_forma_participacao_conferencia AS nome_fonte FROM osc.tb_participacao_social_conferencia GROUP BY ft_forma_participacao_conferencia UNION 

	-- tb_participacao_social_conselho
	SELECT ft_conselho AS nome_fonte FROM osc.tb_participacao_social_conselho GROUP BY ft_conselho UNION 
	SELECT ft_tipo_participacao AS nome_fonte FROM osc.tb_participacao_social_conselho GROUP BY ft_tipo_participacao UNION 
	SELECT ft_periodicidade_reuniao AS nome_fonte FROM osc.tb_participacao_social_conselho GROUP BY ft_periodicidade_reuniao UNION 
	SELECT ft_data_inicio_conselho AS nome_fonte FROM osc.tb_participacao_social_conselho GROUP BY ft_data_inicio_conselho UNION 
	SELECT ft_data_fim_conselho AS nome_fonte FROM osc.tb_participacao_social_conselho GROUP BY ft_data_fim_conselho UNION 

	-- tb_representante_conselho
	SELECT ft_nome_representante_conselho AS nome_fonte FROM osc.tb_representante_conselho GROUP BY ft_nome_representante_conselho UNION 

	-- tb_participacao_social_outra
	SELECT ft_participacao_social_outra AS nome_fonte FROM osc.tb_participacao_social_outra GROUP BY ft_participacao_social_outra UNION 

	-- tb_recursos_osc
	SELECT ft_fonte_recursos_osc AS nome_fonte FROM osc.tb_recursos_osc GROUP BY ft_fonte_recursos_osc UNION 
	SELECT ft_ano_recursos_osc AS nome_fonte FROM osc.tb_recursos_osc GROUP BY ft_ano_recursos_osc UNION 
	SELECT ft_valor_recursos_osc AS nome_fonte FROM osc.tb_recursos_osc GROUP BY ft_valor_recursos_osc UNION 

	-- tb_projeto
	SELECT ft_nome_projeto AS nome_fonte FROM osc.tb_projeto GROUP BY ft_nome_projeto UNION 
	SELECT ft_status_projeto AS nome_fonte FROM osc.tb_projeto GROUP BY ft_status_projeto UNION 
	SELECT ft_data_inicio_projeto AS nome_fonte FROM osc.tb_projeto GROUP BY ft_data_inicio_projeto UNION 
	SELECT ft_data_fim_projeto AS nome_fonte FROM osc.tb_projeto GROUP BY ft_data_fim_projeto UNION 
	SELECT ft_link_projeto AS nome_fonte FROM osc.tb_projeto GROUP BY ft_link_projeto UNION 
	SELECT ft_total_beneficiarios AS nome_fonte FROM osc.tb_projeto GROUP BY ft_total_beneficiarios UNION 
	SELECT ft_valor_captado_projeto AS nome_fonte FROM osc.tb_projeto GROUP BY ft_valor_captado_projeto UNION 
	SELECT ft_valor_total_projeto AS nome_fonte FROM osc.tb_projeto GROUP BY ft_valor_total_projeto UNION 
	SELECT ft_abrangencia_projeto AS nome_fonte FROM osc.tb_projeto GROUP BY ft_abrangencia_projeto UNION 
	SELECT ft_zona_atuacao_projeto AS nome_fonte FROM osc.tb_projeto GROUP BY ft_zona_atuacao_projeto UNION 
	SELECT ft_descricao_projeto AS nome_fonte FROM osc.tb_projeto GROUP BY ft_descricao_projeto UNION 
	SELECT ft_metodologia_monitoramento AS nome_fonte FROM osc.tb_projeto GROUP BY ft_metodologia_monitoramento UNION 
	SELECT ft_identificador_projeto_externo AS nome_fonte FROM osc.tb_projeto GROUP BY ft_identificador_projeto_externo UNION 
	--SELECT ft_municipio AS nome_fonte FROM osc.tb_projeto GROUP BY ft_municipio UNION 
	--SELECT ft_uf AS nome_fonte FROM osc.tb_projeto GROUP BY ft_uf UNION 

	-- tb_area_atuacao_projeto
	SELECT ft_area_atuacao_projeto AS nome_fonte FROM osc.tb_area_atuacao_projeto GROUP BY ft_area_atuacao_projeto UNION 

	-- tb_localizacao_projeto
	SELECT ft_regiao_localizacao_projeto AS nome_fonte FROM osc.tb_localizacao_projeto GROUP BY ft_regiao_localizacao_projeto UNION 
	SELECT ft_nome_regiao_localizacao_projeto AS nome_fonte FROM osc.tb_localizacao_projeto GROUP BY ft_nome_regiao_localizacao_projeto UNION 
	SELECT ft_localizacao_prioritaria AS nome_fonte FROM osc.tb_localizacao_projeto GROUP BY ft_localizacao_prioritaria UNION 

	-- tb_fonte_recursos_projeto
	SELECT ft_fonte_recursos_projeto AS nome_fonte FROM osc.tb_fonte_recursos_projeto GROUP BY ft_fonte_recursos_projeto UNION 
	--SELECT ft_tipo_parceria AS nome_fonte FROM osc.tb_fonte_recursos_projeto GROUP BY ft_tipo_parceria UNION 
	--SELECT ft_orgao_concedente AS nome_fonte FROM osc.tb_fonte_recursos_projeto GROUP BY ft_orgao_concedente UNION 

	-- tb_financiador_projeto
	SELECT ft_nome_financiador AS nome_fonte FROM osc.tb_financiador_projeto GROUP BY ft_nome_financiador UNION 

	-- tb_objetivo_projeto
	SELECT ft_objetivo_projeto AS nome_fonte FROM osc.tb_objetivo_projeto GROUP BY ft_objetivo_projeto UNION 

	-- tb_osc_parceira_projeto
	SELECT ft_osc_parceira_projeto AS nome_fonte FROM osc.tb_osc_parceira_projeto GROUP BY ft_osc_parceira_projeto UNION 

	-- tb_publico_beneficiado_projeto
	--SELECT ft_publico_beneficiado AS nome_fonte FROM osc.tb_publico_beneficiado_projeto GROUP BY ft_publico_beneficiado UNION 
	SELECT ft_publico_beneficiado_projeto AS nome_fonte FROM osc.tb_publico_beneficiado_projeto GROUP BY ft_publico_beneficiado_projeto
) AS fonte_dados ON dc_fonte_dados.cd_sigla_fonte_dados = fonte_dados.nome_fonte 
WHERE dc_fonte_dados.cd_sigla_fonte_dados IS NOT null OR fonte_dados.nome_fonte IS NOT null 
ORDER BY dc_fonte_dados.cd_sigla_fonte_dados, fonte_dados.nome_fonte;

/*

Resultado:

"FNDCT/FINEP";"FNDCT/FINEP"
"MCID/MCMV-E";""
"MDS/Base";""
"MDS/CEBAS";""
"MDS/Censo SUAS";""
"MEC/CEBAS";"MEC/CEBAS"
"MESP/LIE";""
"MINC/SALICWEB";"MINC/SALICWEB"
"MJ/CNES/OSCIP";"MJ/CNES/OSCIP"
"MJ/CNES/UPF";""
"MMA/CNEA";"MMA/CNEA"
"MPOG/SICONV";"MPOG/SICONV"
"MS/CEBAS";""
"MS/SUS";"MS/SUS"
"MTE/RAIS";"MTE/RAIS"
"Representate";""
"SGPR/Conselhos";""
"";"1"
"";"3"
"";"CADSOL/MTE"
"";"CEBAS/MDSA"
"";"CEBAS/MS"
"";"CNEAS/MDS"
"";"CNES/MS"
"";"CNIS/MPS"
"";"MS/AS"
"";"RAIS/MTE"
"";"Representante"

*/
