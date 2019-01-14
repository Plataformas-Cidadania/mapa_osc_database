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
	dados_fonte JSONB;
	atualizado JSONB;
	soma_repasse_localidade DOUBLE PRECISION;
	soma_repasse_fonte DOUBLE PRECISION;
	media_localidade DOUBLE PRECISION;
	porcentagem_localidade DOUBLE PRECISION;
	repasse_maior_media_localidade TEXT;
	maior_media_localidade DOUBLE PRECISION;
	numero_repasses_localidade INTEGER;

BEGIN
	/* ------------------------------ Cálculo da média nacional ------------------------------ */
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
	
	/* ------------------------------ Cálculo da média das localidades ------------------------------ */
	soma_repasse_localidade := 0;
	
	FOR localidade IN
		SELECT id_localidade, repasse_recursos
		FROM portal.tb_perfil_localidade
		WHERE tx_tipo_localidade = 'regiao'
		--OR tx_tipo_localidade = 'estado'
	LOOP
		IF (localidade.repasse_recursos->>'series_1') IS null THEN
			series := localidade.repasse_recursos;
		ELSE
			series := localidade.repasse_recursos->>'series_1';
		END IF;
		
		FOR dados_fonte IN
			SELECT *
			FROM jsonb_array_elements((series)::JSONB)
		LOOP
			soma_repasse_localidade := soma_repasse_localidade + (dados_fonte->>'y')::DOUBLE PRECISION;
		END LOOP;
	END LOOP;
	
	FOR localidade IN
		SELECT id_localidade, tx_localidade, repasse_recursos
		FROM portal.tb_perfil_localidade
		WHERE tx_tipo_localidade = 'regiao'
		--OR tx_tipo_localidade = 'estado'
	LOOP
		atualizado := '[]'::JSONB;
		media_localidade := 0;
		repasse_maior_media_localidade := '';
		maior_media_localidade := 0;
		numero_repasses_localidade := 0;

		IF (localidade.repasse_recursos->>'series_1') IS null THEN
			series := localidade.repasse_recursos;
		ELSE
			series := localidade.repasse_recursos->>'series_1';
		END IF;

		soma_repasse_fonte := 0;

		FOR dados_fonte IN
			SELECT *
			FROM jsonb_array_elements(series::JSONB)
		LOOP
			soma_repasse_fonte := soma_repasse_fonte + (dados_fonte->>'y')::DOUBLE PRECISION;
			numero_repasses_localidade := numero_repasses_localidade + 1;
		END LOOP;

		FOR dados IN
			SELECT *
			FROM jsonb_array_elements(series)
		LOOP
			IF soma_repasse_localidade > 0 THEN
				media_localidade := soma_repasse_localidade::DOUBLE PRECISION / JSONB_ARRAY_LENGTH((dados->>'values')::JSONB)::DOUBLE PRECISION;
				porcentagem_localidade := soma_repasse_fonte::DOUBLE PRECISION / soma_repasse_localidade::DOUBLE PRECISION * 100;
			ELSE
				media_localidade := 0;
				porcentagem_localidade := 0;	
			END IF;
			dados := dados || ('{"media":' || media_localidade::TEXT || '}')::JSONB;
			atualizado := atualizado || dados;
		END LOOP;
		
		IF media_localidade >= maior_media_localidade THEN
			repasse_maior_media_localidade := localidade.tx_localidade;
			maior_media_localidade := media_localidade;
		END IF;
		/*
		RAISE NOTICE '%', soma_repasse_localidade::TEXT;
		RAISE NOTICE '%', repasse_maior_media_localidade::TEXT;
		RAISE NOTICE '%', media_localidade::TEXT;
		RAISE NOTICE '%', porcentagem_localidade::TEXT;
		RAISE NOTICE '%', repasse_maior_media_nacional::TEXT;
		*/
		
		atualizado := ('{
			"tx_maior_tipo_repasse": "' || repasse_maior_media_localidade::TEXT || '", 
			"nr_repasse_media": "' || media_localidade::TEXT || '", 
			"nr_porcentagem_maior_tipo_repasse": "' || porcentagem_localidade::TEXT || '", 
			"tx_repasse_media_nacional": "' || repasse_maior_media_nacional::TEXT || '", 
			"nr_repasse_media_nacional": "' || maior_media_nacional::TEXT || '", 
			"series_1": ' || atualizado::TEXT || 
		'}')::JSONB;
		
		RAISE NOTICE '%', atualizado;
		RAISE NOTICE '--------------------------------------------------';
		
		--UPDATE portal.tb_perfil_localidade
		--SET repasse_recursos = atualizado
		--WHERE id_localidade = localidade.id_localidade;
	END LOOP;
	
END;

$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.atualizar_perfil_localidade_medias_repasse_recursos();
