DROP FUNCTION IF EXISTS portal.obter_osc_recursos(TEXT);

CREATE OR REPLACE FUNCTION portal.obter_osc_recursos(param TEXT) RETURNS TABLE (
	resultado JSONB,
	mensagem TEXT,
	flag BOOLEAN
) AS $$ 

DECLARE
	osc RECORD;

BEGIN 
	resultado := null;
	
	SELECT INTO osc * FROM osc.tb_osc WHERE (id_osc = param::INTEGER OR tx_apelido_osc = param) AND bo_osc_ativa;
	
	IF osc.id_osc IS NOT null THEN 
		resultado := (
			json_build_object(
				'recursos', (
					SELECT 
						json_agg(
							json_build_object(
								'cd_fonte_recursos_osc', cd_fonte_recursos_osc, 
								'id_recursos_osc', id_recursos_osc, 
								'nr_valor_recursos_osc', nr_valor_recursos_osc, 
								'ft_valor_recursos_osc', ft_valor_recursos_osc, 
								'bo_nao_possui', bo_nao_possui
							)
						)
					FROM 
						osc.tb_recursos_osc
					WHERE 
						id_osc = 987654
				),
				'recursos_outros', (
					SELECT
						json_agg(
							json_build_object(
								'tx_nome_fonte_recursos_outro_osc', tx_nome_fonte_recursos_outro_osc, 
								'ft_nome_fonte_recursos_outro_osc', ft_nome_fonte_recursos_outro_osc, 
								'dt_ano_recursos_outro_osc', dt_ano_recursos_outro_osc, 
								'ft_ano_recursos_outro_osc', ft_ano_recursos_outro_osc, 
								'nr_valor_recursos_outro_osc', nr_valor_recursos_outro_osc, 
								'ft_valor_recursos_outro_osc', ft_valor_recursos_outro_osc
							)
						)
					FROM 
						osc.tb_recursos_outro_osc
					WHERE 
						id_osc = 987654
				)
			)
		);
		
		flag := true;
		mensagem := 'Recursos de OSC retornadas.';
		
	ELSE 
		flag := false;
		mensagem := 'OSC não encontrada.';
	END IF;

	RETURN NEXT;
	
EXCEPTION
	WHEN others THEN 
		RAISE NOTICE '%', SQLERRM;
		flag := false;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_osc_recursos(987654::TEXT);
