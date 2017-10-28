DROP FUNCTION IF EXISTS portal.atualizar_dados_gerais_osc(fonte TEXT, osc INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN);

CREATE OR REPLACE FUNCTION portal.atualizar_dados_gerais_osc(fonte TEXT, osc INTEGER, dataatualizacao TIMESTAMP, json JSONB, nullvalido BOOLEAN, errolog BOOLEAN) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$

DECLARE 
	fonte_dados_nao_oficiais TEXT[];
	tipo_usuario TEXT;
	objeto RECORD;
	registro_anterior RECORD;
	registro_posterior RECORD;
	flag_log BOOLEAN;
	
BEGIN 
	SELECT INTO tipo_usuario (
		SELECT dc_tipo_usuario.tx_nome_tipo_usuario 
		FROM portal.tb_usuario 
		INNER JOIN syst.dc_tipo_usuario 
		ON tb_usuario.cd_tipo_usuario = dc_tipo_usuario.cd_tipo_usuario 
		WHERE tb_usuario.id_usuario::TEXT = fonte 
		UNION 
		SELECT cd_sigla_fonte_dados 
		FROM syst.dc_fonte_dados 
		WHERE dc_fonte_dados.cd_sigla_fonte_dados::TEXT = fonte
	);
	
	IF tipo_usuario IS null THEN 
		flag := false;
		mensagem := 'Fonte de dados inválida.';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT, dataatualizacao::TIMESTAMP);
		END IF;
		
	ELSE 
		SELECT INTO fonte_dados_nao_oficiais array_agg(tx_nome_tipo_usuario) 
		FROM syst.dc_tipo_usuario;
		
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
				tipo_usuario, 
				objeto.cd_subclasse_atividade_economica_osc, 
				tipo_usuario, 
				objeto.tx_razao_social_osc, 
				tipo_usuario, 
				objeto.tx_nome_fantasia_osc, 
				tipo_usuario, 
				objeto.im_logo, 
				tipo_usuario, 
				objeto.tx_missao_osc, 
				tipo_usuario, 
				objeto.tx_visao_osc, 
				tipo_usuario, 
				objeto.dt_fundacao_osc, 
				tipo_usuario, 
				objeto.dt_ano_cadastro_cnpj, 
				tipo_usuario, 
				objeto.tx_sigla_osc, 
				tipo_usuario, 
				objeto.tx_resumo_osc, 
				tipo_usuario, 
				objeto.cd_situacao_imovel_osc, 
				tipo_usuario, 
				objeto.tx_link_estatuto_osc, 
				tipo_usuario, 
				objeto.tx_historico, 
				tipo_usuario, 
				objeto.tx_finalidades_estatutarias, 
				tipo_usuario, 
				objeto.tx_link_relatorio_auditoria, 
				tipo_usuario, 
				objeto.tx_link_demonstracao_contabil, 
				tipo_usuario, 
				tx_nome_responsavel_legal, 
				tipo_usuario
			) RETURNING * INTO registro_posterior;
			
			INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
			VALUES ('osc.atualizar_dados_gerais', registro_posterior.id_osc, fonte::INTEGER, dataatualizacao, null, row_to_json(registro_posterior));
			
		ELSE 
			registro_posterior := registro_anterior;
			flag_log := false;
			
			IF (
				(nullvalido = true AND registro_anterior.cd_natureza_juridica_osc <> objeto.cd_natureza_juridica_osc) 
				OR (nullvalido = false AND registro_anterior.cd_natureza_juridica_osc <> objeto.cd_natureza_juridica_osc AND objeto.cd_natureza_juridica_osc IS NOT null AND objeto.cd_natureza_juridica_osc != '')
			) AND (
				registro_anterior.ft_natureza_juridica_osc IS null OR registro_anterior.ft_natureza_juridica_osc = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.cd_natureza_juridica_osc := objeto.cd_natureza_juridica_osc;
				registro_posterior.ft_natureza_juridica_osc := tipo_usuario;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.cd_subclasse_atividade_economica_osc <> objeto.cd_subclasse_atividade_economica_osc) 
				OR (nullvalido = false AND registro_anterior.cd_subclasse_atividade_economica_osc <> objeto.cd_subclasse_atividade_economica_osc AND objeto.cd_subclasse_atividade_economica_osc IS NOT null AND objeto.cd_subclasse_atividade_economica_osc != '') 
			) AND (
				registro_anterior.ft_subclasse_atividade_economica_osc IS null OR registro_anterior.ft_subclasse_atividade_economica_osc = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.cd_subclasse_atividade_economica_osc := objeto.cd_subclasse_atividade_economica_osc;
				registro_posterior.ft_subclasse_atividade_economica_osc := tipo_usuario;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_razao_social_osc <> objeto.tx_razao_social_osc) 
				OR (nullvalido = false AND registro_anterior.tx_razao_social_osc <> objeto.tx_razao_social_osc AND objeto.tx_razao_social_osc IS NOT null AND objeto.tx_razao_social_osc != '')
			) AND (
				registro_anterior.ft_razao_social_osc IS null OR registro_anterior.ft_razao_social_osc = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.tx_razao_social_osc := objeto.tx_razao_social_osc;
				registro_posterior.ft_razao_social_osc := tipo_usuario;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_nome_fantasia_osc <> objeto.tx_nome_fantasia_osc) 
				OR (nullvalido = false AND registro_anterior.tx_nome_fantasia_osc <> objeto.tx_nome_fantasia_osc AND objeto.tx_nome_fantasia_osc IS NOT null AND objeto.tx_nome_fantasia_osc != '')
			) AND (
				registro_anterior.ft_nome_fantasia_osc IS null OR registro_anterior.ft_nome_fantasia_osc = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.tx_nome_fantasia_osc := objeto.tx_nome_fantasia_osc;
				registro_posterior.ft_nome_fantasia_osc := tipo_usuario;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.im_logo <> objeto.im_logo) 
				OR (nullvalido = false AND registro_anterior.im_logo <> objeto.im_logo AND objeto.im_logo IS NOT null AND objeto.im_logo != '')
			) AND (
				registro_anterior.ft_logo IS null OR registro_anterior.ft_logo = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.im_logo := objeto.im_logo;
				registro_posterior.ft_logo := tipo_usuario;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_missao_osc <> objeto.tx_missao_osc) 
				OR (nullvalido = false AND registro_anterior.tx_missao_osc <> objeto.tx_missao_osc AND objeto.tx_missao_osc IS NOT null AND objeto.tx_missao_osc != '')
			) AND (
				registro_anterior.ft_missao_osc IS null OR registro_anterior.ft_missao_osc = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.tx_missao_osc := objeto.tx_missao_osc;
				registro_posterior.ft_missao_osc := tipo_usuario;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_visao_osc <> objeto.tx_visao_osc) 
				OR (nullvalido = false AND registro_anterior.tx_visao_osc <> objeto.tx_visao_osc AND objeto.tx_visao_osc IS NOT null AND objeto.tx_visao_osc != '')
			) AND (
				registro_anterior.ft_visao_osc IS null OR registro_anterior.ft_visao_osc = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.tx_visao_osc := objeto.tx_visao_osc;
				registro_posterior.ft_visao_osc := tipo_usuario;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.dt_fundacao_osc <> objeto.dt_fundacao_osc) 
				OR (nullvalido = false AND registro_anterior.dt_fundacao_osc <> objeto.dt_fundacao_osc AND objeto.dt_fundacao_osc IS NOT null AND objeto.dt_fundacao_osc != '')
			) AND (
				registro_anterior.ft_fundacao_osc IS null OR registro_anterior.ft_fundacao_osc = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.dt_fundacao_osc := objeto.dt_fundacao_osc;
				registro_posterior.ft_fundacao_osc := tipo_usuario;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.dt_ano_cadastro_cnpj <> objeto.dt_ano_cadastro_cnpj) 
				OR (nullvalido = false AND registro_anterior.dt_ano_cadastro_cnpj <> objeto.dt_ano_cadastro_cnpj AND objeto.dt_ano_cadastro_cnpj IS NOT null AND objeto.dt_ano_cadastro_cnpj != '')
			) AND (
				registro_anterior.ft_ano_cadastro_cnpj IS null OR registro_anterior.ft_ano_cadastro_cnpj = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.dt_ano_cadastro_cnpj := objeto.dt_ano_cadastro_cnpj;
				registro_posterior.ft_ano_cadastro_cnpj := tipo_usuario;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_sigla_osc <> objeto.tx_sigla_osc) 
				OR (nullvalido = false AND registro_anterior.tx_sigla_osc <> objeto.tx_sigla_osc AND objeto.tx_sigla_osc IS NOT null AND objeto.tx_sigla_osc != '')
			) AND (
				registro_anterior.ft_sigla_osc IS null OR registro_anterior.ft_sigla_osc = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.tx_sigla_osc := objeto.tx_sigla_osc;
				registro_posterior.ft_sigla_osc := tipo_usuario;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_resumo_osc <> objeto.tx_resumo_osc) 
				OR (nullvalido = false AND registro_anterior.tx_resumo_osc <> objeto.tx_resumo_osc AND objeto.tx_resumo_osc IS NOT null AND objeto.tx_resumo_osc != '')
			) AND (
				registro_anterior.ft_resumo_osc IS null OR registro_anterior.ft_resumo_osc = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.tx_resumo_osc := objeto.tx_resumo_osc;
				registro_posterior.ft_resumo_osc := tipo_usuario;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.cd_situacao_imovel_osc <> objeto.cd_situacao_imovel_osc) 
				OR (nullvalido = false AND registro_anterior.cd_situacao_imovel_osc <> objeto.cd_situacao_imovel_osc AND objeto.cd_situacao_imovel_osc IS NOT null AND objeto.cd_situacao_imovel_osc != '')
			) AND (
				registro_anterior.ft_situacao_imovel_osc IS null OR registro_anterior.ft_situacao_imovel_osc = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.cd_situacao_imovel_osc := objeto.cd_situacao_imovel_osc;
				registro_posterior.ft_situacao_imovel_osc := tipo_usuario;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_link_estatuto_osc <> objeto.tx_link_estatuto_osc) 
				OR (nullvalido = false AND registro_anterior.tx_link_estatuto_osc <> objeto.tx_link_estatuto_osc AND objeto.tx_link_estatuto_osc IS NOT null AND objeto.tx_link_estatuto_osc != '')
			) AND (
				registro_anterior.ft_link_estatuto_osc IS null OR registro_anterior.ft_link_estatuto_osc = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.tx_link_estatuto_osc := objeto.tx_link_estatuto_osc;
				registro_posterior.ft_link_estatuto_osc := tipo_usuario;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_historico <> objeto.tx_historico) 
				OR (nullvalido = false AND registro_anterior.tx_historico <> objeto.tx_historico AND objeto.tx_historico IS NOT null AND objeto.tx_historico != '')
			) AND (
				registro_anterior.ft_historico IS null OR registro_anterior.ft_historico = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.tx_historico := objeto.tx_historico;
				registro_posterior.ft_historico := tipo_usuario;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_finalidades_estatutarias <> objeto.tx_finalidades_estatutarias) 
				OR (nullvalido = false AND registro_anterior.tx_finalidades_estatutarias <> objeto.tx_finalidades_estatutarias AND objeto.tx_finalidades_estatutarias IS NOT null AND objeto.tx_finalidades_estatutarias != '')
			) AND (
				registro_anterior.ft_finalidades_estatutarias IS null OR registro_anterior.ft_finalidades_estatutarias = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.tx_finalidades_estatutarias := objeto.tx_finalidades_estatutarias;
				registro_posterior.ft_finalidades_estatutarias := tipo_usuario;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_link_relatorio_auditoria <> objeto.tx_link_relatorio_auditoria) 
				OR (nullvalido = false AND registro_anterior.tx_link_relatorio_auditoria <> objeto.tx_link_relatorio_auditoria AND objeto.tx_link_relatorio_auditoria IS NOT null AND objeto.tx_link_relatorio_auditoria != '')
			) AND (
				registro_anterior.ft_link_relatorio_auditoria IS null OR registro_anterior.ft_link_relatorio_auditoria = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.tx_link_relatorio_auditoria := objeto.tx_link_relatorio_auditoria;
				registro_posterior.ft_link_relatorio_auditoria := tipo_usuario;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_link_demonstracao_contabil <> objeto.tx_link_demonstracao_contabil) 
				OR (nullvalido = false AND registro_anterior.tx_link_demonstracao_contabil <> objeto.tx_link_demonstracao_contabil AND objeto.tx_link_demonstracao_contabil IS NOT null AND objeto.tx_link_demonstracao_contabil != '')
			) AND (
				registro_anterior.ft_link_demonstracao_contabil IS null OR registro_anterior.ft_link_demonstracao_contabil = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.tx_link_demonstracao_contabil := objeto.tx_link_demonstracao_contabil;
				registro_posterior.ft_link_demonstracao_contabil := tipo_usuario;
				flag_log := true;
			END IF;
			
			IF (
				(nullvalido = true AND registro_anterior.tx_nome_responsavel_legal <> objeto.tx_nome_responsavel_legal) 
				OR (nullvalido = false AND registro_anterior.tx_nome_responsavel_legal <> objeto.tx_nome_responsavel_legal AND objeto.tx_nome_responsavel_legal IS NOT null AND objeto.tx_nome_responsavel_legal != '')
			) AND (
				registro_anterior.ft_nome_responsavel_legal IS null OR registro_anterior.ft_nome_responsavel_legal = ANY(fonte_dados_nao_oficiais)
			) THEN 
				registro_posterior.tx_nome_responsavel_legal := objeto.tx_nome_responsavel_legal;
				registro_posterior.ft_nome_responsavel_legal := tipo_usuario;
				flag_log := true;
			END IF;
			
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
			
			IF flag_log THEN 		
				INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
				VALUES ('osc.atualizar_dados_gerais', registro_posterior.id_osc, fonte::INTEGER, dataatualizacao, row_to_json(registro_anterior), row_to_json(registro_posterior));
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
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT, dataatualizacao::TIMESTAMP);
		END IF;
		
		RETURN NEXT;
		
	WHEN unique_violation THEN 
		flag := false;
		mensagem := 'Dado(s) único(s) violado(s).';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT, dataatualizacao::TIMESTAMP);
		END IF;
		
		RETURN NEXT;
		
	WHEN foreign_key_violation THEN 
		flag := false;
		mensagem := 'Dado(s) com chave(s) estrangeira(s) violada(s).';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT, dataatualizacao::TIMESTAMP);
		END IF;
		
		RETURN NEXT;
		
	WHEN others THEN  
		flag := false;
		mensagem := 'Ocorreu um erro.';
		
		IF errolog THEN 
			INSERT INTO log.tb_log_carga (cd_identificador_osc, id_fonte_dados, cd_status, tx_mensagem, dt_carregamento_dados) 
			VALUES (osc::INTEGER, fonte::TEXT, '2'::SMALLINT, mensagem::TEXT, dataatualizacao::TIMESTAMP);
		END IF;
		
		RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';
