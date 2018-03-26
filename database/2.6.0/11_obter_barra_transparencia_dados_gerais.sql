DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_dados_gerais();

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_dados_gerais() RETURNS TABLE (
	id_osc INTEGER, 
	transparencia NUMERIC, 
	peso DOUBLE PRECISION
) AS $$ 

DECLARE 
	peso_segmento DOUBLE PRECISION;
	peso_campo DOUBLE PRECISION;

BEGIN 
	peso_segmento := (SELECT peso_secao FROM portal.tb_peso_barra_transparencia WHERE id_peso_barra_transparencia = 1);
	peso_campo := 100 / 13;

	RETURN QUERY 
		SELECT 
			dados_gerais.id_osc, 
			(CAST(SUM(
				(CASE WHEN NOT(dados_gerais.tx_nome_fantasia_osc IS NULL) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN (NOT(dados_gerais.tx_sigla_osc IS NULL) OR (dados_gerais.bo_nao_possui_sigla_osc IS true)) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_endereco IS NULL) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_nome_situacao_imovel_osc IS NULL) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_nome_responsavel_legal IS NULL) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.dt_ano_cadastro_cnpj IS NULL) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.dt_fundacao_osc IS NULL) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_email IS NULL) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_resumo_osc IS NULL) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_site IS NULL) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN NOT(dados_gerais.tx_telefone IS NULL) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM portal.vw_osc_objetivo_osc WHERE vw_osc_objetivo_osc.id_osc = dados_gerais.id_osc AND cd_meta_osc IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM portal.vw_osc_objetivo_osc WHERE vw_osc_objetivo_osc.id_osc = dados_gerais.id_osc AND cd_objetivo_osc IS NOT null) THEN peso_campo ELSE 0 END)
			) / COUNT(*) AS NUMERIC(7, 2))), 
			peso_segmento 
		FROM 
			portal.vw_osc_dados_gerais AS dados_gerais 
		GROUP BY 
			dados_gerais.id_osc;
END;

$$ LANGUAGE 'plpgsql';
