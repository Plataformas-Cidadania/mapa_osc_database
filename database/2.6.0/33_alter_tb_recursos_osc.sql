ALTER TABLE osc.tb_recursos_osc ADD cd_origem_fonte_recursos_osc INTEGER DEFAULT null;

UPDATE osc.tb_recursos_osc 
SET cd_origem_fonte_recursos_osc = (SELECT cd_origem_fonte_recursos_osc FROM syst.dc_fonte_recursos_osc WHERE cd_fonte_recursos_osc = tb_recursos_osc.cd_fonte_recursos_osc);