DROP FUNCTION IF EXISTS portal.obter_exportacao_busca(INTEGER[], INTEGER[]);

CREATE OR REPLACE FUNCTION portal.obter_exportacao_busca(lista_osc INTEGER[], variaveis_adicionais INTEGER[]) RETURNS TABLE (
	resultado JSONB, 
	mensagem TEXT, 
	codigo INTEGER
) AS $$ 

DECLARE
	indice INTEGER;
	apelido TEXT;
	colunas_adicionais TEXT;
	resultado_record RECORD; 

BEGIN
	colunas_adicionais := '';

	FOREACH indice IN ARRAY variaveis_adicionais
	LOOP 
		RAISE NOTICE '%', indice;

		SELECT INTO apelido
			regexp_replace(reverse(split_part(reverse(tx_nome_indice), \' - \', 1)), \'^[0-9]*\', \'\')
		FROM ipeadata.tb_indice
		WHERE cd_indice = indice;

		colunas_adicionais := colunas_adicionais || ', (
			SELECT nr_valor AS ' || apelido || '
			FROM ipeadata.tb_ipeadata
			WHERE cd_indice = ' || indice::TEXT || '
		)';
	END LOOP;

	EXECUTE '
		SELECT INTO resultado_record 
			a.id_osc AS id_osc,
			a.tx_razao_social_osc AS tx_razao_social,
			b.tx_nome_natureza_juridica AS tx_natureza_juridica,
			c.tx_nome_classe_atividade_economica AS tx_classe_atividade_economica,
			d.edmu_nm_municipio AS tx_municipio,
			d.eduf_nm_uf AS tx_estado
			' || colunas_adicionais || '
		FROM osc.tb_dados_gerais AS a
		LEFT JOIN syst.dc_natureza_juridica AS b
		ON a.cd_natureza_juridica_osc = b.cd_natureza_juridica
		LEFT JOIN syst.dc_classe_atividade_economica AS c
		ON a.cd_classe_atividade_economica_osc = c.cd_classe_atividade_economica
		LEFT JOIN (
			osc.tb_localizacao AS a
			INNER JOIN spat.ed_municipio AS b
			ON a.cd_municipio = b.edmu_cd_municipio
			INNER JOIN spat.ed_uf AS c
			ON b.eduf_cd_uf = c.eduf_cd_uf
		) AS d
		ON a.id_osc = d.id_osc
		WHERE a.id_osc = ANY (?::INTEGER[])
	';

	IF resultado_record IS NOT null THEN 
		resultado := to_jsonb(resultado_record);
		codigo := 200;
		mensagem := 'OSCs retornadas.';
	ELSE 
		codigo := 404;
		mensagem := 'OSCs não encontrada.';
	END IF;

	RETURN NEXT;
	
EXCEPTION
	WHEN others THEN 
		codigo := 400;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;
$$ LANGUAGE 'plpgsql';

SELECT * FROM portal.obter_exportacao_busca('{987654}'::INTEGER[], '{1, 2, 3}'::INTEGER[]);