DROP FUNCTION IF EXISTS portal.atualizar_perfil_localidade_medias_natureza_juridica() CASCADE;

CREATE OR REPLACE FUNCTION portal.atualizar_perfil_localidade_medias_natureza_juridica() RETURNS VOID AS $$ 

DECLARE
	localidade RECORD;
	series JSONB;
	dados JSONB;
	atualizado JSONB;
	quantidade_osc_localidade INTEGER;
	media_localidade DOUBLE PRECISION;
	natureza_juridica_maior_media_localidade TEXT;
	maior_media_localidade DOUBLE PRECISION;

BEGIN
	FOR localidade IN
		SELECT id_localidade, natureza_juridica
		FROM portal.tb_perfil_localidade
		WHERE tx_tipo_localidade = 'regiao'
		--OR tx_tipo_localidade = 'estado'
	LOOP
		atualizado := '[]'::JSONB;
		quantidade_osc_localidade := 0;
		media_localidade := 0;
		natureza_juridica_maior_media_localidade := '';
		maior_media_localidade := 0;
		
		IF (localidade.natureza_juridica->>'series_1') IS null THEN
			series := localidade.natureza_juridica;
		ELSE
			series := localidade.natureza_juridica->>'series_1';
		END IF;
		
		FOR dados IN 
			SELECT *
			FROM jsonb_array_elements(series)
		LOOP
			quantidade_osc_localidade := quantidade_osc_localidade + (dados->>'nr_quantidade_oscs')::INTEGER;
		END LOOP;

		FOR dados IN 
			SELECT *
			FROM jsonb_array_elements(series)
		LOOP
			media_localidade := (dados->>'nr_quantidade_oscs')::DOUBLE PRECISION / quantidade_osc_localidade::DOUBLE PRECISION * 100;
			dados := dados || ('{"media":' || media_localidade::TEXT || '}')::JSONB;
			atualizado := atualizado || dados;
			
			IF media_localidade >= maior_media_localidade THEN
				natureza_juridica_maior_media_localidade := (dados->>'tx_nome_natureza_juridica')::TEXT;
				maior_media_localidade := media_localidade;
			END IF;
			
		END LOOP;
		
		atualizado := ('{"nr_porcentagem_maior": "' || maior_media_localidade::TEXT || '", "tx_porcentagem_maior": "' || natureza_juridica_maior_media_localidade::TEXT || '", "series_1": ' || atualizado::TEXT || '}')::JSONB;
		
		RAISE NOTICE 'Localidade: %', localidade.id_localidade;
		RAISE NOTICE 'Atualizado: %', atualizado;
		RAISE NOTICE 'Maior Média Natureza Jurdica: %', natureza_juridica_maior_media_localidade;
		RAISE NOTICE 'Maior Média: %', maior_media_localidade;
		RAISE NOTICE '';
		
		UPDATE portal.tb_perfil_localidade
		SET natureza_juridica = atualizado
		WHERE id_localidade = localidade.id_localidade;
	END LOOP;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_perfil_localidade_medias_natureza_juridica();
