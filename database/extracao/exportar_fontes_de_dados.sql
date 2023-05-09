SELECT string_agg(distinct_values_query.distinct_values_query, ' UNION ALL ') AS all_distinct_values
FROM (
         SELECT DISTINCT
             format(
                     'SELECT %L AS column_name, %L AS table_name, COUNT(DISTINCT %I) AS distinct_count, array_agg(DISTINCT %I) AS distinct_values FROM %I.%I',
                     c.column_name,
                     c.table_name,
                     c.column_name,
                     c.column_name,
                     c.table_schema,
                     c.table_name
                 ) AS distinct_values_query
         FROM
             information_schema.columns c
         WHERE
                 c.table_schema = 'osc'
           AND c.column_name LIKE 'ft_%'
     ) AS distinct_values_query;