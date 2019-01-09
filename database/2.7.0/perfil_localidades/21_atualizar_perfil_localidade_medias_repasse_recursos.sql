DROP FUNCTION IF EXISTS portal.atualizar_perfil_localidade_medias_repasse_recursos() CASCADE;

CREATE OR REPLACE FUNCTION portal.atualizar_perfil_localidade_medias_repasse_recursos() RETURNS VOID AS $$ 

DECLARE
	nacional RECORD;
	quantidade_osc_nacional INTEGER;
	soma_repasse_nacional DOUBLE PRECISION;
	media_nacional DOUBLE PRECISION;
	repasse_maior_media_nacional TEXT;
	maior_media_nacional DOUBLE PRECISION;
	localidade RECORD;
	series JSONB;
	dados JSONB;
	atualizado JSONB;
	media_localidade DOUBLE PRECISION;
	repasse_maior_media_localidade TEXT;
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

	SELECT INTO soma_repasse_nacional SUM(COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0)) AS nr_valor_recursos
	FROM osc.tb_osc
	LEFT JOIN osc.tb_recursos_osc
	ON tb_osc.id_osc = tb_recursos_osc.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809;
	
	media_nacional := soma_repasse_nacional / quantidade_osc_nacional::DOUBLE PRECISION;

	FOR nacional IN 
		SELECT 
			dc_fonte_recursos_osc.tx_nome_fonte_recursos_osc AS fonte_recursos_osc,
			SUM(COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0)) AS valor_recursos
		FROM osc.tb_osc
		LEFT JOIN osc.tb_recursos_osc
		ON tb_osc.id_osc = tb_recursos_osc.id_osc
		LEFT JOIN syst.dc_fonte_recursos_osc
		ON tb_recursos_osc.cd_fonte_recursos_osc = dc_fonte_recursos_osc.cd_fonte_recursos_osc
		WHERE tb_osc.bo_osc_ativa
		AND tb_osc.id_osc <> 789809
		GROUP BY dc_fonte_recursos_osc.tx_nome_fonte_recursos_osc
		ORDER BY valor_recursos DESC
		LIMIT 1
	LOOP
		repasse_maior_media_nacional := nacional.fonte_recursos_osc::TEXT;
		maior_media_nacional := nacional.valor_recursos::DOUBLE PRECISION / soma_repasse_nacional::DOUBLE PRECISION * 100;
	END LOOP;

	RAISE NOTICE 'quantidade_osc_nacional: %', quantidade_osc_nacional;
	RAISE NOTICE 'soma_repasse_nacional: %', soma_repasse_nacional;
	RAISE NOTICE 'media_nacional: %', media_nacional;
	RAISE NOTICE 'repasse_maior_media_nacional: %', repasse_maior_media_nacional;
	RAISE NOTICE 'maior_media_nacional: %', maior_media_nacional;



	/* ------------------------------ Cálculo da média das localidades ------------------------------ */
	FOR localidade IN
		SELECT id_localidade, carasteristicas, repasse_recursos
		FROM portal.tb_perfil_localidade
		WHERE tx_tipo_localidade = 'regiao'
		--OR tx_tipo_localidade = 'estado'
	LOOP
		atualizado := '[]'::JSONB;
		quantidade_osc_localidade := (carasteristicas->>'nr_quantidade_oscs')::INTEGER;
		media_localidade := 0;
		repasse_maior_media_localidade := '';
		maior_media_localidade := 0;
		
		IF (localidade.repasse_recursos->>'series_1') IS null THEN
			series := localidade.repasse_recursos;
		ELSE
			series := localidade.repasse_recursos->>'series_1';
		END IF;
		
		FOR dados IN 
			SELECT *
			FROM jsonb_array_elements(series)
		LOOP
			media_localidade := (dados->>'nr_quantidade_oscs')::DOUBLE PRECISION / quantidade_osc_localidade::DOUBLE PRECISION * 100;
			dados := dados || ('{"media":' || media_localidade::TEXT || '}')::JSONB;
			atualizado := atualizado || dados;
			
			IF media_localidade >= maior_media_localidade THEN
				repasse_maior_media_localidade := (dados->>'tx_nome_natureza_juridica')::TEXT;
				maior_media_localidade := media_localidade;
			END IF;
			
		END LOOP;
		
		atualizado := ('{
			"nr_porcentagem_maior": "' || maior_media_localidade::TEXT || '", 
			"tx_porcentagem_maior": "' || repasse_maior_media_localidade::TEXT || '", 
			"nr_porcentagem_maior_media_nacional": "' || maior_media_nacional::TEXT || '", 
			"tx_porcentagem_maior_media_nacional": "' || repasse_maior_media_nacional || '", 
			"series_1": ' || atualizado::TEXT || 
		'}')::JSONB;
		
		UPDATE portal.tb_perfil_localidade
		SET natureza_juridica = atualizado
		WHERE id_localidade = localidade.id_localidade;
	END LOOP;
	


	/* ------------------------------ Cálculo da média das localidades ------------------------------ */
	FOR localidade IN
		SELECT id_localidade, caracteristicas, natureza_juridica
		FROM portal.tb_perfil_localidade
		WHERE tx_tipo_localidade = 'regiao'
		--OR tx_tipo_localidade = 'estado'
	LOOP
		IF (localidade.natureza_juridica->>'values') IS null THEN
			series := localidade.natureza_juridica;
		ELSE
			series := localidade.natureza_juridica->>'values';
		END IF;

	END LOOP;
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_perfil_localidade_medias_repasse_recursos();
