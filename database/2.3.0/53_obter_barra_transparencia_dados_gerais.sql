DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_dados_gerais();

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_dados_gerais() RETURNS TABLE (
	id_osc INTEGER, 
	transparencia NUMERIC
) AS $$ 

BEGIN 
	RETURN QUERY 
		SELECT 
			dados_gerais.id_osc, 
			CAST((
				(CASE WHEN NOT(dados_gerais.tx_nome_fantasia_osc IS NULL) THEN 1 ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_sigla_osc IS NULL) THEN 1 ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_nome_situacao_imovel_osc IS NULL) THEN 1 ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_nome_responsavel_legal IS NULL) THEN 3 ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.dt_ano_cadastro_cnpj IS NULL) THEN 1 ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.dt_fundacao_osc IS NULL) THEN 2 ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_email IS NULL) THEN 1 ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_resumo_osc IS NULL) THEN 4 ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_site IS NULL) THEN 2 ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_telefone IS NULL) THEN 4 ELSE 0 END)
			) AS NUMERIC(7,2)) 
		FROM 
			portal.vw_osc_dados_gerais AS dados_gerais;
END;

$$ LANGUAGE 'plpgsql';
