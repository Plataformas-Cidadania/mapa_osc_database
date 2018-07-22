DROP FUNCTION IF EXISTS portal.atualizar_participacao_social(TEXT, NUMERIC, TEXT, TIMESTAMP, JSONB, BOOLEAN, BOOLEAN, BOOLEAN, INTEGER, INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_participacao_social(fonte TEXT, identificador NUMERIC, tipo_identificador TEXT, data_atualizacao TIMESTAMP, json JSONB, null_valido BOOLEAN, delete_valido BOOLEAN, erro_log BOOLEAN, id_carga INTEGER, tipo_busca INTEGER) RETURNS TABLE(
	mensagem TEXT,
	flag BOOLEAN
)AS $$

DECLARE
	conferencia JSONB;
	conselho JSONB;
	outra JSONB;
	record_funcao_externa RECORD;

BEGIN
	conferencia := COALESCE((json->>'conferencia')::JSONB, null);
	conselho := COALESCE((json->>'conselho')::JSONB, null);
	outra := COALESCE((json->>'outra')::JSONB, null);

	IF conferencia IS NOT null THEN
		SELECT INTO record_funcao_externa * FROM portal.atualizar_participacao_social_conferencia(fonte::TEXT, identificador::NUMERIC, tipo_identificador::TEXT, data_atualizacao::TIMESTAMP, conferencia::JSONB, null_valido::BOOLEAN, delete_valido::BOOLEAN, erro_log::BOOLEAN, id_carga::INTEGER, tipo_busca::INTEGER);
		IF record_funcao_externa.flag = false THEN
			mensagem := record_funcao_externa.mensagem;
			RAISE EXCEPTION 'funcao_externa';
		END IF;
	END IF;

	IF conselho IS NOT null THEN
		SELECT INTO record_funcao_externa * FROM portal.atualizar_participacao_social_conselho(fonte, identificador, tipo_identificador, data_atualizacao, conselho, null_valido, delete_valido, erro_log, id_carga, tipo_busca);
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

SELECT * FROM portal.atualizar_participacao_social(
	'Representante de OSC'::TEXT, 
	'987654'::NUMERIC, 
	'id_osc'::TEXT, 
	now()::TIMESTAMP, 
	'{
		"conferencia": [
			{"id_conferencia": 13, "cd_conferencia": 2, "tx_nome_conferencia_outra": "Teste 2", "dt_ano_realizacao": "2015-01-01", "cd_forma_participacao_conferencia": 1},
			{"id_conferencia": 14, "cd_conferencia": 1, "tx_nome_conferencia_outra": null, "dt_ano_realizacao": "2016-01-01", "cd_forma_participacao_conferencia": 1},
			{					   "cd_conferencia": 45, "tx_nome_conferencia_outra": "Teste 1", "dt_ano_realizacao": "2016-01-01", "cd_forma_participacao_conferencia": 1}
		],
		"conselho": [	
			{
				"conselho": {"id_conselho": null, "cd_conselho": "1", "cd_tipo_participacao": "1", "tx_nome_conselho": "Teste 1", "cd_periodicidade_reuniao_conselho": "1", "dt_data_inicio_conselho": "01-01-2001", "dt_data_fim_conselho": "01-01-2011"},	
				"representante": [
					{"tx_nome_representante_conselho": "Teste 1"}	
				]	
			},	
			{	
				"conselho": {"id_conselho": null, "cd_conselho": "2", "cd_tipo_participacao": "2", "tx_nome_conselho": "Teste 2", "cd_periodicidade_reuniao_conselho": "2", "dt_data_inicio_conselho": "02-02-2002", "dt_data_fim_conselho": "02-02-2012"},	
				"representante": [
					{"tx_nome_representante_conselho": "Teste 2a"},	
					{"tx_nome_representante_conselho": "Teste 2b"}	
				]	
			},	
			{	
				"conselho": {"id_conselho": null, "cd_conselho": "104", "cd_tipo_participacao": "2", "tx_nome_conselho": "Teste 2", "cd_periodicidade_reuniao_conselho": "2", "dt_data_inicio_conselho": "02-02-2002", "dt_data_fim_conselho": "02-02-2012"}, 
				"representante": [	
					{"tx_nome_representante_conselho": "Teste 2a"},	
					{"tx_nome_representante_conselho": "Teste 2b"}
				]	
			}	
		],
		"outra": [
			{"tx_nome_participacao_social_outra": "Teste 1", "bo_nao_possui": false},
			{"tx_nome_participacao_social_outra": "Teste 2", "bo_nao_possui": false}
		]
	}'::JSONB, 
	true::BOOLEAN, 
	true::BOOLEAN, 
	false::BOOLEAN, 
	null::INTEGER, 
	2::INTEGER
);

SELECT * FROM osc.tb_participacao_social_conferencia LEFT JOIN osc.tb_participacao_social_conferencia_outra ON tb_participacao_social_conferencia_outra.id_conferencia = tb_participacao_social_conferencia.id_conferencia WHERE tb_participacao_social_conferencia.id_osc = 987654;
