DROP FUNCTION IF EXISTS portal.obter_grafico_oscs_area_atuacao();

create or replace function portal.obter_grafico_oscs_area_atuacao()
    returns TABLE(dados jsonb, fontes text[])
    language plpgsql
as
$$
DECLARE
quantidade_oscs DOUBLE PRECISION;

BEGIN
	quantidade_oscs := (SELECT COUNT(*) FROM osc.tb_osc WHERE bo_osc_ativa IS true);

	CREATE OR REPLACE VIEW vw_area_atuacao_sem_dup AS select DISTINCT ON (osc.tb_area_atuacao.id_osc,osc.tb_area_atuacao.cd_area_atuacao) osc.tb_area_atuacao.id_osc, osc.tb_area_atuacao.cd_area_atuacao, osc.tb_area_atuacao.cd_subarea_atuacao, osc.tb_area_atuacao.ft_area_atuacao FROM osc.tb_area_atuacao;

RETURN QUERY
SELECT
    ('[{' || RTRIM(LTRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE((TRANSLATE(ARRAY_AGG(b.dados)::TEXT, '\', '') || '}'), '""', '"'), '}",', '},'), '"}', '}'), '"{', '{'), ',,', ','), '{'), '}') || '}]')::JSONB AS dados,
        ('{' || TRIM(REPLACE(TRANSLATE((
                                           SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', ''))
                                           FROM (
                                                    SELECT DISTINCT UNNEST(
                                                                            ('{' || TRIM(REPLACE(TRANSLATE(ARRAY_AGG(b.fontes)::TEXT, '\"', ''), ',,', ','), ',{}') || '}')::TEXT[]
                                                                        )
                                                ) AS a
                                       )::TEXT, '\"', ''), ',,', ','), ',{}') || '}')::TEXT[] AS fontes
FROM (
         SELECT
             ARRAY_AGG('{"label": "' || COALESCE(a.rotulo::TEXT, 'Outras organizações da sociedade civil') || '", "value": ' || a.valor::TEXT || '}')::TEXT AS dados,
                 TRIM(ARRAY_AGG(DISTINCT TRIM(a.fontes)) FILTER (WHERE (TRIM(a.fontes) = '') IS false)::TEXT, '{}') AS fontes
         FROM (
                  SELECT
                      COALESCE(dc_area_atuacao.tx_nome_area_atuacao, 'Sem informação') AS rotulo,
                      COUNT(*) AS valor,
                      (
                              TRIM(ARRAY_AGG(DISTINCT TRIM(vw_area_atuacao_sem_dup.ft_area_atuacao)) FILTER (WHERE (TRIM(vw_area_atuacao_sem_dup.ft_area_atuacao) = '') IS false)::TEXT, '{}') || ',' ||
                              TRIM(ARRAY_AGG(DISTINCT TRIM(tb_osc.ft_identificador_osc)) FILTER (WHERE (TRIM(tb_osc.ft_identificador_osc) = '') IS false)::TEXT, '{}')
                          ) AS fontes
                  FROM osc.tb_osc
                           LEFT JOIN vw_area_atuacao_sem_dup
                                     ON tb_osc.id_osc = vw_area_atuacao_sem_dup.id_osc
                           LEFT JOIN syst.dc_area_atuacao
                                     ON vw_area_atuacao_sem_dup.cd_area_atuacao = dc_area_atuacao.cd_area_atuacao
                  WHERE tb_osc.bo_osc_ativa
                    AND tb_osc.id_osc <> 789809
                  GROUP BY rotulo
              ) AS a
     ) AS b;
END;

$$;
