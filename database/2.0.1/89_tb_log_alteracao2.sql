CREATE TABLE log.tb_log_alteracao2
(
  id_log_alteracao serial NOT NULL, -- Identificador do log de alteração
  tx_nome_tabela text NOT NULL, -- Nome da tabela alterada
  id_tabela integer NOT NULL, -- Identificador do tabela alterada
  id_usuario integer NOT NULL, -- Identificador do usuário
  dt_alteracao timestamp without time zone NOT NULL, -- Data de alteração do dado
  tx_dado_anterior jsonb, -- Valor dado anterior
  tx_dado_posterior jsonb, -- Valor do dado atualizado
  CONSTRAINT pk_tb_log_alteracao2 PRIMARY KEY (id_log_alteracao) -- Chave primária da tabela de log de alteração
);