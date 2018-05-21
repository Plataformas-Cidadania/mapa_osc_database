-- object: portal.vw_osc_dados_gerais | type: MATERIALIZED VIEW --
DROP MATERIALIZED VIEW IF EXISTS portal.vw_osc_dados_gerais CASCADE;
CREATE MATERIALIZED VIEW portal.vw_osc_dados_gerais
AS

SELECT tb_osc.id_osc,
    NULLIF(btrim(tb_osc.tx_apelido_osc), ''::text) AS tx_apelido_osc,
    tb_osc.ft_apelido_osc,
    lpad(tb_osc.cd_identificador_osc::character varying::text, 14, '0'::text) AS cd_identificador_osc,
    tb_osc.ft_identificador_osc,
    NULLIF(btrim(tb_dados_gerais.tx_razao_social_osc), ''::text) AS tx_razao_social_osc,
    tb_dados_gerais.ft_razao_social_osc,
    NULLIF(btrim(tb_dados_gerais.tx_nome_fantasia_osc), ''::text) AS tx_nome_fantasia_osc,
    tb_dados_gerais.ft_nome_fantasia_osc,
    COALESCE(NULLIF(btrim(tb_dados_gerais.tx_nome_fantasia_osc), ''::text), tb_dados_gerais.tx_razao_social_osc) AS tx_nome_osc,
    tb_dados_gerais.im_logo,
    tb_dados_gerais.ft_logo,
    tb_dados_gerais.cd_classe_atividade_economica_osc AS cd_atividade_economica_osc,
    dc_classe_atividade_economica.tx_nome_classe_atividade_economica AS tx_nome_atividade_economica_osc,
    tb_dados_gerais.ft_classe_atividade_economica_osc AS ft_atividade_economica_osc,
    tb_dados_gerais.cd_natureza_juridica_osc,
    NULLIF(btrim(dc_natureza_juridica.tx_nome_natureza_juridica), ''::text) AS tx_nome_natureza_juridica_osc,
    tb_dados_gerais.ft_natureza_juridica_osc,
    NULLIF(btrim(tb_dados_gerais.tx_sigla_osc), ''::text) AS tx_sigla_osc,
	tb_dados_gerais.bo_nao_possui_sigla_osc,
    tb_dados_gerais.ft_sigla_osc,
    to_char(tb_dados_gerais.dt_fundacao_osc::timestamp with time zone, 'DD-MM-YYYY'::text) AS dt_fundacao_osc,
    tb_dados_gerais.ft_fundacao_osc,
    to_char(tb_dados_gerais.dt_ano_cadastro_cnpj::timestamp with time zone, 'DD-MM-YYYY'::text) AS dt_ano_cadastro_cnpj,
    tb_dados_gerais.ft_ano_cadastro_cnpj,
    NULLIF(btrim(tb_dados_gerais.tx_nome_responsavel_legal), ''::text) AS tx_nome_responsavel_legal,
    tb_dados_gerais.ft_nome_responsavel_legal,
    NULLIF(btrim(tb_dados_gerais.tx_resumo_osc), ''::text) AS tx_resumo_osc,
    tb_dados_gerais.ft_resumo_osc,
    tb_dados_gerais.cd_situacao_imovel_osc,
    NULLIF(btrim(dc_situacao_imovel.tx_nome_situacao_imovel), ''::text) AS tx_nome_situacao_imovel_osc,
    tb_dados_gerais.ft_situacao_imovel_osc,
    NULLIF(btrim(tb_dados_gerais.tx_link_estatuto_osc), ''::text) AS tx_link_estatuto_osc,
	tb_dados_gerais.bo_nao_possui_link_estatuto_osc,
    tb_dados_gerais.ft_link_estatuto_osc,
    NULLIF(btrim(tb_localizacao.tx_endereco), ''::text) AS tx_endereco,
    tb_localizacao.ft_endereco,
    tb_localizacao.nr_localizacao,
    tb_localizacao.ft_localizacao,
    NULLIF(btrim(tb_localizacao.tx_endereco_complemento), ''::text) AS tx_endereco_complemento,
    tb_localizacao.ft_endereco_complemento,
    NULLIF(btrim(tb_localizacao.tx_bairro), ''::text) AS tx_bairro,
    tb_localizacao.ft_bairro,
    tb_localizacao.cd_municipio,
    ed_municipio.edmu_nm_municipio AS tx_nome_municipio,
    tb_localizacao.ft_municipio,
    substr(tb_localizacao.cd_municipio::text, 0, 3)::numeric(2,0) AS cd_uf,
    ed_uf.eduf_sg_uf AS tx_sigla_uf,
    ed_uf.eduf_nm_uf AS tx_nome_uf,
    tb_localizacao.ft_municipio AS ft_uf,
    tb_localizacao.nr_cep,
    tb_localizacao.ft_cep,
    st_y(st_transform(tb_localizacao.geo_localizacao, 4674)) AS geo_lat,
    st_x(st_transform(tb_localizacao.geo_localizacao, 4674)) AS geo_lng,
    NULLIF(btrim(tb_contato.tx_email), ''::text) AS tx_email,
    tb_contato.bo_nao_possui_email,
	tb_contato.ft_email,
    NULLIF(btrim(tb_contato.tx_site), ''::text) AS tx_site,
    tb_contato.bo_nao_possui_site,
	tb_contato.ft_site,
    NULLIF(btrim(tb_contato.tx_telefone), ''::text) AS tx_telefone,
    tb_contato.ft_telefone
   FROM osc.tb_osc
     JOIN osc.tb_dados_gerais ON tb_osc.id_osc = tb_dados_gerais.id_osc
     JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
     LEFT JOIN osc.tb_contato ON tb_osc.id_osc = tb_contato.id_osc
     LEFT JOIN syst.dc_classe_atividade_economica ON dc_classe_atividade_economica.cd_classe_atividade_economica::text = tb_dados_gerais.cd_classe_atividade_economica_osc::text
     LEFT JOIN syst.dc_natureza_juridica ON dc_natureza_juridica.cd_natureza_juridica = tb_dados_gerais.cd_natureza_juridica_osc
     LEFT JOIN syst.dc_situacao_imovel ON dc_situacao_imovel.cd_situacao_imovel = tb_dados_gerais.cd_situacao_imovel_osc
     JOIN spat.ed_municipio ON ed_municipio.edmu_cd_municipio = tb_localizacao.cd_municipio
     JOIN spat.ed_uf ON ed_uf.eduf_cd_uf = substr(tb_localizacao.cd_municipio::text, 0, 3)::numeric(2,0)
  WHERE tb_osc.bo_osc_ativa;
