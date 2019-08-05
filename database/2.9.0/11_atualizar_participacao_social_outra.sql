drop function if exists portal.atualizar_participacao_social_outra(fonte text, identificador numeric, tipo_identificador text,
                                                           data_atualizacao timestamp without time zone, json jsonb,
                                                           null_valido boolean, delete_valido boolean, erro_log boolean,
                                                           id_carga integer);

create function portal.atualizar_participacao_social_outra(fonte text, identificador numeric, tipo_identificador text,
                                                           data_atualizacao timestamp without time zone, json jsonb,
                                                           null_valido boolean, delete_valido boolean, erro_log boolean,
                                                           id_carga integer) returns TABLE
                                                                                     (
                                                                                         mensagem text,
                                                                                         flag boolean
                                                                                     )
    language plpgsql
as
$$
DECLARE
    nome_tabela     TEXT;
    fonte_dados     RECORD;
    objeto          RECORD;
    dado_anterior   RECORD;
    dado_posterior  RECORD;
    dado_nao_delete INTEGER[];
    flag_update     BOOLEAN;
    osc             RECORD;
    nao_possui      BOOLEAN;
    nome_part_social text;

BEGIN
    nome_tabela := 'osc.tb_participacao_social_outra';
    tipo_identificador := lower(tipo_identificador);
    nao_possui := false;
    dado_nao_delete := '{}'::INTEGER[];

    SELECT INTO fonte_dados * FROM portal.verificar_fonte(fonte);

    RAISE NOTICE 'JSON: %', json;
    RAISE NOTICE 'Booleano: %', json #> '{outra,bo_nao_possui}';
    RAISE NOTICE 'ID OSC: %', identificador;
    RAISE NOTICE 'NAO POSSUI: %', nao_possui::boolean;

    nao_possui := json#>'{outra,bo_nao_possui}';
    IF nao_possui THEN
        RAISE NOTICE 'Passou do IF JSON';
        FOR objeto IN (SELECT * FROM osc.tb_participacao_social_outra t WHERE t.id_osc = identificador)
            LOOP
                IF (SELECT a.flag
                    FROM portal.verificar_delete(fonte_dados.prioridade,
                                                 ARRAY [objeto.ft_participacao_social_outra]) AS a) THEN

                    RAISE NOTICE 'Passou no DELETE';
                    DELETE
                    FROM osc.tb_participacao_social_outra
                    WHERE id_participacao_social_outra = objeto.id_participacao_social_outra;

                    RAISE NOTICE 'Passou DO DELETE';
                    PERFORM portal.inserir_log_atualizacao(nome_tabela, identificador::integer, fonte, data_atualizacao,
                                                           row_to_json(objeto), null::JSON, id_carga);

                    RAISE NOTICE 'Passou DO LOG DEL';
                END IF;
            END LOOP;

        nome_part_social := 'Não possui';
        INSERT INTO osc.tb_participacao_social_outra (id_osc,
                                                      tx_nome_participacao_social_outra,
                                                      bo_nao_possui,
                                                      ft_participacao_social_outra)
        VALUES (identificador,
                nome_part_social,
                nao_possui,
                fonte) RETURNING * INTO dado_posterior;

        RAISE NOTICE 'Passou DO INSERT';

        PERFORM portal.inserir_log_atualizacao(nome_tabela, identificador::integer, fonte, data_atualizacao, null::JSON,
                                               row_to_json(dado_posterior), id_carga);

        RAISE NOTICE 'Passou DO LOG INS';

    ELSE
        FOR objeto IN (SELECT * FROM jsonb_populate_recordset(null::osc.tb_participacao_social_outra, json))
            LOOP
                dado_anterior := null;

                SELECT INTO dado_anterior *
                FROM osc.tb_participacao_social_outra
                WHERE id_participacao_social_outra = objeto.id_participacao_social_outra;

                IF dado_anterior.id_participacao_social_outra IS null THEN
                    INSERT INTO osc.tb_participacao_social_outra (id_osc,
                                                                  tx_nome_participacao_social_outra,
                                                                  bo_nao_possui,
                                                                  ft_participacao_social_outra)
                    VALUES (identificador,
                            objeto.tx_nome_participacao_social_outra,
                            objeto.bo_nao_possui,
                            fonte_dados.nome_fonte) RETURNING * INTO dado_posterior;

                    PERFORM portal.inserir_log_atualizacao(nome_tabela, identificador::INTEGER, fonte, data_atualizacao,
                                                           null::JSON, row_to_json(dado_posterior), id_carga);

                ELSE
                    dado_posterior := dado_anterior;
                    flag_update := false;

                    IF (SELECT a.flag
                        FROM portal.verificar_dado(dado_anterior.tx_nome_participacao_social_outra::TEXT,
                                                   dado_anterior.ft_participacao_social_outra,
                                                   objeto.tx_nome_participacao_social_outra::TEXT,
                                                   fonte_dados.prioridade, null_valido) AS a) THEN
                        dado_posterior.tx_nome_participacao_social_outra :=
                                objeto.tx_nome_participacao_social_outra;
                        dado_posterior.ft_participacao_social_outra := fonte_dados.nome_fonte;
                        flag_update := true;
                    END IF;

                    IF (SELECT a.flag
                        FROM portal.verificar_dado(dado_anterior.bo_nao_possui::TEXT,
                                                   dado_anterior.ft_participacao_social_outra,
                                                   objeto.bo_nao_possui::TEXT, fonte_dados.prioridade,
                                                   null_valido) AS a) THEN
                        dado_posterior.bo_nao_possui := objeto.bo_nao_possui;
                        dado_posterior.ft_participacao_social_outra := fonte_dados.nome_fonte;
                        flag_update := true;
                    END IF;

                    IF flag_update THEN
                        UPDATE osc.tb_participacao_social_outra
                        SET tx_nome_participacao_social_outra = dado_posterior.tx_nome_participacao_social_outra,
                            bo_nao_possui                     = dado_posterior.bo_nao_possui,
                            ft_participacao_social_outra      = dado_posterior.ft_participacao_social_outra
                        WHERE id_participacao_social_outra = dado_posterior.id_participacao_social_outra;

                        PERFORM portal.inserir_log_atualizacao(nome_tabela, identificador::INTEGER, fonte,
                                                               data_atualizacao, row_to_json(dado_anterior),
                                                               row_to_json(dado_posterior), id_carga);
                    END IF;
                END IF;
            END LOOP;
    END IF;

    flag := true;
    mensagem := 'Outra participação social atualizada.';

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

alter function portal.atualizar_participacao_social_outra(text, numeric, text, timestamp, jsonb, boolean, boolean, boolean, integer) owner to postgres;