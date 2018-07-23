DROP FUNCTION IF EXISTS portal.atualizar_participacao_social_osc(TEXT, NUMERIC, TEXT, TIMESTAMP, JSONB, BOOLEAN, BOOLEAN, BOOLEAN, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_participacao_social_osc(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER, tipo_busca INTEGER) RETURNS TABLE(
	mensagem TEXT,
	flag BOOLEAN
)AS $$

DECLARE
	conferencia JSONB;
	conselho JSONB;
	outra JSONB;
	record_funcao_externa RECORD;

BEGIN
	conferencia := COALESCE((json->>'conferencia'), null)::JSONB;
	conselho := COALESCE((json->>'conselho'), null)::JSONB;
	outra := COALESCE((json->>'outra'), null)::JSONB;

	IF conferencia IS NOT null THEN
		SELECT INTO record_funcao_externa * FROM portal.atualizar_participacao_social_conferencia(fonte::TEXT, identificador::NUMERIC, tipo_identificador::TEXT, data_atualizacao::TIMESTAMP, conferencia::JSONB, null_valido::BOOLEAN, delete_valido::BOOLEAN, erro_log::BOOLEAN, id_carga::INTEGER, tipo_busca::INTEGER);
		IF record_funcao_externa.flag = false THEN
			mensagem := record_funcao_externa.mensagem;
			RAISE EXCEPTION 'funcao_externa';
		END IF;
	END IF;

	IF conselho IS NOT null THEN
		SELECT INTO record_funcao_externa * FROM portal.atualizar_participacao_social_conselho(fonte::TEXT, identificador::NUMERIC, tipo_identificador::TEXT, data_atualizacao::TIMESTAMP, conselho::JSONB, null_valido::BOOLEAN, delete_valido::BOOLEAN, erro_log::BOOLEAN, id_carga::INTEGER, tipo_busca::INTEGER);

		IF record_funcao_externa.flag = false THEN
			mensagem := record_funcao_externa.mensagem;
			RAISE EXCEPTION 'funcao_externa';
		END IF;
	END IF;
	
	IF outra IS NOT null THEN
		SELECT INTO record_funcao_externa * FROM portal.atualizar_participacao_social_outra(fonte::TEXT, identificador::NUMERIC, tipo_identificador::TEXT, data_atualizacao::TIMESTAMP, outra::JSONB, null_valido::BOOLEAN, delete_valido::BOOLEAN, erro_log::BOOLEAN, id_carga::INTEGER);
		IF record_funcao_externa.flag = false THEN
			mensagem := record_funcao_externa.mensagem;
			RAISE EXCEPTION 'funcao_externa';
		END IF;
	END IF;

	flag := true;
	mensagem := 'Participação social atualizada.';
	
	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		flag := false;

		IF SQLERRM <> 'funcao_externa' THEN 
			SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, fonte, identificador, data_atualizacao::TIMESTAMP, erro_log, id_carga) AS a;
		END IF;
		
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