-- ddl-end --
ALTER MATERIALIZED VIEW portal.vw_osc_dados_gerais OWNER TO postgres;
-- ddl-end --

CREATE UNIQUE INDEX ix_vw_osc_dados_gerais
    ON portal.vw_osc_dados_gerais USING btree
    (id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION dados_gerais()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_dados_gerais;
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_descricao;
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_recursos_projeto;
  RETURN NULL;
END;

-- object: portal.vw_log_alteracao | type: MATERIALIZED VIEW --
DROP MATERIALIZED VIEW IF EXISTS portal.vw_log_alteracao CASCADE;
CREATE MATERIALIZED VIEW portal.vw_log_alteracao
AS

SELECT distinct y.dt_alteracao
     , y.id_osc
     , vw_osc_dados_gerais.tx_nome_osc
FROM log.tb_log_alteracao y
JOIN
    ( SELECT id_osc
           , MAX(dt_alteracao) AS currentTS
      FROM log.tb_log_alteracao
      WHERE id_osc <> 789809
      GROUP BY id_osc
    ) AS grp
  ON grp.id_osc = y.id_osc
    AND grp.currentTS = y.dt_alteracao
JOIN portal.vw_osc_dados_gerais ON y.id_osc = vw_osc_dados_gerais.id_osc
limit 10;

-- ddl-end --
ALTER MATERIALIZED VIEW portal.vw_log_alteracao OWNER TO postgres;
-- ddl-end --

CREATE UNIQUE INDEX ix_vw_log_alteracao
    ON portal.vw_log_alteracao USING btree
    (id_osc, dt_alteracao ASC NULLS LAST)
TABLESPACE pg_default;

$$ LANGUAGE plpgsql;
