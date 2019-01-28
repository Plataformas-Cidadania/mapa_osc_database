DROP MATERIALIZED VIEW IF EXISTS analysis.vw_perfil_localidade_repasse_recursos CASCADE;
CREATE MATERIALIZED VIEW analysis.vw_perfil_localidade_repasse_recursos AS 

(
	SELECT 
		SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1) AS localidade,
		COALESCE(dc_fonte_recursos_osc.tx_nome_fonte_recursos_osc::TEXT, 'Sem informação') AS fonte_recursos,
		COALESCE(DATE_PART('year', tb_recursos_osc.dt_ano_recursos_osc)::TEXT, 'Sem informação') AS ano,
		SUM(COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0)) AS valor_recursos,
		REPLACE(('{' || TRIM(TRANSLATE(
			(
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
				ARRAY_CAT(
					ARRAY_CAT(
						ARRAY_CAT(
							ARRAY_CAT(
								ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
								ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
							),
							ARRAY_AGG(DISTINCT COALESCE(tb_recursos_osc.ft_fonte_recursos_osc, ''))
						),
						ARRAY_AGG(DISTINCT COALESCE(tb_recursos_osc.ft_ano_recursos_osc, ''))
					),
					ARRAY_AGG(DISTINCT COALESCE(tb_recursos_osc.ft_valor_recursos_osc, ''))
				))) AS a
			)::TEXT
		, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
	FROM osc.tb_osc
	LEFT JOIN osc.tb_dados_gerais
	ON tb_osc.id_osc = tb_dados_gerais.id_osc
	LEFT JOIN osc.tb_recursos_osc
	ON tb_osc.id_osc = tb_recursos_osc.id_osc
	LEFT JOIN syst.dc_fonte_recursos_osc
	ON tb_recursos_osc.cd_fonte_recursos_osc = dc_fonte_recursos_osc.cd_fonte_recursos_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade, ano, fonte_recursos

	UNION

	SELECT 
		SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 1) AS localidade,
		COALESCE(tb_recursos_outro_osc.tx_nome_fonte_recursos_outro_osc::TEXT, 'Sem informação') AS fonte_recursos,
		COALESCE(DATE_PART('year', tb_recursos_outro_osc.dt_ano_recursos_outro_osc)::TEXT, 'Sem informação') AS ano,
		SUM(COALESCE(tb_recursos_outro_osc.nr_valor_recursos_outro_osc, 0)) AS valor_recursos,
		REPLACE(('{' || TRIM(TRANSLATE(
			(
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
				ARRAY_CAT(
					ARRAY_CAT(
						ARRAY_CAT(
							ARRAY_CAT(
								ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
								ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
							),
							ARRAY_AGG(DISTINCT COALESCE(tb_recursos_outro_osc.ft_nome_fonte_recursos_outro_osc, ''))
						),
						ARRAY_AGG(DISTINCT COALESCE(tb_recursos_outro_osc.ft_ano_recursos_outro_osc, ''))
					),
					ARRAY_AGG(DISTINCT COALESCE(tb_recursos_outro_osc.ft_valor_recursos_outro_osc, ''))
				))) AS a
			)::TEXT
		, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
	FROM osc.tb_osc
	LEFT JOIN osc.tb_dados_gerais
	ON tb_osc.id_osc = tb_dados_gerais.id_osc
	LEFT JOIN osc.tb_recursos_outro_osc
	ON tb_osc.id_osc = tb_recursos_outro_osc.id_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade, ano, fonte_recursos
)

UNION

(
	SELECT 
		SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2) AS localidade,
		COALESCE(dc_fonte_recursos_osc.tx_nome_fonte_recursos_osc::TEXT, 'Sem informação') AS fonte_recursos,
		COALESCE(DATE_PART('year', tb_recursos_osc.dt_ano_recursos_osc)::TEXT, 'Sem informação') AS ano,
		SUM(COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0)) AS valor_recursos,
		REPLACE(('{' || TRIM(TRANSLATE(
			(
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
				ARRAY_CAT(
					ARRAY_CAT(
						ARRAY_CAT(
							ARRAY_CAT(
								ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
								ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
							),
							ARRAY_AGG(DISTINCT COALESCE(tb_recursos_osc.ft_fonte_recursos_osc, ''))
						),
						ARRAY_AGG(DISTINCT COALESCE(tb_recursos_osc.ft_ano_recursos_osc, ''))
					),
					ARRAY_AGG(DISTINCT COALESCE(tb_recursos_osc.ft_valor_recursos_osc, ''))
				))) AS a
			)::TEXT
		, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
	FROM osc.tb_osc
	LEFT JOIN osc.tb_dados_gerais
	ON tb_osc.id_osc = tb_dados_gerais.id_osc
	LEFT JOIN osc.tb_recursos_osc
	ON tb_osc.id_osc = tb_recursos_osc.id_osc
	LEFT JOIN syst.dc_fonte_recursos_osc
	ON tb_recursos_osc.cd_fonte_recursos_osc = dc_fonte_recursos_osc.cd_fonte_recursos_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade, ano, fonte_recursos

	UNION

	SELECT 
		SUBSTR(tb_localizacao.cd_municipio::TEXT, 1, 2) AS localidade,
		COALESCE(tb_recursos_outro_osc.tx_nome_fonte_recursos_outro_osc::TEXT, 'Sem informação') AS fonte_recursos,
		COALESCE(DATE_PART('year', tb_recursos_outro_osc.dt_ano_recursos_outro_osc)::TEXT, 'Sem informação') AS ano,
		SUM(COALESCE(tb_recursos_outro_osc.nr_valor_recursos_outro_osc, 0)) AS valor_recursos,
		REPLACE(('{' || TRIM(TRANSLATE(
			(
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
				ARRAY_CAT(
					ARRAY_CAT(
						ARRAY_CAT(
							ARRAY_CAT(
								ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
								ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
							),
							ARRAY_AGG(DISTINCT COALESCE(tb_recursos_outro_osc.ft_nome_fonte_recursos_outro_osc, ''))
						),
						ARRAY_AGG(DISTINCT COALESCE(tb_recursos_outro_osc.ft_ano_recursos_outro_osc, ''))
					),
					ARRAY_AGG(DISTINCT COALESCE(tb_recursos_outro_osc.ft_valor_recursos_outro_osc, ''))
				))) AS a
			)::TEXT
		, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
	FROM osc.tb_osc
	LEFT JOIN osc.tb_dados_gerais
	ON tb_osc.id_osc = tb_dados_gerais.id_osc
	LEFT JOIN osc.tb_recursos_outro_osc
	ON tb_osc.id_osc = tb_recursos_outro_osc.id_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade, ano, fonte_recursos
)

UNION

(
	SELECT 
		tb_localizacao.cd_municipio::TEXT AS localidade,
		COALESCE(dc_fonte_recursos_osc.tx_nome_fonte_recursos_osc::TEXT, 'Sem informação') AS fonte_recursos,
		COALESCE(DATE_PART('year', tb_recursos_osc.dt_ano_recursos_osc)::TEXT, 'Sem informação') AS ano,
		SUM(COALESCE(tb_recursos_osc.nr_valor_recursos_osc, 0)) AS valor_recursos,
		REPLACE(('{' || TRIM(TRANSLATE(
			(
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
				ARRAY_CAT(
					ARRAY_CAT(
						ARRAY_CAT(
							ARRAY_CAT(
								ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
								ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
							),
							ARRAY_AGG(DISTINCT COALESCE(tb_recursos_osc.ft_fonte_recursos_osc, ''))
						),
						ARRAY_AGG(DISTINCT COALESCE(tb_recursos_osc.ft_ano_recursos_osc, ''))
					),
					ARRAY_AGG(DISTINCT COALESCE(tb_recursos_osc.ft_valor_recursos_osc, ''))
				))) AS a
			)::TEXT
		, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
	FROM osc.tb_osc
	LEFT JOIN osc.tb_dados_gerais
	ON tb_osc.id_osc = tb_dados_gerais.id_osc
	LEFT JOIN osc.tb_recursos_osc
	ON tb_osc.id_osc = tb_recursos_osc.id_osc
	LEFT JOIN syst.dc_fonte_recursos_osc
	ON tb_recursos_osc.cd_fonte_recursos_osc = dc_fonte_recursos_osc.cd_fonte_recursos_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade, ano, fonte_recursos

	UNION

	SELECT 
		tb_localizacao.cd_municipio::TEXT AS localidade,
		COALESCE(tb_recursos_outro_osc.tx_nome_fonte_recursos_outro_osc::TEXT, 'Sem informação') AS fonte_recursos,
		COALESCE(DATE_PART('year', tb_recursos_outro_osc.dt_ano_recursos_outro_osc)::TEXT, 'Sem informação') AS ano,
		SUM(COALESCE(tb_recursos_outro_osc.nr_valor_recursos_outro_osc, 0)) AS valor_recursos,
		REPLACE(('{' || TRIM(TRANSLATE(
			(
				SELECT ARRAY_AGG(TRANSLATE(a::TEXT, '()', '')) FROM (SELECT DISTINCT UNNEST(
				ARRAY_CAT(
					ARRAY_CAT(
						ARRAY_CAT(
							ARRAY_CAT(
								ARRAY_AGG(DISTINCT COALESCE(tb_osc.ft_osc_ativa, '')),
								ARRAY_AGG(DISTINCT COALESCE(tb_localizacao.ft_municipio, ''))
							),
							ARRAY_AGG(DISTINCT COALESCE(tb_recursos_outro_osc.ft_nome_fonte_recursos_outro_osc, ''))
						),
						ARRAY_AGG(DISTINCT COALESCE(tb_recursos_outro_osc.ft_ano_recursos_outro_osc, ''))
					),
					ARRAY_AGG(DISTINCT COALESCE(tb_recursos_outro_osc.ft_valor_recursos_outro_osc, ''))
				))) AS a
			)::TEXT
		, '"\{}', ''), ',') || '}'), ',,', ',')::TEXT[] AS fontes
	FROM osc.tb_osc
	LEFT JOIN osc.tb_dados_gerais
	ON tb_osc.id_osc = tb_dados_gerais.id_osc
	LEFT JOIN osc.tb_recursos_outro_osc
	ON tb_osc.id_osc = tb_recursos_outro_osc.id_osc
	LEFT JOIN osc.tb_localizacao
	ON tb_osc.id_osc = tb_localizacao.id_osc
	WHERE tb_osc.bo_osc_ativa
	AND tb_osc.id_osc <> 789809
	AND tb_localizacao.cd_municipio IS NOT NULL
	GROUP BY localidade, ano, fonte_recursos
);

CREATE INDEX ix_localidade_vw_perfil_localidade_repasse_recursos
    ON analysis.vw_perfil_localidade_repasse_recursos USING btree
    (localidade ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX ix_ano_vw_perfil_localidade_repasse_recursos
    ON analysis.vw_perfil_localidade_repasse_recursos USING btree
    (ano ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX ix_fonte_recursos_vw_perfil_localidade_repasse_recursos
    ON analysis.vw_perfil_localidade_repasse_recursos USING btree
    (fonte_recursos ASC NULLS LAST)
    TABLESPACE pg_default;