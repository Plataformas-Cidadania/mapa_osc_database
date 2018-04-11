CREATE OR REPLACE FUNCTION public.refreshallmaterializedviewsC(schema_arg text DEFAULT 'public'::text)
  RETURNS integer AS
$BODY$
DECLARE
    r RECORD;
BEGIN
    RAISE NOTICE 'Refreshing materialized view no schema %', schema_arg;
    FOR r IN SELECT matviewname FROM pg_matviews WHERE schemaname = schema_arg
    LOOP
        RAISE NOTICE 'Refreshing %.%', schema_arg, r.matviewname;
        EXECUTE 'REFRESH MATERIALIZED VIEW CONCURRENTLY ' || schema_arg || '.' || r.matviewname;
    END LOOP;

    RETURN 1;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
