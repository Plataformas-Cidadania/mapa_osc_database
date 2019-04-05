DROP FUNCTION IF EXISTS cache.limpar_cache_exportar() CASCADE;

CREATE OR REPLACE FUNCTION cache.limpar_cache_exportar() RETURNS void AS $$ 

BEGIN
    DELETE FROM graph.tb_exportar
        WHERE dt_data_expiracao >= now();
END;

$$ LANGUAGE 'plpgsql';