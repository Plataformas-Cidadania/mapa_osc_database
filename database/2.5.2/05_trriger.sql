DROP TRIGGER vw_busca_resultado ON osc.tb_dados_gerais;
DROP FUNCTION vw_busca_resultado();

CREATE OR REPLACE FUNCTION vw_busca_resultado()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY osc.vw_busca_resultado;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER vw_busca_resultado
    AFTER INSERT OR DELETE OR UPDATE OF tx_nome_fantasia_osc, tx_razao_social_osc
    ON osc.tb_dados_gerais
    FOR EACH STATEMENT
    EXECUTE PROCEDURE vw_busca_resultado();
    
