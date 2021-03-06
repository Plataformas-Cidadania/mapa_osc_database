﻿-- object: portal.vw_osc_dados_gerais | type: MATERIALIZED VIEW --
DROP MATERIALIZED VIEW IF EXISTS portal.vw_osc_dados_gerais CASCADE;
CREATE MATERIALIZED VIEW portal.vw_osc_dados_gerais
AS

SELECT
	tb_osc.id_osc,
	NULLIF(TRIM(tb_osc.tx_apelido_osc), '') AS tx_apelido_osc,
	tb_osc.ft_apelido_osc,
	LPAD(CAST(tb_osc.cd_identificador_osc AS VARCHAR), 14, '0') AS cd_identificador_osc,
	tb_osc.ft_identificador_osc,
	NULLIF(TRIM(tb_dados_gerais.tx_razao_social_osc), '') AS tx_razao_social_osc,
	tb_dados_gerais.ft_razao_social_osc,
	NULLIF(TRIM(tb_dados_gerais.tx_nome_fantasia_osc), '') AS tx_nome_fantasia_osc,
	tb_dados_gerais.ft_nome_fantasia_osc,
	COALESCE(NULLIF(TRIM(tb_dados_gerais.tx_nome_fantasia_osc), ''), tb_dados_gerais.tx_razao_social_osc) AS tx_nome_osc,
	tb_dados_gerais.im_logo AS im_logo,
	tb_dados_gerais.ft_logo,
	tb_dados_gerais.cd_subclasse_atividade_economica_osc AS cd_atividade_economica_osc,
	tx_nome_subclasse_atividade_economica AS tx_nome_atividade_economica_osc,
	tb_dados_gerais.ft_subclasse_atividade_economica_osc AS ft_atividade_economica_osc,
	tb_dados_gerais.cd_natureza_juridica_osc,
	NULLIF(TRIM(tx_nome_natureza_juridica), '') AS tx_nome_natureza_juridica_osc,
	tb_dados_gerais.ft_natureza_juridica_osc,
	NULLIF(TRIM(tb_dados_gerais.tx_sigla_osc), '') AS tx_sigla_osc,
	tb_dados_gerais.ft_sigla_osc,
	TO_CHAR(tb_dados_gerais.dt_fundacao_osc, 'DD-MM-YYYY') AS dt_fundacao_osc,
	tb_dados_gerais.ft_fundacao_osc,
	TO_CHAR(tb_dados_gerais.dt_ano_cadastro_cnpj, 'DD-MM-YYYY') AS dt_ano_cadastro_cnpj,
	tb_dados_gerais.ft_ano_cadastro_cnpj,
	NULLIF(TRIM(tb_dados_gerais.tx_nome_responsavel_legal), '') AS tx_nome_responsavel_legal,
	tb_dados_gerais.ft_nome_responsavel_legal,
	NULLIF(TRIM(tb_dados_gerais.tx_resumo_osc), '') AS tx_resumo_osc,
	tb_dados_gerais.ft_resumo_osc,
	tb_dados_gerais.cd_situacao_imovel_osc,
	NULLIF(TRIM(tx_nome_situacao_imovel), '') AS tx_nome_situacao_imovel_osc,
	tb_dados_gerais.ft_situacao_imovel_osc,
	NULLIF(TRIM(tb_dados_gerais.tx_link_estatuto_osc), '') AS tx_link_estatuto_osc,
	tb_dados_gerais.ft_link_estatuto_osc,
	NULLIF(TRIM(tb_localizacao.tx_endereco), '') AS tx_endereco,
	tb_localizacao.ft_endereco,
	tb_localizacao.nr_localizacao,
	tb_localizacao.ft_localizacao,
	NULLIF(TRIM(tb_localizacao.tx_endereco_complemento), '') AS tx_endereco_complemento,
	tb_localizacao.ft_endereco_complemento,
	NULLIF(TRIM(tb_localizacao.tx_bairro), '') AS tx_bairro,
	tb_localizacao.ft_bairro,
	tb_localizacao.cd_municipio,
	edmu_nm_municipio AS tx_nome_municipio,
	tb_localizacao.ft_municipio,
	SUBSTR(tb_localizacao.cd_municipio::TEXT, 0, 3)::NUMERIC(2, 0) AS cd_uf,
	eduf_sg_uf AS tx_sigla_uf,
	eduf_nm_uf AS tx_nome_uf,
	tb_localizacao.ft_municipio AS ft_uf,
	tb_localizacao.nr_cep,
	tb_localizacao.ft_cep,
	ST_Y(ST_TRANSFORM(tb_localizacao.geo_localizacao, 4674)) AS geo_lat,
	ST_X(ST_TRANSFORM(tb_localizacao.geo_localizacao, 4674)) AS geo_lng,
	NULLIF(TRIM(tb_contato.tx_email), '') AS tx_email,
	tb_contato.ft_email,
	NULLIF(TRIM(tb_contato.tx_site), '') AS tx_site,
	tb_contato.ft_site,
	NULLIF(TRIM(tb_contato.tx_telefone), '') AS tx_telefone,
	tb_contato.ft_telefone
FROM osc.tb_osc
INNER JOIN osc.tb_dados_gerais
ON tb_osc.id_osc = tb_dados_gerais.id_osc
INNER JOIN osc.tb_localizacao
ON tb_osc.id_osc = tb_localizacao.id_osc
LEFT JOIN osc.tb_contato
ON tb_osc.id_osc = tb_contato.id_osc
LEFT JOIN syst.dc_subclasse_atividade_economica
ON cd_subclasse_atividade_economica = tb_dados_gerais.cd_subclasse_atividade_economica_osc
LEFT JOIN syst.dc_natureza_juridica
ON cd_natureza_juridica = tb_dados_gerais.cd_natureza_juridica_osc
LEFT JOIN syst.dc_situacao_imovel
ON cd_situacao_imovel = tb_dados_gerais.cd_situacao_imovel_osc
INNER JOIN spat.ed_municipio
ON edmu_cd_municipio = tb_localizacao.cd_municipio
INNER JOIN spat.ed_uf
ON spat.ed_uf.eduf_cd_uf = SUBSTR(tb_localizacao.cd_municipio::TEXT, 0, 3)::NUMERIC(2, 0)
WHERE tb_osc.bo_osc_ativa;
-- ddl-end --
ALTER MATERIALIZED VIEW portal.vw_osc_dados_gerais OWNER TO postgres;
-- ddl-end --
