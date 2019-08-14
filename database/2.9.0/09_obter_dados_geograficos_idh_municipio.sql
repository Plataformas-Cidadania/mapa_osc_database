drop function if exists ipeadata.obter_dados_geograficos_idh_municipio(integer);
create function ipeadata.obter_dados_geograficos_idh_municipio(cd_uf integer)
    returns TABLE
            (
                resultado json,
                mensagem  text,
                codigo    integer
            )
    language plpgsql
as
$$

DECLARE
    r              record;
    cont           integer = 0;
    resultado_json jsonb;
    vetor          jsonb;
    objetos        jsonb;
    path           text[];
BEGIN
    --resultado_json := jsonb_build_array('0');
    resultado_json := json_build_object('features', '[]');
    vetor := jsonb_build_array('0');

    FOR r IN SELECT v.edmu_cd_municipio           as municipio,
                    v.edmu_nm_municipio           as nm_municipio,
                    v.eduf_cd_uf                  as uf,
                    ST_ASGEOJSON(v.edmu_geometry) as geometry,
                    v.nr_valor                    as nr_valor
             FROM ipeadata.vw_dados_geograficos_idh_municipio v
             WHERE v.eduf_cd_uf = cd_uf
        LOOP
            path[0] := cont;

            --IF cont <= 500 THEN
            cont := cont + 1;

            objetos := json_build_object('type', 'Feature', 'id', '0');
            objetos := jsonb_set(objetos, '{id}', cont::text::jsonb);
            ------------------------------Elemento Properties------------------------------------
            objetos := jsonb_set(objetos, '{properties}', '{}');
            objetos := jsonb_set(objetos, '{properties, municipio}', r.municipio::text::jsonb);
            objetos := jsonb_set(objetos, '{properties, nm_municipio}', to_jsonb(r.nm_municipio));
            objetos := jsonb_set(objetos, '{properties, nr_valor}', r.nr_valor::text::jsonb);
            ------------------------------Elemento Geometry--------------------------------------
            objetos := jsonb_set(objetos, '{geometry}', '{}');
            objetos := jsonb_set(objetos, '{geometry, type}', '"MultiPolygon"');
            objetos := jsonb_set(objetos, '{geometry}', r.geometry::jsonb);

            vetor := jsonb_set(vetor, path, objetos);
            --END IF;

        END LOOP;

    resultado_json := jsonb_set(resultado_json, '{features}', vetor);

    resultado := resultado_json;
    codigo := 200;
    mensagem := 'Lista de IDH de Municípios retornado.';

    RETURN NEXT;
EXCEPTION
    WHEN others THEN
        codigo := 400;
        SELECT INTO mensagem a.mensagem
        FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
        RETURN NEXT;

END;
$$;

alter function ipeadata.obter_dados_geograficos_idh_municipio(integer) owner to i3geo;