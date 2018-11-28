DROP FUNCTION IF EXISTS portal.obter_perfil_localidade(INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_perfil_localidade(id_localidade_req INTEGER) RETURNS TABLE (
	resultado JSONB,
	mensagem TEXT,
	codigo INTEGER
) AS $$ 

DECLARE
	linha RECORD;
	osc RECORD;

BEGIN 	
    SELECT INTO linha
            id_perfil_localidade, 
            tx_localidade, 
            tx_tipo_localidade, 
            nr_quantidade_osc, 
            nr_quantidade_trabalhadores, 
            nr_quantidade_recursos, 
            nr_quantidade_projetos, 
            evolucao_quantidade_osc_ano, 
            natureza_juridica, 
            repasse_recursos_federais, 
            area_atuacao, 
            trabalhadores 
        FROM 
            portal.tb_perfil_localidade 
        WHERE 
            id_localidade = id_localidade_req;

    IF linha != (
        null::INTEGER, 
        null::TEXT, 
        null::TEXT, 
        null::INTEGER, 
        null::INTEGER, 
        null::NUMERIC, 
        null::INTEGER, 
        null::JSONB, 
        null::JSONB, 
        null::JSONB, 
        null::JSONB, 
        null::JSONB
    )::RECORD THEN 
        resultado := row_to_json(linha.array);
        codigo := 200;
        mensagem := 'Perfil de localidade retornado.';
    ELSE 
        resultado := null;
        codigo := 404;
        mensagem := 'Perfil de localidade não encontrado.';
    END IF;

	RETURN NEXT;
	
EXCEPTION
	WHEN others THEN 
		codigo := 400;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;
$$ LANGUAGE 'plpgsql';
