

SELECT * FROM portal.atualizar_certificado_osc('Representante de OSC'::TEXT, 762859::NUMERIC, 'id_osc'::TEXT, now()::TIMESTAMP, '[{"cd_certificado":4, "dt_inicio_certificado":"2012-10-26","dt_fim_certificado":"2020-06-05","cd_municipio":null,"cd_uf":null}]'::JSONB, TRUE::BOOLEAN, TRUE::BOOLEAN, TRUE::BOOLEAN, NULL::INTEGER, 3::INTEGER);