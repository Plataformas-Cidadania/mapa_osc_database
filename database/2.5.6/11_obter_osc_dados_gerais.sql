DROP FUNCTION IF EXISTS portal.obter_osc_dados_gerais(param TEXT);

CREATE OR REPLACE FUNCTION portal.obter_osc_dados_gerais(param TEXT) RETURNS TABLE (
	cd_identificador_osc TEXT, 
	ft_identificador_osc TEXT, 
	tx_razao_social_osc TEXT, 
	ft_razao_social_osc TEXT, 
	tx_nome_fantasia_osc TEXT, 
	ft_nome_fantasia_osc TEXT, 
	im_logo TEXT, 
	ft_logo TEXT, 
	cd_atividade_economica_osc TEXT, 
	tx_nome_atividade_economica_osc TEXT, 
	ft_atividade_economica_osc TEXT, 
	cd_natureza_juridica_osc TEXT, 
	tx_nome_natureza_juridica_osc TEXT, 
	ft_natureza_juridica_osc TEXT, 
	tx_sigla_osc TEXT, 
	ft_sigla_osc TEXT, 
	tx_apelido_osc TEXT, 
	ft_apelido_osc TEXT, 
	dt_fundacao_osc TEXT, 
	ft_fundacao_osc TEXT, 
	dt_ano_cadastro_cnpj TEXT, 
	ft_ano_cadastro_cnpj TEXT, 
	tx_nome_responsavel_legal TEXT, 
	ft_nome_responsavel_legal TEXT, 
	tx_link_estatuto_osc TEXT, 
	ft_link_estatuto_osc TEXT, 
	tx_resumo_osc TEXT, 
	ft_resumo_osc TEXT, 
	cd_situacao_imovel_osc TEXT, 
	tx_nome_situacao_imovel_osc TEXT, 
	ft_situacao_imovel_osc TEXT, 
	tx_endereco TEXT, 
	ft_endereco TEXT, 
	nr_localizacao TEXT, 
	ft_localizacao TEXT, 
	tx_endereco_complemento TEXT, 
	ft_endereco_complemento TEXT, 
	tx_bairro TEXT, 
	ft_bairro TEXT, 
	cd_municipio TEXT, 
	tx_nome_municipio TEXT, 
	ft_municipio TEXT, 
	cd_uf TEXT, 
	tx_sigla_uf TEXT, 
	tx_nome_uf TEXT, 
	ft_uf TEXT, 
	nr_cep TEXT, 
	ft_cep TEXT, 
	geo_lat TEXT, 
	geo_lng TEXT, 
	tx_email TEXT, 
	ft_email TEXT, 
	tx_site TEXT, 
	ft_site TEXT, 
	tx_telefone TEXT, 
	ft_telefone TEXT
) AS $$

