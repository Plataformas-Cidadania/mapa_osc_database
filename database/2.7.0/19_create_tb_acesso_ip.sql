DROP TABLE IF EXISTS portal.tb_acesso_ip;

CREATE TABLE portal.tb_acesso_ip
(
  id SERIAL NOT NULL, -- Identificador da tabela
  tx_ip TEXT NOT NULL, -- IP de acesso
  dt_data_expiracao TIMESTAMP NOT NULL, -- Data de expiração da contagem de acesso
  nr_quantidade_acessos INTEGER NOT NULL, -- Quantidade de acessos do IP
  CONSTRAINT pk_tb_acesso_ip PRIMARY KEY (id), -- Chave primária
  CONSTRAINT un_tx_ip UNIQUE (tx_ip) -- Restrição para IP único
);
