DROP MATERIALIZED VIEW IF EXISTS portal.vw_osc_dados_gerais CASCADE;
DROP MATERIALIZED VIEW IF EXISTS osc.vw_busca_resultado CASCADE;
DROP MATERIALIZED VIEW IF EXISTS portal.vw_busca_resultado CASCADE;

ALTER TABLE osc.tb_localizacao ADD COLUMN qualidade_classificacao text;

CREATE MATERIALIZED VIEW osc.vw_busca_resultado
TABLESPACE pg_default
AS
 SELECT tb_osc.id_osc,
    btrim(COALESCE(NULLIF(tb_dados_gerais.tx_nome_fantasia_osc, ''::text), tb_dados_gerais.tx_razao_social_osc)) AS tx_nome_osc,
    lpad(tb_osc.cd_identificador_osc::text, 14, '0'::text) AS cd_identificador_osc,
    ( SELECT dc_natureza_juridica.tx_nome_natureza_juridica
           FROM syst.dc_natureza_juridica
          WHERE dc_natureza_juridica.cd_natureza_juridica = tb_dados_gerais.cd_natureza_juridica_osc) AS tx_natureza_juridica_osc,
    rtrim(replace((((((((((((COALESCE(tb_localizacao.tx_endereco, '|'::text) || ', '::text) || COALESCE(tb_localizacao.nr_localizacao, '|'::text)) || ', '::text) || COALESCE(tb_localizacao.tx_endereco_complemento, '|'::text)) || ', '::text) || COALESCE(tb_localizacao.tx_bairro, '|'::text)) || ', '::text) || COALESCE((( SELECT ed_municipio.edmu_nm_municipio AS tx_municipio
           FROM spat.ed_municipio
          WHERE ed_municipio.edmu_cd_municipio = tb_localizacao.cd_municipio))::text, '|'::text)) || ', '::text) || COALESCE((( SELECT ed_uf.eduf_sg_uf AS tx_uf
           FROM spat.ed_uf
          WHERE ed_uf.eduf_cd_uf = substr(tb_localizacao.cd_municipio::text, 0, 2)::numeric))::text, '|'::text)) || ', '::text) || COALESCE(tb_localizacao.nr_cep::text, '|'::text), '|, '::text, ''::text), ', |'::text) AS tx_endereco_osc,
    st_y(st_transform(tb_localizacao.geo_localizacao, 4674)) AS geo_lat,
    st_x(st_transform(tb_localizacao.geo_localizacao, 4674)) AS geo_lng,
    ( SELECT dc_classe_atividade_economica.tx_nome_classe_atividade_economica
           FROM syst.dc_classe_atividade_economica
          WHERE dc_classe_atividade_economica.cd_classe_atividade_economica::text = tb_dados_gerais.cd_classe_atividade_economica_osc::text) AS tx_nome_atividade_economica,
    tb_dados_gerais.im_logo
   FROM osc.tb_osc
     LEFT JOIN osc.tb_dados_gerais ON tb_osc.id_osc = tb_dados_gerais.id_osc
     LEFT JOIN osc.tb_localizacao ON tb_osc.id_osc = tb_localizacao.id_osc
  WHERE tb_osc.bo_osc_ativa = true
WITH DATA;

ALTER TABLE osc.vw_busca_resultado
    OWNER TO postgres;

CREATE MATERIALIZED VIEW portal.vw_osc_dados_gerais
TABLESPACE pg_default
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
    tb_contato.ft_email,
    NULLIF(btrim(tb_contato.tx_site), ''::text) AS tx_site,
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
  WHERE tb_osc.bo_osc_ativa
WITH DATA;

ALTER TABLE portal.vw_osc_dados_gerais
    OWNER TO postgres;
