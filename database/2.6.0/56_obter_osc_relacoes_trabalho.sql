DROP FUNCTION IF EXISTS portal.obter_osc_relacoes_trabalho(TEXT);

CREATE OR REPLACE FUNCTION portal.obter_osc_relacoes_trabalho(param TEXT) RETURNS TABLE (
	resultado JSONB,
	mensagem TEXT,
	flag BOOLEAN
) AS $$ 

DECLARE
	linha RECORD;
	osc RECORD;

BEGIN 
	resultado := null;
	
	SELECT INTO osc * FROM osc.tb_osc WHERE (id_osc = param::INTEGER OR tx_apelido_osc = param) AND bo_osc_ativa;
	
	IF osc.id_osc IS NOT null THEN 
		SELECT INTO linha
			(COALESCE(nr_trabalhadores_vinculo, 0) + COALESCE(nr_trabalhadores_deficiencia, 0) + COALESCE(nr_trabalhadores_voluntarios, 0)) AS nr_trabalhadores,
			nr_trabalhadores_vinculo,
			ft_trabalhadores_vinculo,
			nr_trabalhadores_deficiencia,
			ft_trabalhadores_deficiencia,
			nr_trabalhadores_voluntarios,
			ft_trabalhadores_voluntarios
		FROM 
			osc.tb_relacoes_trabalho 
		WHERE 
			id_osc = osc.id_osc;
		
		IF linha != (null::INTEGER, null::INTEGER, null::TEXT, null::INTEGER, null::TEXT, null::INTEGER, null::TEXT)::RECORD THEN 
			resultado := to_jsonb(linha);
		END IF;
		
		flag := true;
		mensagem := 'Relações de trabalho retornados.';
		
	ELSE 
		flag := false;
		mensagem := 'OSC não encontrada.';
	END IF;

	RETURN NEXT;
	
EXCEPTION
	WHEN others THEN 
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_osc_relacoes_trabalho('789809');

