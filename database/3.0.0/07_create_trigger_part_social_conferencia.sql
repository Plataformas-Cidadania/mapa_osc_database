CREATE OR REPLACE FUNCTION osc.delete_ps_conferencias()
RETURNS trigger AS
    $BODY$
BEGIN
    DELETE FROM osc.tb_participacao_social_conferencia psc WHERE psc.id_osc = NEW.id_osc;
    RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;


CREATE TRIGGER delete_ps_conferencias AFTER UPDATE
   ON osc.tb_osc FOR EACH ROW
   WHEN (new.bo_nao_possui_ps_conferencias = true)
   EXECUTE PROCEDURE osc.delete_ps_conferencias();


CREATE OR REPLACE FUNCTION osc.update_ps_conferencias()
RETURNS trigger AS
    $BODY$
BEGIN
    UPDATE osc.tb_osc osc SET bo_nao_possui_ps_conferencias = FALSE WHERE osc.id_osc = NEW.id_osc;
    RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER update_ps_conferencias AFTER INSERT
   ON osc.tb_participacao_social_conferencia FOR EACH ROW
   EXECUTE PROCEDURE osc.update_ps_conferencias();