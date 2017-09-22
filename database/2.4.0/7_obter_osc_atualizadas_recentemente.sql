DROP FUNCTION IF EXISTS portal.obter_osc_atualizadas_recentemente();

CREATE OR REPLACE FUNCTION portal.obter_osc_atualizadas_recentemente() RETURNS TABLE(
	oscs INTEGER[]
)AS $$

DECLARE 
	idtabela INTEGER;
	nometabela TEXT;

BEGIN 
	FOR idtabela, nometabela IN SELECT id_tabela, tx_nome_tabela FROM log.tb_log_alteracao ORDER BY dt_alteracao DESC LIMIT 10 
	LOOP 
		IF nometabela = 'osc.tb_participacao_social_conselho' THEN 
			oscs := array_append(oscs, (SELECT id_osc FROM osc.tb_participacao_social_conselho WHERE id_conselho = idtabela)); 
		ELSIF nometabela = 'osc.tb_representante_conselho' THEN 
			oscs := array_append(oscs, (SELECT id_osc FROM osc.tb_representante_conselho WHERE id_representante_conselho = idtabela)); 
		ELSIF nometabela = 'osc.tb_representante_conferencia' THEN 
			oscs := array_append(oscs, (SELECT id_osc FROM osc.tb_representante_conferencia WHERE id_representante_conferencia = idtabela)); 
		ELSE 
			oscs := array_append(oscs, idtabela); 
		END IF;
	END LOOP; 
	
	RETURN NEXT;
	
END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_osc_atualizadas_recentemente();
