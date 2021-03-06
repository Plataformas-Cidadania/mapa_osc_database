DROP FUNCTION IF EXISTS portal.obter_exportacao_busca(lista_osc integer[], variaveis_adicionais integer[]);

CREATE OR REPLACE FUNCTION portal.obter_exportacao_busca(lista_osc integer[], variaveis_adicionais integer[])
    returns TABLE(resultado jsonb, mensagem text, codigo integer)
    language plpgsql
as
$$
DECLARE
	indice INTEGER;
	apelido TEXT;
	colunas_adicionais TEXT;

BEGIN
	colunas_adicionais := '';

	FOREACH indice IN ARRAY variaveis_adicionais
	LOOP
		SELECT INTO apelido tx_sigla
		FROM ipeadata.tb_indice
		WHERE cd_indice = indice;

		IF apelido IS NOT null THEN
			colunas_adicionais := colunas_adicionais || ', (
				SELECT nr_valor AS ' || apelido || '
				FROM ipeadata.tb_ipeadata
				WHERE cd_indice = ' || indice::TEXT || '
				AND cd_municipio = d.cd_municipio
			)';
		END IF;
	END LOOP;

	RAISE NOTICE '%', '
		SELECT to_json(array_agg(row_to_json(a)))
		FROM (
			SELECT
				a.id_osc AS id_osc,
	            o.cd_identificador_osc AS cd_identificador_osc,
				a.tx_razao_social_osc AS tx_razao_social,
				b.tx_nome_natureza_juridica AS tx_natureza_juridica,
				c.tx_nome_classe_atividade_economica AS tx_classe_atividade_economica,
				d.edmu_nm_municipio AS tx_municipio,
				d.eduf_nm_uf AS tx_estado
				' || colunas_adicionais || '
			FROM osc.tb_dados_gerais AS a
	        LEFT JOIN osc.tb_osc as o
				ON a.id_osc = o.id_osc
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
			WHERE a.id_osc = ANY(''{789809, 394905}''::INTEGER[])
		) AS a
	';

	EXECUTE '
		SELECT to_json(array_agg(row_to_json(a)))
		FROM (
			SELECT
				a.id_osc AS id_osc,
	            o.cd_identificador_osc AS cd_identificador_osc,
				a.tx_razao_social_osc AS tx_razao_social,
				b.tx_nome_natureza_juridica AS tx_natureza_juridica,
				c.tx_nome_classe_atividade_economica AS tx_classe_atividade_economica,
				d.edmu_nm_municipio AS tx_municipio,
				d.eduf_nm_uf AS tx_estado
				' || colunas_adicionais || '
			FROM osc.tb_dados_gerais AS a
	        LEFT JOIN osc.tb_osc AS o
				ON a.id_osc = o.id_osc
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
			WHERE a.id_osc = ANY($1)
		) AS a
	'
	INTO resultado
	USING lista_osc;

	IF resultado IS NOT null THEN
		codigo := 200;
		mensagem := 'OSCs retornadas.';
	ELSE
		codigo := 404;
		mensagem := 'OSCs não encontrada.';
	END IF;

	RETURN NEXT;

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '%', SQLERRM;
		codigo := 400;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;
$$;

alter function portal.obter_exportacao_busca(integer[], integer[]) owner to "postgres";

