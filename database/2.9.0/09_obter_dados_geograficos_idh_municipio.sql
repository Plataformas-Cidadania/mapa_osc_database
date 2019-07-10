drop  function if exists ipeadata.obter_dados_geograficos_idh_municipio(id_municipio integer);
create function ipeadata.obter_dados_geograficos_idh_municipio(id_municipio integer)
    returns TABLE
            (
                resultado json,
                mensagem  text,
                codigo    integer
            )
    language plpgsql
as
$$
BEGIN

        SELECT INTO resultado
                row_to_json(v)
        FROM (
                 SELECT v.edmu_cd_municipio           as municipio,
                        v.edmu_nm_municipio           as nm_municipio,
                        ST_ASGEOJSON(v.edmu_geometry) as geometry,
                        v.nr_valor                    as nr_valor
                 FROM ipeadata.vw_dados_geograficos_idh_municipio v
                 WHERE v.edmu_cd_municipio = id_municipio
             ) as v;

    codigo := 200;
    mensagem := 'Perfil de localidade retornado.';

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