ALTER TABLE syst.dc_fonte_dados ALTER COLUMN cd_sigla_fonte_dados TYPE TEXT;

INSERT INTO syst.dc_fonte_dados (cd_sigla_fonte_dados, tx_nome_fonte_dados, tx_descricao_fonte_dados, tx_referencia_fonte_dados) 
VALUES ('Estado ou município', 'Dados de estados ou municípios', 'Dados provenientes de governos estaduais ou municipais', null);
