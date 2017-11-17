DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_dados_gerais();

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_dados_gerais() RETURNS TABLE (
	id_osc INTEGER, 
	transparencia NUMERIC, 
	peso DOUBLE PRECISION
) AS $$ 

DECLARE 
	peso DOUBLE PRECISION;

BEGIN 
	peso := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 1); 
	
	RETURN QUERY 
		SELECT 
			dados_gerais.id_osc, 
			(CAST(SUM(
				(CASE WHEN NOT(dados_gerais.tx_nome_fantasia_osc IS NULL) THEN 5 ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_sigla_osc IS NULL) THEN 5 ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_nome_situacao_imovel_osc IS NULL) THEN 5 ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_nome_responsavel_legal IS NULL) THEN 15 ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.dt_ano_cadastro_cnpj IS NULL) THEN 5 ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.dt_fundacao_osc IS NULL) THEN 10 ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_email IS NULL) THEN 5 ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_resumo_osc IS NULL) THEN 20 ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_site IS NULL) THEN 10 ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_telefone IS NULL) THEN 20 ELSE 0 END)
			) / COUNT(*) AS NUMERIC(7, 2))), 
			peso 
		FROM 
			portal.vw_osc_dados_gerais AS dados_gerais
		GROUP BY 
			dados_gerais.id_osc;
END;

$$ LANGUAGE 'plpgsql';
