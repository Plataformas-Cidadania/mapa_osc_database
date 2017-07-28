DROP TABLE IF EXISTS osc.tb_elementos;

CREATE TABLE osc.tb_elementos
(
  id_elementos serial NOT NULL, -- Identificador de elementos
  id_osc integer NOT NULL, -- Identificador da OSC
  bo_participacao_social_conselho boolean, -- OSC participa de algum espa�o de participa��o social em conselho
  ft_participacao_social_conselho boolean, -- Fonte de dados da informa��o se OSC participa de algum espa�o de participa��o social em conselho
  bo_participacao_social_conferencia boolean, -- OSC participa de alguma espa�o de participa��o social em confer�ncia
  ft_participacao_social_conferencia boolean, -- Fonte de dados da informa��o se OSC participa de algum espa�o de participa��o social em confer�ncia
  bo_participacao_social_outro boolean, -- OSC participa de algum outro tipo de espa�o de participa��o social
  ft_participacao_social_outro boolean, -- Fonte de dados da informa��o se OSC participa de algum outro tipo de espa�o de participa��o social
  bo_recurso boolean, -- OSC possui recursos
  ft_recurso boolean, -- Fonte de dados da informa��o se OOSC possui recursos
  bo_certificado boolean, -- OSC possui alguma titula��o ou certifica��o
  ft_certificado boolean, -- Fonte de dados da informa��o se OOSC possui alguma titula��o ou certifica��o
  CONSTRAINT pk_tb_elementos PRIMARY KEY (id_elementos), -- Chave prim�ria da tabela de elementos
  CONSTRAINT fk_id_osc FOREIGN KEY (id_osc)
		REFERENCES osc.tb_osc (id_osc) MATCH FULL
		ON UPDATE NO ACTION ON DELETE NO ACTION	
);
