DROP FUNCTION IF EXISTS portal.atualizar_dados_gerais_osc(fonte TEXT, osc INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN);

CREATE OR REPLACE FUNCTION portal.atualizar_dados_gerais_osc(fonte TEXT, osc INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$

DECLARE 
	nome_tabela TEXT;
	operacao TEXT;
	fonte_dados RECORD;
	objeto RECORD;
	registro_anterior RECORD;
	registro_posterior RECORD;
	flag_log BOOLEAN;
	
BEGIN 
	nome_tabela := 'osc.atualizar_dados_gerais';
	operacao := 'portal.atualizar_dados_gerais_osc(' || fonte::TEXT || ', ' || osc::TEXT || ', ' || dataatualizacao::TEXT || ', ' || json::TEXT || ', ' || nullvalido::TEXT || ', ' || errolog::TEXT || ')';
	
	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);
	
	IF fonte_dados.nome_fonte IS null THEN 
		flag := false;
		mensagem := 'Fonte de dados inválida.';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT || ' Operação: ' || operacao, dataatualizacao::TIMESTAMP);
		END IF;
	
	ELSIF osc != ALL(fonte_dados.representacao) THEN 
		flag := false;
		mensagem := 'Usuário não tem permissão para acessar este conteúdo.';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT || ' Operação: ' || operacao, dataatualizacao::TIMESTAMP);
		END IF;
	
	ELSE 
		SELECT INTO objeto * 
		FROM json_populate_record(null::osc.tb_dados_gerais, json::JSON);
		
		SELECT INTO registro_anterior * 
		FROM osc.tb_dados_gerais 
		WHERE id_osc = objeto.id_osc;
		
		IF COUNT(registro_anterior) = 0 THEN 
			INSERT INTO osc.tb_dados_gerais (
				id_osc, 
				cd_natureza_juridica_osc, 
				ft_natureza_juridica_osc, 
				cd_subclasse_atividade_economica_osc, 
				ft_subclasse_atividade_economica_osc, 
				tx_razao_social_osc, 
				ft_razao_social_osc, 
				tx_nome_fantasia_osc, 
				ft_nome_fantasia_osc, 
				im_logo, 
				ft_logo, 
				tx_missao_osc, 
				ft_missao_osc, 
				tx_visao_osc, 
				ft_visao_osc, 
				dt_fundacao_osc, 
				ft_fundacao_osc, 
				dt_ano_cadastro_cnpj, 
				ft_ano_cadastro_cnpj, 
				tx_sigla_osc, 
				ft_sigla_osc, 
				tx_resumo_osc, 
				ft_resumo_osc, 
				cd_situacao_imovel_osc, 
				ft_situacao_imovel_osc, 
				tx_link_estatuto_osc, 
				ft_link_estatuto_osc, 
				tx_historico, 
				ft_historico, 
				tx_finalidades_estatutarias, 
				ft_finalidades_estatutarias, 
				tx_link_relatorio_auditoria, 
				ft_link_relatorio_auditoria, 
				tx_link_demonstracao_contabil, 
				ft_link_demonstracao_contabil, 
				tx_nome_responsavel_legal, 
				ft_nome_responsavel_legal
			) VALUES (
				objeto.id_osc, 
				objeto.cd_natureza_juridica_osc, 
				fonte_dados.nome_fonte, 
				objeto.cd_subclasse_atividade_economica_osc, 
				fonte_dados.nome_fonte, 
				objeto.tx_razao_social_osc, 
				fonte_dados.nome_fonte, 
				objeto.tx_nome_fantasia_osc, 
				fonte_dados.nome_fonte, 
				objeto.im_logo, 
				fonte_dados.nome_fonte, 
				objeto.tx_missao_osc, 
				fonte_dados.nome_fonte, 
				objeto.tx_visao_osc, 
				fonte_dados.nome_fonte, 
				objeto.dt_fundacao_osc, 
				fonte_dados.nome_fonte, 
				objeto.dt_ano_cadastro_cnpj, 
				fonte_dados.nome_fonte, 
				objeto.tx_sigla_osc, 
				fonte_dados.nome_fonte, 
				objeto.tx_resumo_osc, 
				fonte_dados.nome_fonte, 
				objeto.cd_situacao_imovel_osc, 
				fonte_dados.nome_fonte, 
				objeto.tx_link_estatuto_osc, 
				fonte_dados.nome_fonte, 
				objeto.tx_historico, 
				fonte_dados.nome_fonte, 
				objeto.tx_finalidades_estatutarias, 
				fonte_dados.nome_fonte, 
				objeto.tx_link_relatorio_auditoria, 
				fonte_dados.nome_fonte, 
				objeto.tx_link_demonstracao_contabil, 
				fonte_dados.nome_fonte, 
				tx_nome_responsavel_legal, 
				fonte_dados.nome_fonte
			) RETURNING * INTO registro_posterior;
			
			INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
			VALUES (nome_tabela, registro_posterior.id_osc, fonte::INTEGER, dataatualizacao, null, row_to_json(registro_posterior));
			
		ELSE 
			registro_posterior := registro_anterior;
			flag_log := false;
			
			IF (
				(nullvalido = true AND registro_anterior.cd_natureza_juridica_osc <> objeto.cd_natureza_juridica_osc) 
				OR (nullvalido = false AND registro_anterior.cd_natureza_juridica_osc <> objeto.cd_natureza_juridica_osc AND (objeto.cd_natureza_juridica_osc::TEXT = '') IS FALSE)
			) AND (
				registro_anterior.ft_natureza_juridica_osc IS null 
				OR fonte_dados.prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = registro_anterior.ft_natureza_juridica_osc)
			) THEN 
				registro_posterior.cd_natureza_juridica_osc := objeto.cd_natureza_juridica_osc;
				registro_posterior.ft_natureza_juridica_osc := fonte_dados.nome_fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.cd_subclasse_atividade_economica_osc <> objeto.cd_subclasse_atividade_economica_osc) 
				OR (nullvalido = false AND registro_anterior.cd_subclasse_atividade_economica_osc <> objeto.cd_subclasse_atividade_economica_osc AND (objeto.cd_subclasse_atividade_economica_osc::TEXT = '') IS FALSE)
			) AND (
				registro_anterior.ft_subclasse_atividade_economica_osc IS null 
				OR fonte_dados.prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = registro_anterior.ft_subclasse_atividade_economica_osc)
			) THEN 
				registro_posterior.cd_subclasse_atividade_economica_osc := objeto.cd_subclasse_atividade_economica_osc;
				registro_posterior.ft_subclasse_atividade_economica_osc := fonte_dados.nome_fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_razao_social_osc <> objeto.tx_razao_social_osc) 
				OR (nullvalido = false AND registro_anterior.tx_razao_social_osc <> objeto.tx_razao_social_osc AND (objeto.tx_razao_social_osc::TEXT = '') IS FALSE)
			) AND (
				registro_anterior.ft_razao_social_osc IS null 
				OR fonte_dados.prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = registro_anterior.ft_razao_social_osc)
			) THEN 
				registro_posterior.tx_razao_social_osc := objeto.tx_razao_social_osc;
				registro_posterior.ft_razao_social_osc := fonte_dados.nome_fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_nome_fantasia_osc <> objeto.tx_nome_fantasia_osc) 
				OR (nullvalido = false AND registro_anterior.tx_nome_fantasia_osc <> objeto.tx_nome_fantasia_osc AND (objeto.tx_nome_fantasia_osc::TEXT = '') IS FALSE)
			) AND (
				registro_anterior.ft_nome_fantasia_osc IS null 
				OR fonte_dados.prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = registro_anterior.ft_nome_fantasia_osc)
			) THEN 
				registro_posterior.tx_nome_fantasia_osc := objeto.tx_nome_fantasia_osc;
				registro_posterior.ft_nome_fantasia_osc := fonte_dados.nome_fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.im_logo <> objeto.im_logo) 
				OR (nullvalido = false AND registro_anterior.im_logo <> objeto.im_logo AND (objeto.im_logo::TEXT = '') IS FALSE)
			) AND (
				registro_anterior.ft_logo IS null 
				OR fonte_dados.prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = registro_anterior.ft_logo)
			) THEN 
				registro_posterior.im_logo := objeto.im_logo;
				registro_posterior.ft_logo := fonte_dados.nome_fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_missao_osc <> objeto.tx_missao_osc) 
				OR (nullvalido = false AND registro_anterior.tx_missao_osc <> objeto.tx_missao_osc AND (objeto.tx_missao_osc::TEXT = '') IS FALSE)
			) AND (
				registro_anterior.ft_missao_osc IS null 
				OR fonte_dados.prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = registro_anterior.ft_missao_osc)
			) THEN 
				registro_posterior.tx_missao_osc := objeto.tx_missao_osc;
				registro_posterior.ft_missao_osc := fonte_dados.nome_fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_visao_osc <> objeto.tx_visao_osc) 
				OR (nullvalido = false AND registro_anterior.tx_visao_osc <> objeto.tx_visao_osc AND (objeto.tx_visao_osc::TEXT = '') IS FALSE)
			) AND (
				registro_anterior.ft_visao_osc IS null 
				OR fonte_dados.prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = registro_anterior.ft_visao_osc)
			) THEN 
				registro_posterior.tx_visao_osc := objeto.tx_visao_osc;
				registro_posterior.ft_visao_osc := fonte_dados.nome_fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.dt_fundacao_osc <> objeto.dt_fundacao_osc) 
				OR (nullvalido = false AND registro_anterior.dt_fundacao_osc <> objeto.dt_fundacao_osc AND (objeto.dt_fundacao_osc::TEXT = '') IS FALSE)
			) AND (
				registro_anterior.ft_fundacao_osc IS null 
				OR fonte_dados.prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = registro_anterior.ft_fundacao_osc)
			) THEN 
				registro_posterior.dt_fundacao_osc := objeto.dt_fundacao_osc;
				registro_posterior.ft_fundacao_osc := fonte_dados.nome_fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.dt_ano_cadastro_cnpj <> objeto.dt_ano_cadastro_cnpj) 
				OR (nullvalido = false AND registro_anterior.dt_ano_cadastro_cnpj <> objeto.dt_ano_cadastro_cnpj AND (objeto.dt_ano_cadastro_cnpj::TEXT = '') IS FALSE)
			) AND (
				registro_anterior.ft_ano_cadastro_cnpj IS null 
				OR fonte_dados.prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = registro_anterior.ft_ano_cadastro_cnpj)
			) THEN 
				registro_posterior.dt_ano_cadastro_cnpj := objeto.dt_ano_cadastro_cnpj;
				registro_posterior.ft_ano_cadastro_cnpj := fonte_dados.nome_fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_sigla_osc <> objeto.tx_sigla_osc) 
				OR (nullvalido = false AND registro_anterior.tx_sigla_osc <> objeto.tx_sigla_osc AND (objeto.tx_sigla_osc::TEXT = '') IS FALSE)
			) AND (
				registro_anterior.ft_sigla_osc IS null 
				OR fonte_dados.prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = registro_anterior.ft_sigla_osc)
			) THEN 
				registro_posterior.tx_sigla_osc := objeto.tx_sigla_osc;
				registro_posterior.ft_sigla_osc := fonte_dados.nome_fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_resumo_osc <> objeto.tx_resumo_osc) 
				OR (nullvalido = false AND registro_anterior.tx_resumo_osc <> objeto.tx_resumo_osc AND (objeto.tx_resumo_osc::TEXT = '') IS FALSE)
			) AND (
				registro_anterior.ft_resumo_osc IS null 
				OR fonte_dados.prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = registro_anterior.ft_resumo_osc)
			) THEN 
				registro_posterior.tx_resumo_osc := objeto.tx_resumo_osc;
				registro_posterior.ft_resumo_osc := fonte_dados.nome_fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.cd_situacao_imovel_osc <> objeto.cd_situacao_imovel_osc) 
				OR (nullvalido = false AND registro_anterior.cd_situacao_imovel_osc <> objeto.cd_situacao_imovel_osc AND (objeto.cd_situacao_imovel_osc::TEXT = '') IS FALSE)
			) AND (
				registro_anterior.ft_situacao_imovel_osc IS null 
				OR fonte_dados.prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = registro_anterior.ft_situacao_imovel_osc)
			) THEN 
				registro_posterior.cd_situacao_imovel_osc := objeto.cd_situacao_imovel_osc;
				registro_posterior.ft_situacao_imovel_osc := fonte_dados.nome_fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_link_estatuto_osc <> objeto.tx_link_estatuto_osc) 
				OR (nullvalido = false AND registro_anterior.tx_link_estatuto_osc <> objeto.tx_link_estatuto_osc AND (objeto.tx_link_estatuto_osc::TEXT = '') IS FALSE)
			) AND (
				registro_anterior.ft_link_estatuto_osc IS null 
				OR fonte_dados.prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = registro_anterior.ft_link_estatuto_osc)
			) THEN 
				registro_posterior.tx_link_estatuto_osc := objeto.tx_link_estatuto_osc;
				registro_posterior.ft_link_estatuto_osc := fonte_dados.nome_fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_historico <> objeto.tx_historico) 
				OR (nullvalido = false AND registro_anterior.tx_historico <> objeto.tx_historico AND (objeto.tx_historico::TEXT = '') IS FALSE)
			) AND (
				registro_anterior.ft_historico IS null 
				OR fonte_dados.prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = registro_anterior.ft_historico)
			) THEN 
				registro_posterior.tx_historico := objeto.tx_historico;
				registro_posterior.ft_historico := fonte_dados.nome_fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_finalidades_estatutarias <> objeto.tx_finalidades_estatutarias) 
				OR (nullvalido = false AND registro_anterior.tx_finalidades_estatutarias <> objeto.tx_finalidades_estatutarias AND (objeto.tx_finalidades_estatutarias::TEXT = '') IS FALSE)
			) AND (
				registro_anterior.ft_finalidades_estatutarias IS null 
				OR fonte_dados.prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = registro_anterior.ft_finalidades_estatutarias)
			) THEN 
				registro_posterior.tx_finalidades_estatutarias := objeto.tx_finalidades_estatutarias;
				registro_posterior.ft_finalidades_estatutarias := fonte_dados.nome_fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_link_relatorio_auditoria <> objeto.tx_link_relatorio_auditoria) 
				OR (nullvalido = false AND registro_anterior.tx_link_relatorio_auditoria <> objeto.tx_link_relatorio_auditoria AND (objeto.tx_link_relatorio_auditoria::TEXT = '') IS FALSE)
			) AND (
				registro_anterior.ft_link_relatorio_auditoria IS null 
				OR fonte_dados.prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = registro_anterior.ft_link_relatorio_auditoria)
			) THEN 
				registro_posterior.tx_link_relatorio_auditoria := objeto.tx_link_relatorio_auditoria;
				registro_posterior.ft_link_relatorio_auditoria := fonte_dados.nome_fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_link_demonstracao_contabil <> objeto.tx_link_demonstracao_contabil) 
				OR (nullvalido = false AND registro_anterior.tx_link_demonstracao_contabil <> objeto.tx_link_demonstracao_contabil AND (objeto.tx_link_demonstracao_contabil::TEXT = '') IS FALSE)
			) AND (
				registro_anterior.ft_link_demonstracao_contabil IS null 
				OR fonte_dados.prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = registro_anterior.ft_link_demonstracao_contabil)
			) THEN 
				registro_posterior.tx_link_demonstracao_contabil := objeto.tx_link_demonstracao_contabil;
				registro_posterior.ft_link_demonstracao_contabil := fonte_dados.nome_fonte;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_nome_responsavel_legal <> objeto.tx_nome_responsavel_legal) 
				OR (nullvalido = false AND registro_anterior.tx_nome_responsavel_legal <> objeto.tx_nome_responsavel_legal AND (objeto.tx_nome_responsavel_legal::TEXT = '') IS FALSE)
			) AND (
				registro_anterior.ft_nome_responsavel_legal IS null 
				OR fonte_dados.prioridade <= (SELECT nr_prioridade FROM syst.dc_fonte_dados WHERE cd_sigla_fonte_dados = registro_anterior.ft_nome_responsavel_legal)
			) THEN 
				registro_posterior.tx_nome_responsavel_legal := objeto.tx_nome_responsavel_legal;
				registro_posterior.ft_nome_responsavel_legal := fonte_dados.nome_fonte;
				flag_log := true;
			END IF;
			
			IF flag_log THEN 
				
				UPDATE osc.tb_dados_gerais 
				SET cd_natureza_juridica_osc = registro_posterior.cd_natureza_juridica_osc, 
					ft_natureza_juridica_osc = registro_posterior.ft_natureza_juridica_osc, 
					cd_subclasse_atividade_economica_osc = registro_posterior.cd_subclasse_atividade_economica_osc, 
					ft_subclasse_atividade_economica_osc = registro_posterior.ft_subclasse_atividade_economica_osc, 
					tx_razao_social_osc = registro_posterior.tx_razao_social_osc, 
					ft_razao_social_osc = registro_posterior.ft_razao_social_osc, 
					tx_nome_fantasia_osc = registro_posterior.tx_nome_fantasia_osc, 
					ft_nome_fantasia_osc = registro_posterior.ft_nome_fantasia_osc, 
					im_logo = registro_posterior.im_logo, 
					ft_logo = registro_posterior.ft_logo, 
					tx_missao_osc = registro_posterior.tx_missao_osc, 
					ft_missao_osc = registro_posterior.ft_missao_osc, 
					tx_visao_osc = registro_posterior.tx_visao_osc, 
					ft_visao_osc = registro_posterior.ft_visao_osc, 
					dt_fundacao_osc = registro_posterior.dt_fundacao_osc, 
					ft_fundacao_osc = registro_posterior.ft_fundacao_osc, 
					dt_ano_cadastro_cnpj = registro_posterior.dt_ano_cadastro_cnpj, 
					ft_ano_cadastro_cnpj = registro_posterior.ft_ano_cadastro_cnpj, 
					tx_sigla_osc = registro_posterior.tx_sigla_osc, 
					ft_sigla_osc = registro_posterior.ft_sigla_osc, 
					tx_resumo_osc = registro_posterior.tx_resumo_osc, 
					ft_resumo_osc = registro_posterior.ft_resumo_osc, 
					cd_situacao_imovel_osc = registro_posterior.cd_situacao_imovel_osc, 
					ft_situacao_imovel_osc = registro_posterior.ft_situacao_imovel_osc, 
					tx_link_estatuto_osc = registro_posterior.tx_link_estatuto_osc, 
					ft_link_estatuto_osc = registro_posterior.ft_link_estatuto_osc, 
					tx_historico = registro_posterior.tx_historico, 
					ft_historico = registro_posterior.ft_historico, 
					tx_finalidades_estatutarias = registro_posterior.tx_finalidades_estatutarias, 
					ft_finalidades_estatutarias = registro_posterior.ft_finalidades_estatutarias, 
					tx_link_relatorio_auditoria = registro_posterior.tx_link_relatorio_auditoria, 
					ft_link_relatorio_auditoria = registro_posterior.ft_link_relatorio_auditoria, 
					tx_link_demonstracao_contabil = registro_posterior.tx_link_demonstracao_contabil, 
					ft_link_demonstracao_contabil = registro_posterior.ft_link_demonstracao_contabil, 
					tx_nome_responsavel_legal = registro_posterior.tx_nome_responsavel_legal, 
					ft_nome_responsavel_legal = registro_posterior.ft_nome_responsavel_legal 
				WHERE id_osc = registro_posterior.id_osc;
				
				INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
				VALUES (nome_tabela, registro_posterior.id_osc, fonte::INTEGER, dataatualizacao, row_to_json(registro_anterior), row_to_json(registro_posterior));
				
			END IF;
		END IF;
		
		flag := true;
		mensagem := 'Dados gerais de OSC atualizado.';
	END IF;
	
	RETURN NEXT;

