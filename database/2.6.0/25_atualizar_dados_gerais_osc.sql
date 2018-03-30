DROP FUNCTION IF EXISTS portal.atualizar_dados_gerais_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_dados_gerais_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER, tipo_busca INTEGER) RETURNS TABLE(
	mensagem TEXT,
	flag BOOLEAN
)AS $$

DECLARE
	nome_tabela TEXT;
	fonte_dados RECORD;
	objeto RECORD;
	dado_anterior RECORD;
	dado_posterior RECORD;
	flag_update BOOLEAN;
	osc INTEGER;
	objetivos JSONB;
	record_contato RECORD;
	record_objetivos RECORD;

BEGIN
	nome_tabela := 'osc.tb_dados_gerais';
	tipo_identificador := lower(tipo_identificador);

	SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);

	IF fonte_dados IS null THEN
		RAISE EXCEPTION 'fonte_invalida';
	END IF;

	IF tipo_identificador = 'cnpj' THEN
		SELECT id_osc INTO osc FROM osc.tb_osc WHERE cd_identificador_osc = identificador;
	ELSIF tipo_identificador = 'id_osc' THEN
		SELECT id_osc INTO osc FROM osc.tb_osc WHERE id_osc = identificador;
	ELSE
		RAISE EXCEPTION 'tipo_identificador_invalido';
	END IF;
	
	IF osc IS null THEN
		RAISE EXCEPTION 'osc_nao_encontrada';
	ELSIF osc != ALL(fonte_dados.representacao) THEN
		RAISE EXCEPTION 'permissao_negada_usuario';
	END IF;

	SELECT INTO objeto * FROM jsonb_populate_record(null::osc.tb_dados_gerais, json);

	SELECT INTO dado_anterior * FROM osc.tb_dados_gerais WHERE id_osc = osc;
	
	IF dado_anterior.id_osc IS null THEN
		INSERT INTO osc.tb_dados_gerais (
			id_osc,
			cd_natureza_juridica_osc,
			ft_natureza_juridica_osc,
			cd_classe_atividade_economica_osc,
			ft_classe_atividade_economica_osc,
			tx_razao_social_osc,
			ft_razao_social_osc,
			tx_nome_fantasia_osc,
			ft_nome_fantasia_osc,
			im_logo,
			ft_logo,
			dt_fundacao_osc,
			ft_fundacao_osc,
			dt_ano_cadastro_cnpj,
			ft_ano_cadastro_cnpj,
			tx_sigla_osc,
			bo_nao_possui_sigla_osc,
			ft_sigla_osc,
			tx_resumo_osc,
			ft_resumo_osc,
			cd_situacao_imovel_osc,
			ft_situacao_imovel_osc,
			tx_link_relatorio_auditoria,
			ft_link_relatorio_auditoria,
			tx_link_demonstracao_contabil,
			ft_link_demonstracao_contabil,
			tx_nome_responsavel_legal,
			ft_nome_responsavel_legal
		) VALUES (
			osc,
			objeto.cd_natureza_juridica_osc,
			fonte_dados.nome_fonte,
			objeto.cd_classe_atividade_economica_osc,
			fonte_dados.nome_fonte,
			objeto.tx_razao_social_osc,
			fonte_dados.nome_fonte,
			objeto.tx_nome_fantasia_osc,
			fonte_dados.nome_fonte,
			objeto.im_logo,
			fonte_dados.nome_fonte,
			objeto.dt_fundacao_osc,
			fonte_dados.nome_fonte,
			objeto.dt_ano_cadastro_cnpj,
			fonte_dados.nome_fonte,
			objeto.tx_sigla_osc,
			objeto.bo_nao_possui_sigla_osc,
			fonte_dados.nome_fonte,
			objeto.tx_resumo_osc,
			fonte_dados.nome_fonte,
			objeto.cd_situacao_imovel_osc,
			fonte_dados.nome_fonte,
			objeto.tx_link_relatorio_auditoria,
			fonte_dados.nome_fonte,
			objeto.tx_link_demonstracao_contabil,
			fonte_dados.nome_fonte,
			objeto.tx_nome_responsavel_legal,
			fonte_dados.nome_fonte
		) RETURNING * INTO dado_posterior;

		PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, null, row_to_json(dado_posterior),id_carga);

	ELSE
		dado_posterior := dado_anterior;
		flag_update := false;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_natureza_juridica_osc::TEXT, dado_anterior.ft_natureza_juridica_osc, objeto.cd_natureza_juridica_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.cd_natureza_juridica_osc := objeto.cd_natureza_juridica_osc;
			dado_posterior.ft_natureza_juridica_osc := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_classe_atividade_economica_osc::TEXT, dado_anterior.ft_classe_atividade_economica_osc, objeto.cd_classe_atividade_economica_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.cd_classe_atividade_economica_osc := objeto.cd_classe_atividade_economica_osc;
			dado_posterior.ft_classe_atividade_economica_osc := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_razao_social_osc::TEXT, dado_anterior.ft_razao_social_osc, objeto.tx_razao_social_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_razao_social_osc := objeto.tx_razao_social_osc;
			dado_posterior.ft_razao_social_osc := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_nome_fantasia_osc::TEXT, dado_anterior.ft_nome_fantasia_osc, objeto.tx_nome_fantasia_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_nome_fantasia_osc := objeto.tx_nome_fantasia_osc;
			dado_posterior.ft_nome_fantasia_osc := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.im_logo::TEXT, dado_anterior.ft_logo, objeto.im_logo::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.im_logo := objeto.im_logo;
			dado_posterior.ft_logo := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_fundacao_osc::TEXT, dado_anterior.ft_fundacao_osc, objeto.dt_fundacao_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.dt_fundacao_osc := objeto.dt_fundacao_osc;
			dado_posterior.ft_fundacao_osc := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;
		
		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.dt_ano_cadastro_cnpj::TEXT, dado_anterior.ft_ano_cadastro_cnpj, objeto.dt_ano_cadastro_cnpj::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.dt_ano_cadastro_cnpj := objeto.dt_ano_cadastro_cnpj;
			dado_posterior.ft_ano_cadastro_cnpj := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;
		
		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.bo_nao_possui_sigla_osc::TEXT, dado_anterior.ft_sigla_osc, objeto.bo_nao_possui_sigla_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			IF (objeto.bo_nao_possui_sigla_osc IS true) THEN
				dado_posterior.tx_sigla_osc := null;
				dado_posterior.bo_nao_possui_sigla_osc := objeto.bo_nao_possui_sigla_osc;
				dado_posterior.ft_sigla_osc := fonte_dados.nome_fonte;
			ELSE 
				IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_sigla_osc::TEXT, dado_anterior.ft_sigla_osc, objeto.tx_sigla_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
					dado_posterior.tx_sigla_osc := objeto.tx_sigla_osc;
					dado_posterior.bo_nao_possui_sigla_osc := false;
					dado_posterior.ft_sigla_osc := fonte_dados.nome_fonte;
					flag_update := true;
				END IF;
			END IF;
			flag_update := true;
		END IF;
		
		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_resumo_osc::TEXT, dado_anterior.ft_resumo_osc, objeto.tx_resumo_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_resumo_osc := objeto.tx_resumo_osc;
			dado_posterior.ft_resumo_osc := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.cd_situacao_imovel_osc::TEXT, dado_anterior.ft_situacao_imovel_osc, objeto.cd_situacao_imovel_osc::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.cd_situacao_imovel_osc := objeto.cd_situacao_imovel_osc;
			dado_posterior.ft_situacao_imovel_osc := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_link_relatorio_auditoria::TEXT, dado_anterior.ft_link_relatorio_auditoria, objeto.tx_link_relatorio_auditoria::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_link_relatorio_auditoria := objeto.tx_link_relatorio_auditoria;
			dado_posterior.ft_link_relatorio_auditoria := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_link_demonstracao_contabil::TEXT, dado_anterior.ft_link_demonstracao_contabil, objeto.tx_link_demonstracao_contabil::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_link_demonstracao_contabil := objeto.tx_link_demonstracao_contabil;
			dado_posterior.ft_link_demonstracao_contabil := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF (SELECT a.flag FROM portal.verificar_dado(dado_anterior.tx_nome_responsavel_legal::TEXT, dado_anterior.ft_nome_responsavel_legal, objeto.tx_nome_responsavel_legal::TEXT, fonte_dados.prioridade, null_valido) AS a) THEN
			dado_posterior.tx_nome_responsavel_legal := objeto.tx_nome_responsavel_legal;
			dado_posterior.ft_nome_responsavel_legal := fonte_dados.nome_fonte;
			flag_update := true;
		END IF;

		IF flag_update THEN
			UPDATE osc.tb_dados_gerais
			SET cd_natureza_juridica_osc = dado_posterior.cd_natureza_juridica_osc,
				ft_natureza_juridica_osc = dado_posterior.ft_natureza_juridica_osc,
				cd_classe_atividade_economica_osc = dado_posterior.cd_classe_atividade_economica_osc,
				ft_classe_atividade_economica_osc = dado_posterior.ft_classe_atividade_economica_osc,
				tx_razao_social_osc = dado_posterior.tx_razao_social_osc,
				ft_razao_social_osc = dado_posterior.ft_razao_social_osc,
				tx_nome_fantasia_osc = dado_posterior.tx_nome_fantasia_osc,
				ft_nome_fantasia_osc = dado_posterior.ft_nome_fantasia_osc,
				im_logo = dado_posterior.im_logo,
				ft_logo = dado_posterior.ft_logo,
				dt_fundacao_osc = dado_posterior.dt_fundacao_osc,
				ft_fundacao_osc = dado_posterior.ft_fundacao_osc,
				dt_ano_cadastro_cnpj = dado_posterior.dt_ano_cadastro_cnpj,
				ft_ano_cadastro_cnpj = dado_posterior.ft_ano_cadastro_cnpj,
				tx_sigla_osc = dado_posterior.tx_sigla_osc,
				bo_nao_possui_sigla_osc = dado_posterior.bo_nao_possui_sigla_osc,
				ft_sigla_osc = dado_posterior.ft_sigla_osc,
				tx_resumo_osc = dado_posterior.tx_resumo_osc,
				ft_resumo_osc = dado_posterior.ft_resumo_osc,
				cd_situacao_imovel_osc = dado_posterior.cd_situacao_imovel_osc,
				ft_situacao_imovel_osc = dado_posterior.ft_situacao_imovel_osc,
				tx_link_relatorio_auditoria = dado_posterior.tx_link_relatorio_auditoria,
				ft_link_relatorio_auditoria = dado_posterior.ft_link_relatorio_auditoria,
				tx_link_demonstracao_contabil = dado_posterior.tx_link_demonstracao_contabil,
				ft_link_demonstracao_contabil = dado_posterior.ft_link_demonstracao_contabil,
				tx_nome_responsavel_legal = dado_posterior.tx_nome_responsavel_legal,
				ft_nome_responsavel_legal = dado_posterior.ft_nome_responsavel_legal
			WHERE id_osc = osc;
			
			PERFORM * FROM portal.inserir_log_atualizacao(nome_tabela, osc, fonte, data_atualizacao, row_to_json(dado_anterior), row_to_json(dado_posterior),id_carga);
			
		END IF;
	END IF;
	
	SELECT INTO record_contato * FROM portal.atualizar_contato_osc(fonte, identificador, tipo_identificador, data_atualizacao, json, null_valido, erro_log, id_carga);
	IF record_contato.flag = false THEN 
		mensagem := record_contato.mensagem;
		RAISE EXCEPTION 'funcao_externa';
	END IF;

	objetivos = COALESCE((json->>'objetivo_metas')::JSONB, '{}'::JSONB);
	SELECT INTO record_objetivos * FROM portal.atualizar_objetivos_osc(fonte, identificador, tipo_identificador, data_atualizacao, objetivos, null_valido, delete_valido, erro_log, id_carga, tipo_busca);
	IF record_objetivos.flag = false THEN 
		mensagem := record_objetivos.mensagem;
		RAISE EXCEPTION 'funcao_externa';
	END IF;
	
	flag := true;
	mensagem := 'Dados gerais de OSC atualizado.';
	
	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;

		IF SQLERRM <> 'funcao_externa' THEN 
			SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, identificador, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		END IF;
		
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
