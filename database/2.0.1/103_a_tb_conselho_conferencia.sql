--participacao social conferencia
DROP MATERIALIZED VIEW portal.vw_osc_participacao_social_conferencia;

DROP TABLE osc.tb_participacao_social_conferencia;

CREATE TABLE osc.tb_participacao_social_conferencia
(
  id_conferencia serial NOT NULL, -- Identificador da conferência
  cd_conferencia integer NOT NULL, -- Código da conferência
  ft_conferencia text, -- Fonte da conferência
  id_osc integer NOT NULL, -- Identificador da OSC
  dt_ano_realizacao date, -- Ano de realização da conferência
  ft_ano_realizacao text, -- Fonte do ano de realização da conferência
  cd_forma_participacao_conferencia integer, -- Código da forma de participação em conferência
  ft_forma_participacao_conferencia text, -- Fonte da forma participação conferência
  bo_oficial boolean NOT NULL, -- Registro vindo de base oficial
  CONSTRAINT pk_tb_participacao_social_conferencia PRIMARY KEY (id_conferencia), -- Chave primária da tabela conferência
  CONSTRAINT fk_cd_conferencia FOREIGN KEY (cd_conferencia)
      REFERENCES syst.dc_conferencia (cd_conferencia) MATCH FULL
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_cd_forma_participacao_conferencia FOREIGN KEY (cd_forma_participacao_conferencia)
      REFERENCES syst.dc_forma_participacao_conferencia (cd_forma_participacao_conferencia) MATCH FULL
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_id_osc FOREIGN KEY (id_osc)
      REFERENCES osc.tb_osc (id_osc) MATCH FULL
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE osc.tb_participacao_social_conferencia
  IS 'Tabela com as conferências que a OSC faz parte';
COMMENT ON COLUMN osc.tb_participacao_social_conferencia.id_conferencia IS 'Identificador da conferência';
COMMENT ON COLUMN osc.tb_participacao_social_conferencia.cd_conferencia IS 'Código da conferência';
COMMENT ON COLUMN osc.tb_participacao_social_conferencia.ft_conferencia IS 'Fonte da conferência';
COMMENT ON COLUMN osc.tb_participacao_social_conferencia.id_osc IS 'Identificador da OSC';
COMMENT ON COLUMN osc.tb_participacao_social_conferencia.dt_ano_realizacao IS 'Ano de realização da conferência';
COMMENT ON COLUMN osc.tb_participacao_social_conferencia.ft_ano_realizacao IS 'Fonte do ano de realização da conferência';
COMMENT ON COLUMN osc.tb_participacao_social_conferencia.cd_forma_participacao_conferencia IS 'Código da forma de participação em conferência';
COMMENT ON COLUMN osc.tb_participacao_social_conferencia.ft_forma_participacao_conferencia IS 'Fonte da forma participação conferência';
COMMENT ON COLUMN osc.tb_participacao_social_conferencia.bo_oficial IS 'Registro vindo de base oficial';

COMMENT ON CONSTRAINT pk_tb_participacao_social_conferencia ON osc.tb_participacao_social_conferencia IS 'Chave primária da tabela conferência';

CREATE MATERIALIZED VIEW portal.vw_osc_participacao_social_conferencia AS 
 SELECT tb_osc.id_osc,
    tb_osc.tx_apelido_osc,
    tb_participacao_social_conferencia.id_conferencia,
    tb_participacao_social_conferencia.cd_conferencia,
    ( SELECT dc_conferencia.tx_nome_conferencia
           FROM syst.dc_conferencia
          WHERE dc_conferencia.cd_conferencia = tb_participacao_social_conferencia.cd_conferencia) AS tx_nome_conferencia,
    tb_participacao_social_conferencia.ft_conferencia,
    to_char(tb_participacao_social_conferencia.dt_ano_realizacao::timestamp with time zone, 'DD-MM-YYYY'::text) AS dt_ano_realizacao,
    tb_participacao_social_conferencia.ft_ano_realizacao,
    tb_participacao_social_conferencia.cd_forma_participacao_conferencia,
    ( SELECT dc_forma_participacao_conferencia.tx_nome_forma_participacao_conferencia
           FROM syst.dc_forma_participacao_conferencia
          WHERE dc_forma_participacao_conferencia.cd_forma_participacao_conferencia = tb_participacao_social_conferencia.cd_forma_participacao_conferencia) AS tx_nome_forma_participacao_conferencia,
    tb_participacao_social_conferencia.ft_forma_participacao_conferencia
   FROM osc.tb_osc
     JOIN osc.tb_participacao_social_conferencia ON tb_osc.id_osc = tb_participacao_social_conferencia.id_osc
  WHERE tb_osc.bo_osc_ativa
WITH DATA;
--participacao social conferencia outra
DROP MATERIALIZED VIEW portal.vw_osc_participacao_social_conferencia_outra;

DROP TABLE osc.tb_participacao_social_conferencia_outra;

CREATE TABLE osc.tb_participacao_social_conferencia_outra
(
  id_conferencia_outra serial NOT NULL, -- Identificador da conferência
  tx_nome_conferencia text NOT NULL, -- Nome da conferência
  ft_nome_conferencia text, -- Fonte do nome da conferência
  id_conferencia integer NOT NULL, -- Identificador de conferencia
  CONSTRAINT pk_tb_participacao_social_conferencia_outra PRIMARY KEY (id_conferencia_outra), -- Chave primária da tabela conferência outra
  CONSTRAINT fk_id_conferencia FOREIGN KEY (id_conferencia)
      REFERENCES osc.tb_participacao_social_conferencia (id_conferencia) MATCH FULL
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE osc.tb_participacao_social_conferencia_outra
  IS 'Tabela com as conferências que a OSC faz parte';
COMMENT ON COLUMN osc.tb_participacao_social_conferencia_outra.id_conferencia_outra IS 'Identificador da conferência';
COMMENT ON COLUMN osc.tb_participacao_social_conferencia_outra.tx_nome_conferencia IS 'Nome da conferência';
COMMENT ON COLUMN osc.tb_participacao_social_conferencia_outra.ft_nome_conferencia IS 'Fonte do nome da conferência';
COMMENT ON COLUMN osc.tb_participacao_social_conferencia_outra.id_conferencia IS 'Identificador de conferencia';

COMMENT ON CONSTRAINT pk_tb_participacao_social_conferencia_outra ON osc.tb_participacao_social_conferencia_outra IS 'Chave primária da tabela conferência outra';

CREATE MATERIALIZED VIEW portal.vw_osc_participacao_social_conferencia_outra AS 
 SELECT tb_osc.id_osc,
    tb_osc.tx_apelido_osc,
    tb_participacao_social_conferencia_outra.id_conferencia_outra,
    tb_participacao_social_conferencia_outra.tx_nome_conferencia,
    tb_participacao_social_conferencia_outra.ft_nome_conferencia,
    to_char(tb_participacao_social_conferencia.dt_ano_realizacao::timestamp with time zone, 'DD-MM-YYYY'::text) AS dt_ano_realizacao,
    tb_participacao_social_conferencia.ft_ano_realizacao,
    tb_participacao_social_conferencia.cd_forma_participacao_conferencia,
    ( SELECT dc_forma_participacao_conferencia.tx_nome_forma_participacao_conferencia
           FROM syst.dc_forma_participacao_conferencia
          WHERE dc_forma_participacao_conferencia.cd_forma_participacao_conferencia = tb_participacao_social_conferencia.cd_forma_participacao_conferencia) AS tx_nome_forma_participacao_conferencia,
    tb_participacao_social_conferencia.ft_forma_participacao_conferencia
   FROM osc.tb_osc
     JOIN osc.tb_participacao_social_conferencia ON tb_osc.id_osc = tb_participacao_social_conferencia.id_osc
     JOIN osc.tb_participacao_social_conferencia_outra ON tb_participacao_social_conferencia.id_conferencia = tb_participacao_social_conferencia_outra.id_conferencia
  WHERE tb_osc.bo_osc_ativa
WITH DATA;

-- participacao social conselho

DROP MATERIALIZED VIEW portal.vw_osc_participacao_social_conselho;

DROP MATERIALIZED VIEW portal.vw_osc_participacao_social_conselho_outro;

DROP MATERIALIZED VIEW portal.vw_osc_representante_conselho;

DROP TABLE osc.tb_representante_conselho;

DROP TABLE osc.tb_participacao_social_conselho;

DROP TABLE osc.tb_participacao_social_conselho_outro;

CREATE TABLE osc.tb_participacao_social_conselho
(
  id_conselho serial NOT NULL, -- Identificador da tabela conselho
  id_osc integer, -- Identificador da OSC
  cd_conselho integer, -- Chave estrangeira (código do conselho)
  ft_conselho text, -- Fonte do conselho
  cd_tipo_participacao integer NOT NULL, -- Código do tipo de participação
  ft_tipo_participacao text, -- Fonte do tipo de participação
  ft_periodicidade_reuniao text, -- Fonte da periodicidade da reunião
  dt_data_inicio_conselho date, -- Data de início da participação no conselho
  ft_data_inicio_conselho text, -- Fonte da data de início da participação no conselho
  dt_data_fim_conselho date, -- Data de fim da participação no conselho
  ft_data_fim_conselho text, -- Fonte da data de início da participação no conselho
  bo_oficial boolean NOT NULL, -- Registro vindo de base oficial
  cd_periodicidade_reuniao_conselho integer,
  CONSTRAINT pk_tb_conselho PRIMARY KEY (id_conselho), -- Chave primária da tabela Conselho
  CONSTRAINT fk_cd_conselho FOREIGN KEY (cd_conselho)
      REFERENCES syst.dc_conselho (cd_conselho) MATCH FULL
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_cd_periodicidade_reuniao_conselho FOREIGN KEY (cd_periodicidade_reuniao_conselho)
      REFERENCES syst.dc_periodicidade_reuniao_conselho (cd_periodicidade_reuniao_conselho) MATCH FULL
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_cd_tipo_participacao FOREIGN KEY (cd_tipo_participacao)
      REFERENCES syst.dc_tipo_participacao (cd_tipo_participacao) MATCH FULL
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_id_osc FOREIGN KEY (id_osc)
      REFERENCES osc.tb_osc (id_osc) MATCH FULL
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE osc.tb_participacao_social_conselho
  IS 'Tabela de relacionamento M:N entre a OSC e os Conselhos e comissões que ela participa';
COMMENT ON COLUMN osc.tb_participacao_social_conselho.id_conselho IS 'Identificador da tabela conselho';
COMMENT ON COLUMN osc.tb_participacao_social_conselho.id_osc IS 'Identificador da OSC';
COMMENT ON COLUMN osc.tb_participacao_social_conselho.cd_conselho IS 'Chave estrangeira (código do conselho)';
COMMENT ON COLUMN osc.tb_participacao_social_conselho.ft_conselho IS 'Fonte do conselho';
COMMENT ON COLUMN osc.tb_participacao_social_conselho.cd_tipo_participacao IS 'Código do tipo de participação';
COMMENT ON COLUMN osc.tb_participacao_social_conselho.ft_tipo_participacao IS 'Fonte do tipo de participação';
COMMENT ON COLUMN osc.tb_participacao_social_conselho.ft_periodicidade_reuniao IS 'Fonte da periodicidade da reunião';
COMMENT ON COLUMN osc.tb_participacao_social_conselho.dt_data_inicio_conselho IS 'Data de início da participação no conselho';
COMMENT ON COLUMN osc.tb_participacao_social_conselho.ft_data_inicio_conselho IS 'Fonte da data de início da participação no conselho';
COMMENT ON COLUMN osc.tb_participacao_social_conselho.dt_data_fim_conselho IS 'Data de fim da participação no conselho';
COMMENT ON COLUMN osc.tb_participacao_social_conselho.ft_data_fim_conselho IS 'Fonte da data de início da participação no conselho';
COMMENT ON COLUMN osc.tb_participacao_social_conselho.bo_oficial IS 'Registro vindo de base oficial';
COMMENT ON CONSTRAINT pk_tb_conselho ON osc.tb_participacao_social_conselho IS 'Chave primária da tabela Conselho';

CREATE TABLE osc.tb_representante_conselho
(
  id_representante_conselho serial NOT NULL, -- Identificador do representante de conselho
  id_osc integer NOT NULL, -- Identificador da OSC
  id_participacao_social_conselho integer NOT NULL, -- Identificador do conselho
  tx_nome_representante_conselho text NOT NULL, -- Nome do representante de conselho
  ft_nome_representante_conselho text, -- Fonte do nome do representante de conselho
  bo_oficial boolean NOT NULL, -- Registro vindo de base oficial
  CONSTRAINT pk_tb_representante_conselho PRIMARY KEY (id_representante_conselho), -- Chave primária do representante de conselho
  CONSTRAINT fk_id_osc FOREIGN KEY (id_osc)
      REFERENCES osc.tb_osc (id_osc) MATCH FULL
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_id_participacao_social_conselho FOREIGN KEY (id_participacao_social_conselho)
      REFERENCES osc.tb_participacao_social_conselho (id_conselho) MATCH FULL
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
COMMENT ON TABLE osc.tb_representante_conselho
  IS 'Tabela de representantes de conselho';
COMMENT ON COLUMN osc.tb_representante_conselho.id_representante_conselho IS 'Identificador do representante de conselho';
COMMENT ON COLUMN osc.tb_representante_conselho.id_osc IS 'Identificador da OSC';
COMMENT ON COLUMN osc.tb_representante_conselho.id_participacao_social_conselho IS 'Identificador do conselho';
COMMENT ON COLUMN osc.tb_representante_conselho.tx_nome_representante_conselho IS 'Nome do representante de conselho';
COMMENT ON COLUMN osc.tb_representante_conselho.ft_nome_representante_conselho IS 'Fonte do nome do representante de conselho';
COMMENT ON COLUMN osc.tb_representante_conselho.bo_oficial IS 'Registro vindo de base oficial';
COMMENT ON CONSTRAINT pk_tb_representante_conselho ON osc.tb_representante_conselho IS 'Chave primária do representante de conselho';

CREATE MATERIALIZED VIEW portal.vw_osc_representante_conselho AS 
 SELECT tb_osc.id_osc,
    tb_osc.tx_apelido_osc,
    tb_representante_conselho.id_representante_conselho,
    tb_representante_conselho.id_participacao_social_conselho,
    tb_representante_conselho.tx_nome_representante_conselho,
    tb_representante_conselho.ft_nome_representante_conselho
   FROM osc.tb_osc
     JOIN osc.tb_representante_conselho ON tb_osc.id_osc = tb_representante_conselho.id_osc
  WHERE tb_osc.bo_osc_ativa
WITH DATA;

CREATE TABLE osc.tb_participacao_social_conselho_outro
(
  id_conselho_outro serial NOT NULL, -- Identificador outro conselho
  tx_nome_conselho text NOT NULL, -- Nome do conselho
  ft_nome_conselho text, -- Fonte nome do conselho
  id_conselho integer NOT NULL, -- Identificador do Conselho
  CONSTRAINT pk_id_participacao_social_conselho_outro PRIMARY KEY (id_conselho_outro), -- Chave primária da tabela
  CONSTRAINT fk_id_conselho FOREIGN KEY (id_conselho)
      REFERENCES osc.tb_participacao_social_conselho (id_conselho) MATCH FULL
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE osc.tb_participacao_social_conselho_outro
  OWNER TO postgres;
GRANT ALL ON TABLE osc.tb_participacao_social_conselho_outro TO postgres;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE osc.tb_participacao_social_conselho_outro TO grupo_mapaosc WITH GRANT OPTION;
COMMENT ON TABLE osc.tb_participacao_social_conselho_outro
  IS 'Tabela de participação social - outro conselho';
COMMENT ON COLUMN osc.tb_participacao_social_conselho_outro.id_conselho_outro IS 'Identificador outro conselho';
COMMENT ON COLUMN osc.tb_participacao_social_conselho_outro.tx_nome_conselho IS 'Nome do conselho';
COMMENT ON COLUMN osc.tb_participacao_social_conselho_outro.ft_nome_conselho IS 'Fonte nome do conselho';
COMMENT ON COLUMN osc.tb_participacao_social_conselho_outro.id_conselho IS 'Identificador do Conselho';

COMMENT ON CONSTRAINT pk_id_participacao_social_conselho_outro ON osc.tb_participacao_social_conselho_outro IS 'Chave primária da tabela';

CREATE MATERIALIZED VIEW portal.vw_osc_participacao_social_conselho AS 
 SELECT tb_osc.id_osc,
    tb_osc.tx_apelido_osc,
    tb_participacao_social_conselho.id_conselho,
    tb_participacao_social_conselho.cd_conselho,
    ( SELECT dc_conselho.tx_nome_conselho
           FROM syst.dc_conselho
          WHERE dc_conselho.cd_conselho = tb_participacao_social_conselho.cd_conselho) AS tx_nome_conselho,
    tb_participacao_social_conselho.ft_conselho,
    tb_participacao_social_conselho.cd_tipo_participacao,
    (( SELECT dc_tipo_participacao.tx_nome_tipo_participacao
           FROM syst.dc_tipo_participacao
          WHERE dc_tipo_participacao.cd_tipo_participacao = tb_participacao_social_conselho.cd_tipo_participacao))::text AS tx_nome_tipo_participacao,
    tb_participacao_social_conselho.ft_tipo_participacao,
    tb_participacao_social_conselho.cd_periodicidade_reuniao_conselho,
    ( SELECT dc_periodicidade_reuniao_conselho.tx_nome_periodicidade_reuniao_conselho
           FROM syst.dc_periodicidade_reuniao_conselho
          WHERE dc_periodicidade_reuniao_conselho.cd_periodicidade_reuniao_conselho = tb_participacao_social_conselho.cd_periodicidade_reuniao_conselho) AS tx_nome_periodicidade_reuniao_conselho,
    tb_participacao_social_conselho.ft_periodicidade_reuniao,
    to_char(tb_participacao_social_conselho.dt_data_inicio_conselho::timestamp with time zone, 'DD-MM-YYYY'::text) AS dt_data_inicio_conselho,
    tb_participacao_social_conselho.ft_data_inicio_conselho,
    to_char(tb_participacao_social_conselho.dt_data_fim_conselho::timestamp with time zone, 'DD-MM-YYYY'::text) AS dt_data_fim_conselho,
    tb_participacao_social_conselho.ft_data_fim_conselho
   FROM osc.tb_osc
     JOIN osc.tb_participacao_social_conselho ON tb_osc.id_osc = tb_participacao_social_conselho.id_osc
  WHERE tb_osc.bo_osc_ativa
WITH DATA;

CREATE MATERIALIZED VIEW portal.vw_osc_participacao_social_conselho_outro AS 
 SELECT tb_osc.id_osc,
    tb_osc.tx_apelido_osc,
    tb_participacao_social_conselho_outro.id_conselho_outro,
    tb_participacao_social_conselho_outro.tx_nome_conselho,
    tb_participacao_social_conselho_outro.ft_nome_conselho,
    to_char(tb_participacao_social_conselho.dt_data_inicio_conselho::timestamp with time zone, 'DD-MM-YYYY'::text) AS dt_data_inicio_conselho,
    tb_participacao_social_conselho.ft_data_inicio_conselho,
    to_char(tb_participacao_social_conselho.dt_data_fim_conselho::timestamp with time zone, 'DD-MM-YYYY'::text) AS dt_data_fim_conselho,
    tb_participacao_social_conselho.ft_data_fim_conselho,
    tb_participacao_social_conselho.cd_tipo_participacao,
    (( SELECT dc_tipo_participacao.tx_nome_tipo_participacao
           FROM syst.dc_tipo_participacao
          WHERE dc_tipo_participacao.cd_tipo_participacao = tb_participacao_social_conselho.cd_tipo_participacao))::text AS tx_nome_tipo_participacao,
    tb_participacao_social_conselho.ft_tipo_participacao,
    tb_participacao_social_conselho.cd_periodicidade_reuniao_conselho,
    ( SELECT dc_periodicidade_reuniao_conselho.tx_nome_periodicidade_reuniao_conselho
           FROM syst.dc_periodicidade_reuniao_conselho
          WHERE dc_periodicidade_reuniao_conselho.cd_periodicidade_reuniao_conselho = tb_participacao_social_conselho.cd_periodicidade_reuniao_conselho) AS tx_nome_periodicidade_reuniao_conselho,
    tb_participacao_social_conselho.ft_periodicidade_reuniao,
    tb_participacao_social_conselho_outro.id_conselho
   FROM osc.tb_osc
     JOIN osc.tb_participacao_social_conselho ON tb_osc.id_osc = tb_participacao_social_conselho.id_osc
     JOIN osc.tb_participacao_social_conselho_outro ON tb_participacao_social_conselho.id_conselho = tb_participacao_social_conselho_outro.id_conselho
  WHERE tb_osc.bo_osc_ativa
WITH DATA;
