DROP TABLE IF EXISTS osc.tb_elementos;

CREATE TABLE osc.tb_elementos
(
  id_elementos serial NOT NULL, -- Identificador de elementos
  id_osc integer NOT NULL, -- Identificador da OSC
  bo_participacao_social_conselho boolean, -- OSC participa de algum espaço de participação social em conselho
  ft_participacao_social_conselho boolean, -- Fonte de dados da informação se OSC participa de algum espaço de participação social em conselho
  bo_participacao_social_conferencia boolean, -- OSC participa de alguma espaço de participação social em conferência
  ft_participacao_social_conferencia boolean, -- Fonte de dados da informação se OSC participa de algum espaço de participação social em conferência
  bo_participacao_social_outro boolean, -- OSC participa de algum outro tipo de espaço de participação social
  ft_participacao_social_outro boolean, -- Fonte de dados da informação se OSC participa de algum outro tipo de espaço de participação social
  bo_recurso boolean, -- OSC possui recursos
  ft_recurso boolean, -- Fonte de dados da informação se OOSC possui recursos
  bo_certificado boolean, -- OSC possui alguma titulação ou certificação
  ft_certificado boolean, -- Fonte de dados da informação se OOSC possui alguma titulação ou certificação
  CONSTRAINT pk_tb_elementos PRIMARY KEY (id_elementos), -- Chave primária da tabela de elementos
  CONSTRAINT fk_id_osc FOREIGN KEY (id_osc)
		REFERENCES osc.tb_osc (id_osc) MATCH FULL
		ON UPDATE NO ACTION ON DELETE NO ACTION	
);
