DROP FUNCTION IF EXISTS portal.atualizar_perfil_localidade_medias_natureza_juridica() CASCADE;

CREATE OR REPLACE FUNCTION portal.atualizar_perfil_localidade_medias_natureza_juridica() RETURNS VOID AS $$ 

DECLARE
	nacional RECORD;
	quantidade_osc_nacional INTEGER;
	natureza_juridica_maior_media_nacional TEXT;
	maior_media_nacional DOUBLE PRECISION;
	localidade RECORD;
	series JSONB;
	dados JSONB;
	atualizado JSONB;
	quantidade_osc_localidade INTEGER;
	media_localidade DOUBLE PRECISION;
	natureza_juridica_maior_media_localidade TEXT;
	maior_media_localidade DOUBLE PRECISION;

BEGIN
	/* ------------------------------ Cálculo da média nacional ------------------------------ */
	maior_media_nacional := 0;
	
	SELECT INTO quantidade_osc_nacional COUNT(*)
	FROM osc.tb_osc
	LEFT JOIN osc.tb_dados_gerais
	ON tb_osc.id_osc = tb_dados_gerais.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809;
	
	FOR nacional IN 
		SELECT 
			COALESCE(dc_natureza_juridica.tx_nome_natureza_juridica, 'Sem informação') AS tx_nome_natureza_juridica,
			COUNT(tb_osc) AS nr_quantidade_oscs
		FROM osc.tb_osc
		LEFT JOIN osc.tb_dados_gerais
		ON tb_osc.id_osc = tb_dados_gerais.id_osc
		LEFT JOIN syst.dc_natureza_juridica
		ON tb_dados_gerais.cd_natureza_juridica_osc = dc_natureza_juridica.cd_natureza_juridica
		WHERE tb_osc.bo_osc_ativa
		AND tb_osc.id_osc <> 789809
		GROUP BY dc_natureza_juridica.tx_nome_natureza_juridica
		ORDER BY nr_quantidade_oscs DESC
		LIMIT 1
	LOOP
		natureza_juridica_maior_media_nacional := nacional.tx_nome_natureza_juridica::TEXT;
		maior_media_nacional := nacional.nr_quantidade_oscs::DOUBLE PRECISION / quantidade_osc_nacional::DOUBLE PRECISION * 100;
	END LOOP;



	/* ------------------------------ Cálculo da média das localidades ------------------------------ */
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
		
		atualizado := ('{
			"nr_porcentagem_maior": "' || maior_media_localidade::TEXT || '", 
			"tx_porcentagem_maior": "' || natureza_juridica_maior_media_localidade::TEXT || '", 
			"nr_porcentagem_maior_media_nacional": "' || maior_media_nacional::TEXT || '", 
			"tx_porcentagem_maior_media_nacional": "' || natureza_juridica_maior_media_nacional || '", 
			"series_1": ' || atualizado::TEXT || 
		'}')::JSONB;
		
		UPDATE portal.tb_perfil_localidade
		SET natureza_juridica = atualizado
		WHERE id_localidade = localidade.id_localidade;
	END LOOP;
	
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_perfil_localidade_medias_natureza_juridica();
