CREATE OR REPLACE FUNCTION osc.limpa_recursos_osc_ano_origem() RETURNS trigger
    language plpgsql
as
$$
BEGIN
    DELETE FROM osc.tb_recursos_osc WHERE tb_recursos_osc.id_osc = new.id_osc AND
       "substring"(tb_recursos_osc.dt_ano_recursos_osc::text, 1, 4)::integer  = new.ano AND
       (SELECT fonte.cd_origem_fonte_recursos_osc FROM syst.dc_fonte_recursos_osc
           as fonte WHERE tb_recursos_osc.cd_fonte_recursos_osc = fonte.cd_fonte_recursos_osc
        ) = new.cd_origem_fonte_recursos_osc;
    RETURN NULL;
END;
$$;

alter function osc.limpa_recursos_osc_ano_origem() owner to postgres;

CREATE TRIGGER limpa_recursos_trigger
AFTER INSERT ON osc.tb_n_recurso_osc_ano
FOR EACH ROW
EXECUTE PROCEDURE osc.limpa_recursos_osc_ano_origem();