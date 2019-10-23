ALTER TABLE osc.tb_dados_gerais DISABLE TRIGGER ALL;

UPDATE osc.tb_dados_gerais SET ft_nome_fantasia_osc = null WHERE ft_nome_fantasia_osc is not null and ft_nome_fantasia_osc <> 'Representante de OSC' and tx_nome_fantasia_osc is null;
UPDATE osc.tb_dados_gerais SET ft_logo = null WHERE ft_logo is not null and ft_logo <> 'Representante de OSC' and im_logo is null;
UPDATE osc.tb_dados_gerais SET ft_missao_osc = null WHERE ft_missao_osc is not null and ft_missao_osc <> 'Representante de OSC' and tx_missao_osc is null;
UPDATE osc.tb_dados_gerais SET ft_visao_osc = null WHERE ft_visao_osc is not null and ft_visao_osc <> 'Representante de OSC' and tx_visao_osc is null;
UPDATE osc.tb_dados_gerais SET ft_sigla_osc = null WHERE ft_sigla_osc is not null and ft_sigla_osc <> 'Representante de OSC' and tx_sigla_osc is null;
UPDATE osc.tb_dados_gerais SET ft_resumo_osc = null WHERE ft_resumo_osc is not null and ft_resumo_osc <> 'Representante de OSC' and tx_resumo_osc is null;
UPDATE osc.tb_dados_gerais SET ft_situacao_imovel_osc = null WHERE ft_situacao_imovel_osc is not null and ft_situacao_imovel_osc <> 'Representante de OSC' and cd_situacao_imovel_osc is null;
UPDATE osc.tb_dados_gerais SET ft_link_estatuto_osc = null WHERE ft_link_estatuto_osc is not null and ft_link_estatuto_osc <> 'Representante de OSC' and tx_link_estatuto_osc is null;
UPDATE osc.tb_dados_gerais SET ft_historico = null WHERE ft_historico is not null and ft_historico <> 'Representante de OSC' and tx_historico is null;
UPDATE osc.tb_dados_gerais SET ft_finalidades_estatutarias = null WHERE ft_finalidades_estatutarias is not null and ft_finalidades_estatutarias <> 'Representante de OSC' and tx_finalidades_estatutarias is null;
UPDATE osc.tb_dados_gerais SET ft_link_relatorio_auditoria = null WHERE ft_link_relatorio_auditoria is not null and ft_link_relatorio_auditoria <> 'Representante de OSC' and tx_link_relatorio_auditoria is null;
UPDATE osc.tb_dados_gerais SET ft_link_demonstracao_contabil = null WHERE ft_link_demonstracao_contabil is not null and ft_link_demonstracao_contabil <> 'Representante de OSC' and tx_link_demonstracao_contabil is null;
UPDATE osc.tb_dados_gerais SET ft_nome_responsavel_legal = null WHERE ft_nome_responsavel_legal is not null and ft_nome_responsavel_legal <> 'Representante de OSC' and tx_nome_responsavel_legal is null;

ALTER TABLE osc.tb_dados_gerais ENABLE TRIGGER ALL;