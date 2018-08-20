ALTER TABLE osc.tb_recursos_osc DISABLE TRIGGER ALL;
UPDATE osc.tb_recursos_osc 
SET cd_origem_fonte_recursos_osc = (SELECT DISTINCT cd_origem_fonte_recursos_osc FROM syst.dc_fonte_recursos_osc WHERE cd_fonte_recursos_osc = osc.tb_recursos_osc.cd_fonte_recursos_osc);
