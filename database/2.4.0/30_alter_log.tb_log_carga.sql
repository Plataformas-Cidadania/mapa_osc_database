ALTER TABLE log.tb_log_carga ADD dt_carregamento_dados TIMESTAMP DEFAULT null;
COMMENT ON COLUMN log.tb_log_carga.dt_carregamento_dados IS 'Data de carregamento dos dados';

ALTER TABLE log.tb_log_carga ALTER COLUMN id_fonte_dados TYPE TEXT;
COMMENT ON COLUMN log.tb_log_carga.id_fonte_dados IS 'Fonte de dados';

ALTER TABLE log.tb_log_carga  
DROP CONSTRAINT IF EXISTS fk_cd_identificador_osc;

ALTER TABLE log.tb_log_carga 
ALTER COLUMN cd_identificador_osc TYPE NUMERIC 
USING cd_identificador_osc::NUMERIC;