BEGIN
	RETURN QUERY
		SELECT
    		tb_osc.ft_apelido_osc,
    		lpad(tb_osc.cd_identificador_osc::TEXT, 14, '0') AS cd_identificador_osc,
    		tb_osc.ft_identificador_osc,
    		NULLIF(btrim(tb_dados_gerais.tx_razao_social_osc), '') AS tx_razao_social_osc,
			tb_dados_gerais.ft_razao_social_osc,
			NULLIF(btrim(tb_dados_gerais.tx_nome_fantasia_osc), '') AS tx_nome_fantasia_osc,
			tb_dados_gerais.ft_nome_fantasia_osc,
			COALESCE(NULLIF(btrim(tb_dados_gerais.tx_nome_fantasia_osc), ''), tb_dados_gerais.tx_razao_social_osc) AS tx_nome_osc,
			tb_dados_gerais.im_logo,
			tb_dados_gerais.ft_logo,
			tb_dados_gerais.cd_classe_atividade_economica_osc::TEXT,
			dc_classe_atividade_economica.tx_nome_classe_atividade_economica,
			tb_dados_gerais.ft_classe_atividade_economica_osc,
			tb_dados_gerais.cd_natureza_juridica_osc::TEXT,
			NULLIF(btrim(dc_natureza_juridica.tx_nome_natureza_juridica), '') AS tx_nome_natureza_juridica_osc,
			tb_dados_gerais.ft_natureza_juridica_osc,
			NULLIF(btrim(tb_dados_gerais.tx_sigla_osc), '') AS tx_sigla_osc,
			tb_dados_gerais.ft_sigla_osc,
			to_char(tb_dados_gerais.dt_fundacao_osc, 'DD-MM-YYYY') AS dt_fundacao_osc,
			tb_dados_gerais.ft_fundacao_osc,
			to_char(tb_dados_gerais.dt_ano_cadastro_cnpj, 'DD-MM-YYYY') AS dt_ano_cadastro_cnpj,
			tb_dados_gerais.ft_ano_cadastro_cnpj,
			NULLIF(btrim(tb_dados_gerais.tx_nome_responsavel_legal), '') AS tx_nome_responsavel_legal,
			tb_dados_gerais.ft_nome_responsavel_legal,
			NULLIF(btrim(tb_dados_gerais.tx_resumo_osc), '') AS tx_resumo_osc,
			tb_dados_gerais.ft_resumo_osc,
			tb_dados_gerais.cd_situacao_imovel_osc::TEXT,
			NULLIF(btrim(dc_situacao_imovel.tx_nome_situacao_imovel), '') AS tx_nome_situacao_imovel_osc,
			tb_dados_gerais.ft_situacao_imovel_osc,
			NULLIF(btrim(tb_dados_gerais.tx_link_estatuto_osc), '') AS tx_link_estatuto_osc,
			tb_dados_gerais.ft_link_estatuto_osc,
			NULLIF(btrim(tb_localizacao.tx_endereco), '') AS tx_endereco,
			tb_localizacao.ft_endereco,
			tb_localizacao.nr_localizacao,
			tb_localizacao.ft_localizacao,
			NULLIF(btrim(tb_localizacao.tx_endereco_complemento), '') AS tx_endereco_complemento,
			tb_localizacao.ft_endereco_complemento,
			NULLIF(btrim(tb_localizacao.tx_bairro), '') AS tx_bairro,
			tb_localizacao.ft_bairro,
			tb_localizacao.cd_municipio::TEXT,
			ed_municipio.edmu_nm_municipio::TEXT,
			tb_localizacao.ft_municipio,
			substr(tb_localizacao.cd_municipio::TEXT, 0, 3)::TEXT AS cd_uf,
			ed_uf.eduf_sg_uf::TEXT AS tx_sigla_uf,
			ed_uf.eduf_nm_uf::TEXT AS tx_nome_uf,
			tb_localizacao.ft_municipio AS ft_uf,
			tb_localizacao.nr_cep::TEXT,
			tb_localizacao.ft_cep,
			st_y(st_transform(tb_localizacao.geo_localizacao, 4674))::TEXT AS geo_lat,
			st_x(st_transform(tb_localizacao.geo_localizacao, 4674))::TEXT AS geo_lng,
			NULLIF(btrim(tb_contato.tx_email), '') AS tx_email,
			tb_contato.ft_email,
			NULLIF(btrim(tb_contato.tx_site), '') AS tx_site,
			tb_contato.ft_site,
			NULLIF(btrim(tb_contato.tx_telefone), '') AS tx_telefone,
			tb_contato.ft_telefone
		FROM osc.tb_osc
    	LEFT JOIN osc.tb_dados_gerais ON tb_osc.id_osc = tb_dados_gerais.id_osc
     	LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
     	LEFT JOIN osc.tb_contato ON tb_osc.id_osc = tb_contato.id_osc
     	LEFT JOIN syst.dc_classe_atividade_economica ON dc_classe_atividade_economica.cd_classe_atividade_economica::TEXT = tb_dados_gerais.cd_classe_atividade_economica_osc::TEXT
     	LEFT JOIN syst.dc_natureza_juridica ON dc_natureza_juridica.cd_natureza_juridica = tb_dados_gerais.cd_natureza_juridica_osc
     	LEFT JOIN syst.dc_situacao_imovel ON dc_situacao_imovel.cd_situacao_imovel = tb_dados_gerais.cd_situacao_imovel_osc
     	LEFT JOIN spat.ed_municipio ON ed_municipio.edmu_cd_municipio = tb_localizacao.cd_municipio
     	LEFT JOIN spat.ed_uf ON ed_uf.eduf_cd_uf = substr(tb_localizacao.cd_municipio::TEXT, 0, 3)::NUMERIC(2,0)
  		WHERE tb_osc.bo_osc_ativa
		AND (
			tb_osc.id_osc = param::INTEGER
			OR tb_osc.tx_apelido_osc = param
		);

END;
$$ LANGUAGE 'plpgsql';
