DROP FUNCTION IF EXISTS portal.obter_osc_relacoes_trabalho_governanca(TEXT);

CREATE OR REPLACE FUNCTION portal.obter_osc_relacoes_trabalho_governanca(param TEXT) RETURNS TABLE (
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
			(SELECT a.resultado FROM portal.obter_osc_relacoes_trabalho(param) AS a) AS relacoes_trabalho,
			(SELECT a.resultado FROM portal.obter_osc_relacoes_trabalho_outra(param) AS a) AS relacoes_trabalho_outra,
			(SELECT a.resultado FROM portal.obter_osc_governanca(param) AS a) AS governanca,
			(SELECT a.resultado FROM portal.obter_osc_conselho_fiscal(param) AS a) AS conselho_fiscal
		FROM 
			osc.tb_conselho_fiscal
		WHERE 
			id_osc = osc.id_osc;

		IF linha != (null::JSONB, null::JSONB, null::JSONB, null::JSONB)::RECORD THEN 
			resultado := to_jsonb(linha);
		END IF;

		flag := true;
		mensagem := 'Relações de trabalho e governança retornados.';
		
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
