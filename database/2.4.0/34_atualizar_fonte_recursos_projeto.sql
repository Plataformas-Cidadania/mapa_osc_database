DROP FUNCTION IF EXISTS portal.atualizar_fonte_recursos_projeto(osc INTEGER, fonteprojeto INTEGER, fonterecursos INTEGER, origemfonterecursos INTEGER, tipoparceria INTEGER, orgaoconcedente TEXT, fonte TEXT, dataatualizacao TIMESTAMP, nullvalido BOOLEAN);

CREATE OR REPLACE FUNCTION portal.atualizar_fonte_recursos_projeto(osc INTEGER, fonteprojeto INTEGER, fonterecursos INTEGER, origemfonterecursos INTEGER, tipoparceria INTEGER, orgaoconcedente TEXT, fonte TEXT, dataatualizacao TIMESTAMP, nullvalido BOOLEAN) RETURNS TABLE(
	mensagem TEXT
)AS $$

DECLARE 
	projeto_anterior RECORD;
	projeto_posterior RECORD;
	gravar_log BOOLEAN;
	
BEGIN 
	SELECT INTO projeto_anterior * 
	FROM osc.tb_fonte_recursos_projeto 
	WHERE id_fonte_recursos_projeto = fonteprojeto;
	
	projeto_posterior := projeto_anterior;
	
	IF projeto_anterior.id_fonte_recursos_projeto IS null THEN 
		INSERT INTO 
			osc.tb_projeto (
				id_projeto, 
				cd_fonte_recursos_projeto, 
				cd_origem_fonte_recursos_projeto, 
				ft_fonte_recursos_projeto, 
				cd_tipo_parceria, 
				ft_tipo_parceria, 
				tx_orgao_concedente, 
				ft_orgao_concedente
			) 
		VALUES (
			projeto, 
			fonterecursos, 
			origemfonterecursos, 
			fonte, 
			tipoparceria, 
			fonte, 
			orgaoconcedente, 
			fonte
		);
		
		INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
		VALUES ('osc.tb_fonte_recursos_projeto', osc, fonte::INTEGER, dataatualizacao, null, row_to_json(projeto_posterior));
		
	ELSE 
		gravar_log := false;
		projeto_posterior.id_fonte_recursos_projeto = fonteprojeto;
		
		IF (nullvalido = true AND projeto_anterior.cd_fonte_recursos_projeto <> fonterecursos) OR (nullvalido = false AND projeto_anterior.cd_fonte_recursos_projeto <> fonterecursos AND fonterecursos IS NOT null) THEN 
			projeto_posterior.cd_fonte_recursos_projeto := fonterecursos;
			projeto_posterior.ft_fonte_recursos_projeto := fonte;
			gravar_log := true;
		END IF;
		
		IF (nullvalido = true AND projeto_anterior.cd_origem_fonte_recursos_projeto <> origemfonterecursos) OR (nullvalido = false AND projeto_anterior.cd_origem_fonte_recursos_projeto <> origemfonterecursos AND origemfonterecursos IS NOT null) THEN 
			projeto_posterior.cd_origem_fonte_recursos_projeto := origemfonterecursos;
			projeto_posterior.ft_fonte_recursos_projeto := fonte;
			gravar_log := true;
		END IF;
		
		IF (nullvalido = true AND projeto_anterior.cd_tipo_parceria <> tipoparceria) OR (nullvalido = false AND projeto_anterior.cd_tipo_parceria <> tipoparceria AND tipoparceria IS NOT null) THEN 
			projeto_posterior.cd_tipo_parceria := tipoparceria;
			projeto_posterior.ft_tipo_parceria := fonte;
			gravar_log := true;
		END IF;
		
		IF (nullvalido = true AND projeto_anterior.tx_orgao_concedente <> orgaoconcedente) OR (nullvalido = false AND projeto_anterior.tx_orgao_concedente <> orgaoconcedente AND orgaoconcedente IS NOT null) THEN 
			projeto_posterior.tx_orgao_concedente := orgaoconcedente;
			projeto_posterior.ft_orgao_concedente := fonte;
			gravar_log := true;
		END IF;
		
		UPDATE 
			osc.tb_fonte_recursos_projeto 
		SET 
			cd_fonte_recursos_projeto = projeto_posterior.cd_fonte_recursos_projeto, 
			cd_origem_fonte_recursos_projeto = projeto_posterior.cd_origem_fonte_recursos_projeto, 
			ft_fonte_recursos_projeto = projeto_posterior.ft_fonte_recursos_projeto, 
			cd_tipo_parceria = projeto_posterior.cd_tipo_parceria, 
			ft_tipo_parceria = projeto_posterior.ft_tipo_parceria, 
			tx_orgao_concedente = projeto_posterior.tx_orgao_concedente, 
			ft_orgao_concedente = projeto_posterior.ft_orgao_concedente 
		WHERE 
			id_fonte_recursos_projeto = projeto_posterior.id_fonte_recursos_projeto; 
		
		IF gravar_log THEN 		
			INSERT INTO log.tb_log_alteracao(tx_nome_tabela, id_osc, id_usuario, dt_alteracao, tx_dado_anterior, tx_dado_posterior) 
			VALUES ('osc.tb_fonte_recursos_projeto', osc, fonte::INTEGER, dataatualizacao, row_to_json(projeto_anterior), row_to_json(projeto_posterior));
		END IF;
	
	END IF;
	
	mensagem := 'Fonte de recursos de projeto atualizado';
	RETURN NEXT;
END; 
$$ LANGUAGE 'plpgsql';