EXCEPTION 
	WHEN not_null_violation THEN 
		flag := false;
		mensagem := 'Dado(s) obrigatório(s) não enviado(s).';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT || ' Operação: ' || operacao, dataatualizacao::TIMESTAMP);
		END IF;
		
		RETURN NEXT;
		
	WHEN unique_violation THEN 
		flag := false;
		mensagem := 'Dado(s) único(s) violado(s).';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT || ' Operação: ' || operacao, dataatualizacao::TIMESTAMP);
		END IF;
		
		RETURN NEXT;
		
	WHEN foreign_key_violation THEN 
		flag := false;
		mensagem := 'Dado(s) com chave(s) estrangeira(s) violada(s).';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT || ' Operação: ' || operacao, dataatualizacao::TIMESTAMP);
		END IF;
		
		RETURN NEXT;
		
	WHEN others THEN  
		flag := false;
		mensagem := 'Ocorreu um erro.';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT || ' Operação: ' || operacao, dataatualizacao::TIMESTAMP);
		END IF;
		
		RETURN NEXT;

END; 
$$ LANGUAGE 'plpgsql';

--SELECT * FROM portal.atualizar_dados_gerais_osc('2'::TEXT, 987654::INTEGER, '2017-10-20'::TIMESTAMP, '{"id_osc": 987654, "tx_razao_social_osc": "Teste", "tx_nome_fantasia_osc": "OrgTeste"}'::JSONB, false, false);
