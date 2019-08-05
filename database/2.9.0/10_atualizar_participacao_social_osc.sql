drop function if exists portal.atualizar_participacao_social_osc(fonte text, identificador numeric, tipo_identificador text, data_atualizacao timestamp without time zone, json jsonb, null_valido boolean, delete_valido boolean, erro_log boolean, id_carga integer, tipo_busca integer);

create function portal.atualizar_participacao_social_osc(fonte text, identificador numeric, tipo_identificador text,
                                                         data_atualizacao timestamp without time zone, json jsonb,
                                                         null_valido boolean, delete_valido boolean, erro_log boolean,
                                                         id_carga integer, tipo_busca integer) returns TABLE
                                                                                                       (
                                                                                                           mensagem text,
                                                                                                           flag boolean
                                                                                                       )
    language plpgsql
as
$$
DECLARE
    conferencia           JSONB;
    conselho              JSONB;
    outra                 JSONB;
    record_funcao_externa RECORD;

BEGIN
    conferencia := COALESCE((json ->> 'conferencia'), null)::JSONB;
    conselho := COALESCE((json ->> 'conselho'), null)::JSONB;
    outra := COALESCE((json ->> 'outra'), null)::JSONB;

    IF conferencia IS NOT null THEN
        SELECT INTO record_funcao_externa *
        FROM portal.atualizar_participacao_social_conferencia(fonte::TEXT, identificador::NUMERIC,
                                                              tipo_identificador::TEXT, data_atualizacao::TIMESTAMP,
                                                              conferencia::JSONB, null_valido::BOOLEAN,
                                                              delete_valido::BOOLEAN, erro_log::BOOLEAN,
                                                              id_carga::INTEGER, tipo_busca::INTEGER);
        IF record_funcao_externa.flag = false THEN
            RETURN QUERY (SELECT record_funcao_externa.mensagem, false);
            RETURN;
        END IF;
    END IF;

    IF conselho IS NOT null THEN
        SELECT INTO record_funcao_externa *
        FROM portal.atualizar_participacao_social_conselho(fonte::TEXT, identificador::NUMERIC,
                                                           tipo_identificador::TEXT, data_atualizacao::TIMESTAMP,
                                                           conselho::JSONB, null_valido::BOOLEAN,
                                                           delete_valido::BOOLEAN, erro_log::BOOLEAN, id_carga::INTEGER,
                                                           tipo_busca::INTEGER);
        IF record_funcao_externa.flag = false THEN
            RETURN QUERY (SELECT record_funcao_externa.mensagem, false);
            RETURN;
        END IF;
    END IF;

    IF outra IS NOT null THEN
        SELECT INTO record_funcao_externa *
        FROM portal.atualizar_participacao_social_outra(fonte::TEXT, identificador::NUMERIC, tipo_identificador::TEXT,
                                                        data_atualizacao::TIMESTAMP, outra::JSONB, null_valido::BOOLEAN,
                                                        delete_valido::BOOLEAN, erro_log::BOOLEAN, id_carga::INTEGER);
        IF record_funcao_externa.flag = false THEN
            RETURN QUERY (SELECT record_funcao_externa.mensagem, false);
            RETURN;
        END IF;
    END IF;

    flag := true;
    mensagem := 'Participação social atualizada.';

    RETURN NEXT;

EXCEPTION
    WHEN others THEN
        flag := false;
        SELECT INTO mensagem a.mensagem
        FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, identificador, data_atualizacao::TIMESTAMP, erro_log,
                                   id_carga) AS a;

        RETURN NEXT;

END;
$$;

alter function portal.atualizar_participacao_social_osc(text, numeric, text, timestamp, jsonb, boolean, boolean, boolean, integer, integer) owner to postgres;