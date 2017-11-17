ALTER TABLE portal.tb_newsletters 
ADD CONSTRAINT un_email_assinante UNIQUE (tx_email_assinante);
