CREATE TRIGGER log_alteracao
    AFTER INSERT OR UPDATE OR DELETE ON log.tb_log_alteracao 
    FOR EACH ROW
    EXECUTE PROCEDURE refresh_vw_log_alteracao();
