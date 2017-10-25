DROP FUNCTION IF EXISTS portal.atualizar_dados_gerais(registro JSONB, fonte INTEGER, dataatualizacao TIMESTAMP, nullvalido BOOLEAN, errovalido BOOLEAN);

CREATE OR REPLACE FUNCTION portal.atualizar_dados_gerais(registro JSONB, fonte INTEGER, dataatualizacao TIMESTAMP, nullvalido BOOLEAN, errovalido BOOLEAN) RETURNS TABLE(
	mensagem TEXT, 
	flag BOOLEAN
)AS $$

DECLARE 
	objeto RECORD;
	registro_anterior RECORD;
	registro_posterior RECORD;
	flag_log BOOLEAN;
	
BEGIN 
	SELECT INTO objeto * FROM json_populate_record(null::osc.tb_dados_gerais, registro::JSON);
	
	SELECT INTO registro_anterior 
		* 
	FROM 
		osc.tb_dados_gerais 
	WHERE 
		id_osc = objeto.id_osc;
	
	IF COUNT(registro_anterior) = 0 THEN 
		INSERT INTO 
			osc.tb_dados_gerais (
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
			) 
		VALUES (
			objeto.id_osc, 
			objeto.cd_natureza_juridica_osc, 
			fonte, 
			objeto.cd_subclasse_atividade_economica_osc, 
			fonte, 
			objeto.tx_razao_social_osc, 
			fonte, 
			objeto.tx_nome_fantasia_osc, 
			fonte, 
			objeto.im_logo, 
			fonte, 
			objeto.tx_missao_osc, 
			fonte, 
			objeto.tx_visao_osc, 
			fonte, 
			objeto.dt_fundacao_osc, 
			fonte, 
			objeto.dt_ano_cadastro_cnpj, 
			fonte, 
			objeto.tx_sigla_osc, 
			fonte, 
			objeto.tx_resumo_osc, 
			fonte, 
			objeto.cd_situacao_imovel_osc, 
			fonte, 
			objeto.tx_link_estatuto_osc, 
			fonte, 
			objeto.tx_historico, 
			fonte, 
			objeto.tx_finalidades_estatutarias, 
			fonte, 
			objeto.tx_link_relatorio_auditoria, 
			fonte, 
			objeto.tx_link_demonstracao_contabil, 
			fonte, 
			tx_nome_responsavel_legal, 
			fonte
		) RETURNING * INTO registro_posterior;
		
		INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
		VALUES ('osc.tb_fonte_recursos_projeto', registro_posterior.id_osc, fonte, dataatualizacao, null, row_to_json(registro_posterior));
		
	ELSE 
		registro_posterior := registro_anterior;
		flag_log := false;
		
		IF (nullvalido = true AND registro_anterior.cd_natureza_juridica_osc <> objeto.cd_natureza_juridica_osc) OR (nullvalido = false AND registro_anterior.cd_natureza_juridica_osc <> objeto.cd_natureza_juridica_osc AND objeto.cd_natureza_juridica_osc IS NOT null) THEN 
			registro_posterior.cd_natureza_juridica_osc := objeto.cd_natureza_juridica_osc;
			registro_posterior.ft_natureza_juridica_osc := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.cd_subclasse_atividade_economica_osc <> objeto.cd_subclasse_atividade_economica_osc) OR (nullvalido = false AND registro_anterior.cd_subclasse_atividade_economica_osc <> objeto.cd_subclasse_atividade_economica_osc AND objeto.cd_subclasse_atividade_economica_osc IS NOT null) THEN 
			registro_posterior.cd_subclasse_atividade_economica_osc := objeto.cd_subclasse_atividade_economica_osc;
			registro_posterior.ft_subclasse_atividade_economica_osc := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.tx_razao_social_osc <> objeto.tx_razao_social_osc) OR (nullvalido = false AND registro_anterior.tx_razao_social_osc <> objeto.tx_razao_social_osc AND objeto.tx_razao_social_osc IS NOT null) THEN 
			registro_posterior.tx_razao_social_osc := objeto.tx_razao_social_osc;
			registro_posterior.ft_razao_social_osc := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.tx_nome_fantasia_osc <> objeto.tx_nome_fantasia_osc) OR (nullvalido = false AND registro_anterior.tx_nome_fantasia_osc <> objeto.tx_nome_fantasia_osc AND objeto.tx_nome_fantasia_osc IS NOT null) THEN 
			registro_posterior.tx_nome_fantasia_osc := objeto.tx_nome_fantasia_osc;
			registro_posterior.ft_nome_fantasia_osc := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.im_logo <> objeto.im_logo) OR (nullvalido = false AND registro_anterior.im_logo <> objeto.im_logo AND objeto.im_logo IS NOT null) THEN 
			registro_posterior.im_logo := objeto.im_logo;
			registro_posterior.ft_logo := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.tx_missao_osc <> objeto.tx_missao_osc) OR (nullvalido = false AND registro_anterior.tx_missao_osc <> objeto.tx_missao_osc AND objeto.tx_missao_osc IS NOT null) THEN 
			registro_posterior.tx_missao_osc := objeto.tx_missao_osc;
			registro_posterior.ft_missao_osc := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.tx_visao_osc <> objeto.tx_visao_osc) OR (nullvalido = false AND registro_anterior.tx_visao_osc <> objeto.tx_visao_osc AND objeto.tx_visao_osc IS NOT null) THEN 
			registro_posterior.tx_visao_osc := objeto.tx_visao_osc;
			registro_posterior.ft_visao_osc := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.dt_fundacao_osc <> objeto.dt_fundacao_osc) OR (nullvalido = false AND registro_anterior.dt_fundacao_osc <> objeto.dt_fundacao_osc AND objeto.dt_fundacao_osc IS NOT null) THEN 
			registro_posterior.dt_fundacao_osc := objeto.dt_fundacao_osc;
			registro_posterior.ft_fundacao_osc := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.dt_ano_cadastro_cnpj <> objeto.dt_ano_cadastro_cnpj) OR (nullvalido = false AND registro_anterior.dt_ano_cadastro_cnpj <> objeto.dt_ano_cadastro_cnpj AND objeto.dt_ano_cadastro_cnpj IS NOT null) THEN 
			registro_posterior.dt_ano_cadastro_cnpj := objeto.dt_ano_cadastro_cnpj;
			registro_posterior.ft_ano_cadastro_cnpj := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.tx_sigla_osc <> objeto.tx_sigla_osc) OR (nullvalido = false AND registro_anterior.tx_sigla_osc <> objeto.tx_sigla_osc AND objeto.tx_sigla_osc IS NOT null) THEN 
			registro_posterior.tx_sigla_osc := objeto.tx_sigla_osc;
			registro_posterior.ft_sigla_osc := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.tx_resumo_osc <> objeto.tx_resumo_osc) OR (nullvalido = false AND registro_anterior.tx_resumo_osc <> objeto.tx_resumo_osc AND objeto.tx_resumo_osc IS NOT null) THEN 
			registro_posterior.tx_resumo_osc := objeto.tx_resumo_osc;
			registro_posterior.ft_resumo_osc := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.cd_situacao_imovel_osc <> objeto.cd_situacao_imovel_osc) OR (nullvalido = false AND registro_anterior.cd_situacao_imovel_osc <> objeto.cd_situacao_imovel_osc AND objeto.cd_situacao_imovel_osc IS NOT null) THEN 
			registro_posterior.cd_situacao_imovel_osc := objeto.cd_situacao_imovel_osc;
			registro_posterior.ft_situacao_imovel_osc := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.tx_link_estatuto_osc <> objeto.tx_link_estatuto_osc) OR (nullvalido = false AND registro_anterior.tx_link_estatuto_osc <> objeto.tx_link_estatuto_osc AND objeto.tx_link_estatuto_osc IS NOT null) THEN 
			registro_posterior.tx_link_estatuto_osc := objeto.tx_link_estatuto_osc;
			registro_posterior.ft_link_estatuto_osc := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.tx_historico <> objeto.tx_historico) OR (nullvalido = false AND registro_anterior.tx_historico <> objeto.tx_historico AND objeto.tx_historico IS NOT null) THEN 
			registro_posterior.tx_historico := objeto.tx_historico;
			registro_posterior.ft_historico := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.tx_finalidades_estatutarias <> objeto.tx_finalidades_estatutarias) OR (nullvalido = false AND registro_anterior.tx_finalidades_estatutarias <> objeto.tx_finalidades_estatutarias AND objeto.tx_finalidades_estatutarias IS NOT null) THEN 
			registro_posterior.tx_finalidades_estatutarias := objeto.tx_finalidades_estatutarias;
			registro_posterior.ft_finalidades_estatutarias := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.tx_link_relatorio_auditoria <> objeto.tx_link_relatorio_auditoria) OR (nullvalido = false AND registro_anterior.tx_link_relatorio_auditoria <> objeto.tx_link_relatorio_auditoria AND objeto.tx_link_relatorio_auditoria IS NOT null) THEN 
			registro_posterior.tx_link_relatorio_auditoria := objeto.tx_link_relatorio_auditoria;
			registro_posterior.ft_link_relatorio_auditoria := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.tx_link_demonstracao_contabil <> objeto.tx_link_demonstracao_contabil) OR (nullvalido = false AND registro_anterior.tx_link_demonstracao_contabil <> objeto.tx_link_demonstracao_contabil AND objeto.tx_link_demonstracao_contabil IS NOT null) THEN 
			registro_posterior.tx_link_demonstracao_contabil := objeto.tx_link_demonstracao_contabil;
			registro_posterior.ft_link_demonstracao_contabil := fonte;
			flag_log := true;
		END IF;
		
		IF (nullvalido = true AND registro_anterior.tx_nome_responsavel_legal <> objeto.tx_nome_responsavel_legal) OR (nullvalido = false AND registro_anterior.tx_nome_responsavel_legal <> objeto.tx_nome_responsavel_legal AND objeto.tx_nome_responsavel_legal IS NOT null) THEN 
			registro_posterior.tx_nome_responsavel_legal := objeto.tx_nome_responsavel_legal;
			registro_posterior.ft_nome_responsavel_legal := fonte;
			flag_log := true;
		END IF;
		
		UPDATE 
			osc.tb_dados_gerais 
		SET 
			cd_natureza_juridica_osc = registro_posterior.cd_natureza_juridica_osc, 
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
		WHERE 
			id_osc = registro_posterior.id_osc; 
		
		IF flag_log THEN 		
			INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
			VALUES ('osc.tb_fonte_recursos_projeto', registro_posterior.id_osc, fonte, dataatualizacao, row_to_json(registro_anterior), row_to_json(registro_posterior));
		END IF;
	
	END IF;
	
	flag := true;
	mensagem := 'Dados gerais de OSC atualizado.';
	RETURN NEXT;

