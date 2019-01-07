DO $$ 

DECLARE
	localidade RECORD;
	dados JSONB;
	atualizado JSONB := '[]'::JSONB;
	quantidade_osc INTEGER := 0;
	media DOUBLE PRECISION := 0;

BEGIN
	FOR localidade IN
		SELECT id_localidade, natureza_juridica
		FROM portal.tb_perfil_localidade
		WHERE tx_tipo_localidade = 'regiao'
		--OR tx_tipo_localidade = 'estado'
	LOOP
		FOR dados IN 
			SELECT *
			FROM jsonb_array_elements(localidade.natureza_juridica)
		LOOP
			quantidade_osc := quantidade_osc + (dados->>'nr_quantidade_oscs')::INTEGER;
		END LOOP;

		RAISE NOTICE 'Localidade: %', localidade.id_localidade;
        
		FOR dados IN 
			SELECT *
			FROM jsonb_array_elements(localidade.natureza_juridica)
		LOOP
			media := (dados->>'nr_quantidade_oscs')::DOUBLE PRECISION / quantidade_osc * 100;
			dados := dados || ('{"media":' || media::TEXT || '}')::JSONB;
			atualizado := atualizado || dados;
		END LOOP;
		
		UPDATE portal.tb_perfil_localidade
		SET natureza_juridica = atualizado
		WHERE id_localidade = localidade.id_localidade; 
		
		quantidade_osc := 0;
		media := 0;
	END LOOP;
END
$$;