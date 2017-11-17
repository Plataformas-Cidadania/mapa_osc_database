DROP MATERIALIZED VIEW IF EXISTS portal.vw_osc_dados_gerais CASCADE;
DROP MATERIALIZED VIEW IF EXISTS osc.vw_busca_resultado CASCADE;
DROP MATERIALIZED VIEW IF EXISTS portal.vw_busca_resultado CASCADE;

ALTER TABLE osc.tb_localizacao ALTER COLUMN nr_localizacao TYPE TEXT USING nr_localizacao::TEXT;
