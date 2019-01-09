DROP FUNCTION IF EXISTS portal.atualizar_perfil_localidade_medias_natureza_juridica() CASCADE;

CREATE OR REPLACE FUNCTION portal.atualizar_perfil_localidade_medias_natureza_juridica() RETURNS VOID AS $$ 

DECLARE
	localidade RECORD;
	dados JSONB;
	atualizado JSONB := '[]'::JSONB;
	quantidade_osc INTEGER := 0;
	media DOUBLE PRECISION := 0;
	natureza_juridica_maior_media TEXT := '';
	maior_media DOUBLE PRECISION := 0;

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

		FOR dados IN 
			SELECT *
			FROM jsonb_array_elements(localidade.natureza_juridica)
		LOOP
			media := (dados->>'nr_quantidade_oscs')::DOUBLE PRECISION / quantidade_osc * 100;
			dados := dados || ('{"media":' || media::TEXT || '}')::JSONB;
			atualizado := atualizado || dados;
			
			IF media >= maior_media THEN
				natureza_juridica_maior_media := (dados->>'tx_nome_natureza_juridica')::TEXT;
				maior_media := media;
			END IF;
			
		END LOOP;
		
		atualizado := ('{"nr_porcentagem_maior": "' || maior_media::TEXT || '", "tx_porcentagem_maior": "' || natureza_juridica_maior_media::TEXT || '", "series_1": ' || atualizado::TEXT || '}')::JSONB;
		
		RAISE NOTICE 'Localidade: %', localidade.id_localidade;
		RAISE NOTICE 'Atualizado: %', atualizado;
		RAISE NOTICE 'Maior Média Natureza Jurdica: %', natureza_juridica_maior_media;
		RAISE NOTICE 'Maior Média: %', maior_media;
		RAISE NOTICE '';
		
		UPDATE portal.tb_perfil_localidade
		SET natureza_juridica = atualizado
		WHERE id_localidade = localidade.id_localidade;
		
		atualizado := '[]'::JSONB;
		quantidade_osc := 0;
		media := 0;
		natureza_juridica_maior_media := '';
		maior_media := 0;
	END LOOP;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_perfil_localidade_medias_natureza_juridica();