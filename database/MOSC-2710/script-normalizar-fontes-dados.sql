DO
$$
DECLARE
    rec RECORD;
    v_sql TEXT;
BEGIN
    FOR rec IN
        SELECT table_name, column_name
        FROM information_schema.columns
        WHERE table_schema = 'osc'
          AND column_name LIKE 'ft%'
    LOOP
        v_sql := format(
            'UPDATE osc.%I SET %I = %L WHERE %I IS NULL;',
            rec.table_name, rec.column_name, 'Representante de OSC', rec.column_name
        );
        RAISE NOTICE '%', v_sql; -- Remove ou comente esta linha se quiser executar diretamente, é útil para testar.
        EXECUTE v_sql;
    END LOOP;
END
$$;