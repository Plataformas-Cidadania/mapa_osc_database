DELETE FROM osc.tb_area_atuacao WHERE cd_area_atuacao = 0;

ALTER TABLE ONLY osc.tb_area_atuacao
    ADD CONSTRAINT fk_cd_area_area_atuacao FOREIGN KEY (cd_area_atuacao) REFERENCES syst.dc_area_atuacao;