EXCEPTION 
	WHEN not_null_violation THEN 
		IF errovalido THEN 
			RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;
		END IF;
		
		flag := false;
		mensagem := 'Dado(s) obrigatório(s) não enviado(s).';
		RETURN NEXT;
		
	WHEN unique_violation THEN 
		IF errovalido THEN 
			RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;
		END IF;
		
		flag := false;
		mensagem := 'Dado(s) único(s) violado(s).';
		RETURN NEXT;
		
	WHEN foreign_key_violation THEN 
		IF errovalido THEN 
			RAISE EXCEPTION '(%) %', SQLSTATE, SQLERRM;
		END IF;
		
		flag := false;
		mensagem := 'Dado(s) com chave(s) estrangeira(s) violada(s).';
		RETURN NEXT;
		
	WHEN others THEN 
		IF errovalido THEN 
			RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;
		END IF;
		
		flag := false;
		mensagem := 'Ocorreu um erro.';
		RETURN NEXT;
		
END; 
$$ LANGUAGE 'plpgsql';



-- portal.atualizar_dados_gerais(registro JSONB, fonte INTEGER, dataatualizacao TIMESTAMP, nullvalido BOOLEAN, errovalido BOOLEAN) RETURNS TABLE(
SELECT * FROM portal.atualizar_dados_gerais('{
	"id_osc": "789809", 
	"cd_natureza_juridica_osc": 3999, 
	"cd_subclasse_atividade_economica_osc": 8424800, 
	"tx_razao_social_osc": "Organização da Sociedade Civil de Teste do Mapa das OSCs", 
	"tx_nome_fantasia_osc": "Orgteste - Organização Tipiniquim de Teste", 
	"im_logo": null, 
	"tx_missao_osc": "Missão aquela para qual o Mapa das OSCs for projetado para desempenhar.", 
	"tx_visao_osc": "Turva", 
	"dt_fundacao_osc": "01-01-2017", 
	"dt_ano_cadastro_cnpj": "01-01-1960", 
	"tx_sigla_osc": "ORGIPEA", 
	"tx_resumo_osc": "OSC utilizadao para testes do Mapa das OSCs.", 
	"cd_situacao_imovel_osc": 2, 
	"tx_link_estatuto_osc": "https://mapaosc.ipea.gov.br/editar-osc.html#/789809", 
	"tx_historico": "A maior preocupação dos jovens é a qualidade da educação. Os adultos, no entanto, colocam a saúde em primeiro lugar. Essa é uma das conclusões do estudo Juventude que conta, apresentado no auditório do IPEA.", 
	"tx_finalidades_estatutarias": "Não há finalidades definidas em estatuto definido.", 
	"tx_link_relatorio_auditoria": null, 
	"tx_link_demonstracao_contabil": null, 
	"tx_nome_responsavel_legal": "Felix Lopez"
}'::JSONB, '828'::INTEGER, '2017-10-25'::TIMESTAMP, false, true);
