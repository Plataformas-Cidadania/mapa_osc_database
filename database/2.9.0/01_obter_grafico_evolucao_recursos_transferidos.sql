DROP FUNCTION IF EXISTS portal.obter_grafico_evolucao_recursos_transferidos() CASCADE;

CREATE OR REPLACE FUNCTION portal.obter_grafico_evolucao_recursos_transferidos() RETURNS TABLE (
	dados JSONB,
	fontes TEXT[]
) AS $$

DECLARE
    reg RECORD;
BEGIN

	dados := '[
		{
			"key": "Orçamento empenhado",
			"values":[]
        }
	]'::JSONB;

        SELECT INTO reg json_agg(v) as t
            FROM (
                SELECT
                       t.nr_orcamento_ano as x,
                       SUM(t.nr_vl_empenhado_def) as y
                FROM graph.tb_orcamento_def t
                GROUP BY t.nr_orcamento_ano
                ORDER BY t.nr_orcamento_ano
        ) v;

    dados := jsonb_set(dados, '{0, values}', to_jsonb(reg.t), true);

	--fontes := null::TEXT[];
	fontes := string_to_array('SIGA Brasil 2010-2018', ']');

	RETURN QUERY
		SELECT dados, fontes;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_grafico_evolucao_recursos_transferidos();
