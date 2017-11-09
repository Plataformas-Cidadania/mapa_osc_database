ALTER TABLE log.tb_log_alteracao RENAME COLUMN id_tabela TO id_osc;
ALTER TABLE log.tb_log_alteracao RENAME COLUMN id_usuario TO tx_fonte_dados;
ALTER TABLE log.tb_log_alteracao ALTER COLUMN tx_fonte_dados TYPE TEXT USING tx_fonte_dados::TEXT;
