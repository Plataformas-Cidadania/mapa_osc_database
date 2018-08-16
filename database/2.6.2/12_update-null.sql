UPDATE osc.tb_dados_gerais 
SET ft_nome_fantasia_osc = null
where (tx_nome_fantasia_osc is null or tx_nome_fantasia_osc ilike '') and ft_nome_fantasia_osc not ilike '%Repre%' ;

UPDATE osc.tb_dados_gerais 
SET ft_logo = null
where (im_logo is null or im_logo ilike '') and ft_logo not ilike '%Repre%' ;

UPDATE osc.tb_dados_gerais 
SET ft_sigla_osc = null
where (tx_sigla_osc is null or tx_sigla_osc ilike '') and ft_sigla_osc not ilike '%Repre%' ;

UPDATE osc.tb_osc 
SET ft_apelido_osc = null
where (tx_apelido_osc is null or tx_apelido_osc ilike '') and ft_apelido_osc not ilike '%Repre%' ;

UPDATE osc.tb_dados_gerais 
SET ft_missao_osc = null
where (tx_missao_osc is null or tx_missao_osc ilike '') and ft_missao_osc not ilike '%Repre%' ;

UPDATE osc.tb_dados_gerais 
SET ft_visao_osc = null
where (tx_visao_osc is null or tx_visao_osc ilike '') and ft_visao_osc not ilike '%Repre%';

UPDATE osc.tb_dados_gerais 
SET ft_fundacao_osc = null
where dt_fundacao_osc is null and ft_fundacao_osc  not ilike '%Repre%';

UPDATE osc.tb_dados_gerais 
SET ft_ano_cadastro_cnpj = null
where dt_ano_cadastro_cnpj is null and ft_ano_cadastro_cnpj  not ilike '%Repre%';

UPDATE osc.tb_dados_gerais 
SET ft_resumo_osc = null
where (tx_resumo_osc is null or tx_resumo_osc ilike '') and ft_resumo_osc  not ilike '%Repre%';

UPDATE osc.tb_dados_gerais 
SET ft_situacao_imovel_osc = null
where cd_situacao_imovel_osc is null and ft_situacao_imovel_osc not ilike '%Repre%';

UPDATE osc.tb_dados_gerais 
SET ft_link_estatuto_osc = null
where (tx_link_estatuto_osc is null or tx_link_estatuto_osc ilike '') and ft_link_estatuto_osc not ilike '%Repre%';

UPDATE osc.tb_dados_gerais 
SET ft_historico = null
where (tx_historico is null or tx_historico ilike '') and ft_historico not ilike '%Repre%';

UPDATE osc.tb_dados_gerais 
SET ft_finalidades_estatutarias = null
where (tx_finalidades_estatutarias is null or tx_finalidades_estatutarias ilike '' ) and ft_finalidades_estatutarias not ilike '%Repre%';

UPDATE osc.tb_dados_gerais 
SET ft_link_relatorio_auditoria = null
where (tx_link_relatorio_auditoria is null or tx_link_relatorio_auditoria ilike '' ) and ft_link_relatorio_auditoria not ilike '%Repre%';

UPDATE osc.tb_dados_gerais 
SET ft_link_demonstracao_contabil = null
where (tx_link_demonstracao_contabil is null or tx_link_demonstracao_contabil ilike '' ) and ft_link_demonstracao_contabil not ilike '%Repre%';

UPDATE osc.tb_dados_gerais 
SET ft_nome_responsavel_legal = null
where (tx_nome_responsavel_legal is null or tx_nome_responsavel_legal ilike '' ) and ft_nome_responsavel_legal not ilike '%Repre%';

UPDATE osc.tb_dados_gerais 
SET ft_classe_atividade_economica_osc = null
where (cd_classe_atividade_economica_osc is null ) and ft_classe_atividade_economica_osc not ilike '%Repre%';

UPDATE osc.tb_contato 
SET ft_telefone = null
where ( tx_telefone is null or tx_telefone  ilike '' or  tx_telefone ilike 'NA' ) and ft_telefone  not ilike '%Repre%';

UPDATE osc.tb_contato 
SET ft_email = null
where ( tx_email is null or tx_email  ilike '' or  tx_email ilike 'NA' ) and ft_email  not ilike '%Repre%';

UPDATE osc.tb_contato 
SET ft_representante = null
where ( nm_representante is null or nm_representante  ilike '' or  nm_representante ilike 'NA' ) and ft_representante  not ilike '%Repre%';

UPDATE osc.tb_contato 
SET ft_site = null
where ( tx_site is null or tx_site  ilike '' ) and ft_site  not ilike '%Repre%';

UPDATE osc.tb_contato 
SET ft_facebook = null
where ( tx_facebook is null or tx_facebook  ilike '' ) and ft_facebook  not ilike '%Repre%';

UPDATE osc.tb_contato 
SET ft_google = null
where ( tx_google is null or tx_google  ilike '' ) and ft_google  not ilike '%Repre%';

UPDATE osc.tb_contato 
SET ft_linkedin = null
where ( tx_linkedin is null or tx_linkedin  ilike '' ) and ft_linkedin  not ilike '%Repre%';

UPDATE osc.tb_contato 
SET ft_twitter = null
where ( tx_twitter is null or tx_twitter  ilike '' ) and ft_twitter  not ilike '%Repre%';



