DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_dados_gerais(INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_dados_gerais(osc INTEGER) RETURNS TABLE (
	pontuacao DOUBLE PRECISION
) AS $$ 

DECLARE 
	peso_campo DOUBLE PRECISION;

BEGIN 
	peso_campo := 100.0 / 12.0;

	RETURN QUERY 
		SELECT 
			SUM(
				(CASE WHEN dados_gerais.tx_nome_fantasia_osc IS NOT null THEN peso_campo ELSE 0 END) + 
				(CASE WHEN dados_gerais.bo_nao_possui_sigla_osc IS true OR (dados_gerais.bo_nao_possui_sigla_osc IS false AND dados_gerais.tx_sigla_osc IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN dados_gerais.cd_situacao_imovel_osc IS NOT null THEN peso_campo ELSE 0 END) + 
				(CASE WHEN dados_gerais.tx_nome_responsavel_legal IS NOT null THEN peso_campo ELSE 0 END) + 
				(CASE WHEN dados_gerais.dt_ano_cadastro_cnpj IS NOT null THEN peso_campo ELSE 0 END) + 
				(CASE WHEN dados_gerais.dt_fundacao_osc IS NOT null THEN peso_campo ELSE 0 END) + 
				(CASE WHEN dados_gerais.tx_resumo_osc IS NOT null THEN peso_campo ELSE 0 END) + 
				(CASE WHEN contato.bo_nao_possui_email IS true OR (contato.bo_nao_possui_email IS false AND contato.tx_email IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN contato.bo_nao_possui_site IS true OR (contato.bo_nao_possui_site IS false AND contato.tx_site IS NOT null) THEN peso_campo ELSE 0 END) + 
				(CASE WHEN localizacao.tx_endereco IS NOT null THEN peso_campo ELSE 0 END) + 
				(CASE WHEN contato.tx_telefone IS NOT null THEN peso_campo ELSE 0 END) + 
				(CASE WHEN EXISTS(SELECT * FROM osc.tb_objetivo_osc WHERE id_osc = osc AND cd_meta_osc IS NOT null) THEN peso_campo ELSE 0 END)
			) 
		FROM 
			osc.tb_dados_gerais AS dados_gerais 
			LEFT JOIN osc.tb_contato as contato ON dados_gerais.id_osc = contato.id_osc 
			LEFT JOIN osc.tb_localizacao as localizacao ON dados_gerais.id_osc = localizacao.id_osc 
		WHERE 
			dados_gerais.id_osc = osc;

END;

$$ LANGUAGE 'plpgsql';
