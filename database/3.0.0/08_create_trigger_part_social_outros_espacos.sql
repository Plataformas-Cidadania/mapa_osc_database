CREATE OR REPLACE FUNCTION osc.delete_ps_outros_espacos()
RETURNS trigger AS
    $BODY$
BEGIN
    DELETE FROM osc.tb_participacao_social_outra pso WHERE pso.id_osc = NEW.id_osc;
    RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;


CREATE TRIGGER delete_ps_outros_espacos AFTER UPDATE
   ON osc.tb_osc FOR EACH ROW
   WHEN (new.bo_nao_possui_ps_outros_espacos = true)
   EXECUTE PROCEDURE osc.delete_ps_outros_espacos();


CREATE OR REPLACE FUNCTION osc.update_ps_outros_espacos()
RETURNS trigger AS
    $BODY$
BEGIN
    UPDATE osc.tb_osc osc SET bo_nao_possui_ps_outros_espacos = FALSE WHERE osc.id_osc = NEW.id_osc;
    RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql;

CREATE TRIGGER update_ps_outros_espacos AFTER INSERT
   ON osc.tb_participacao_social_outra FOR EACH ROW
   EXECUTE PROCEDURE osc.update_ps_outros_espacos();