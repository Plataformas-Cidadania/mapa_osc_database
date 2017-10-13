ALTER TABLE log.tb_log_carga ADD dt_carregamento_dados DATE DEFAULT null;
COMMENT ON COLUMN log.tb_log_carga.dt_carregamento_dados IS 'Data de carregamento dos dados';
