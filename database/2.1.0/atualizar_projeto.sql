DROP FUNCTION IF EXISTS portal.atualizar_projeto(integer, integer, text, text, integer, text, date, text, date, text, double precision, text, text, text, integer, text, text, text, integer, text, double precision, text, integer, text, text, text, text, text);

CREATE OR REPLACE FUNCTION portal.atualizar_projeto(
    IN id integer,
    IN idprojeto integer,
    IN nomeprojeto text,
    IN ftnomeprojeto text,
    IN cdstatusprojeto integer,
    IN ftstatusprojeto text,
    IN dtdatainicioprojeto date,
    IN ftdatainicioprojeto text,
    IN dtdatafimprojeto date,
    IN ftdatafimprojeto text,
    IN nrvalortotalprojeto double precision,
    IN ftvalortotalprojeto text,
    IN link_projeto text,
    IN ftlinkprojeto text,
    IN cdabrangenciaprojeto integer,
    IN ftabrangenciaprojeto text,
    IN descricaoprojeto text,
    IN ftdescricaoprojeto text,
    IN nrtotalbeneficiarios integer,
    IN fttotalbeneficiarios text,
    IN nrvalorcaptadoprojeto double precision,
    IN ftvalorcaptadoprojeto text,
    IN cdzonaatuacaoprojeto integer,
    IN ftzonaatuacao_projeto text,
    IN metodologiamonitoramento text,
    IN ftmetodologiamonitoramento text,
    IN identificadorprojetoexterno text,
    IN ftidentificadorprojetoexterno text)
  RETURNS TABLE(mensagem text) AS
$BODY$

BEGIN 
	UPDATE 
		osc.tb_projeto 
	SET 
		id_osc = id, 
		tx_nome_projeto = nomeprojeto, 
		ft_nome_projeto = ftnomeprojeto, 
		cd_status_projeto = cdstatusprojeto, 
		ft_status_projeto = ftstatusprojeto, 
		dt_data_inicio_projeto = dtdatainicioprojeto, 
		ft_data_inicio_projeto = ftdatainicioprojeto, 
		dt_data_fim_projeto = dtdatafimprojeto, 
		ft_data_fim_projeto = ftdatafimprojeto, 
		nr_valor_total_projeto = nrvalortotalprojeto, 
		ft_valor_total_projeto = ftvalortotalprojeto, 
		tx_link_projeto = link_projeto, 
		ft_link_projeto = ftlinkprojeto, 
		cd_abrangencia_projeto = cdabrangenciaprojeto, 
		ft_abrangencia_projeto = ftabrangenciaprojeto, 
		tx_descricao_projeto = descricaoprojeto, 
		ft_descricao_projeto = ftdescricaoprojeto, 
		nr_total_beneficiarios = nrtotalbeneficiarios, 
		ft_total_beneficiarios = fttotalbeneficiarios, 
		nr_valor_captado_projeto = nrvalorcaptadoprojeto, 
		ft_valor_captado_projeto = ftvalorcaptadoprojeto, 
		cd_zona_atuacao_projeto = cdzonaatuacaoprojeto, 
		ft_zona_atuacao_projeto = ftzonaatuacao_projeto, 
		tx_metodologia_monitoramento = metodologiamonitoramento, 
		ft_metodologia_monitoramento = ftmetodologiamonitoramento, 
		tx_identificador_projeto_externo = identificadorprojetoexterno, 
		ft_identificador_projeto_externo = ftidentificadorprojetoexterno 
	WHERE 
		id_projeto = idprojeto; 

	mensagem := 'Projeto atualizado';
	RETURN NEXT;
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;