ALTER TABLE log.tb_log_carga ALTER COLUMN id_fonte_dados TYPE TEXT;

COMMENT ON COLUMN log.tb_log_carga.id_fonte_dados IS 'Fonte de dados';

ALTER TABLE log.tb_log_carga 
ADD CONSTRAINT fk_fonte_dados FOREIGN KEY (id_fonte_dados) 
REFERENCES syst.dc_fonte_dados (cd_sigla_fonte_dados);
