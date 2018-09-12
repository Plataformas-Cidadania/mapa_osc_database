-- DROP TABLE portal.tb_token_ip;

CREATE TABLE portal.tb_token_ip
(
  id_token SERIAL NOT NULL, -- Identificador do token
  tx_ip TEXT NOT NULL, -- IP de acesso
  tx_token TEXT NOT NULL, -- Token do IP
  dt_data_expiracao TIMESTAMP NOT NULL, -- Data de expiração do token
  nr_quantidade_acessos INTEGER NOT NULL, -- Quantidade de acessos do IP
  CONSTRAINT pk_tb_token_ip PRIMARY KEY (id_token), -- Chave primária
  CONSTRAINT un_tx_ip UNIQUE (tx_ip) -- Restrição para IP único
);
