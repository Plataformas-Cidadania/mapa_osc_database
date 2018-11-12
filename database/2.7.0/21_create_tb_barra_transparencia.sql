DROP TABLE IF EXISTS portal.tb_barra_transparencia;

CREATE TABLE portal.tb_barra_transparencia
(
    id_barra_transparencia SERIAL NOT NULL, -- Identificador da transparência
    id_osc INTEGER UNIQUE NOT NULL, -- Identificador da OSC
    transparencia_dados_gerais NUMERIC, -- Pontuação da transparência dos dados gerais
	peso_dados_gerais DOUBLE PRECISION, -- Peso da transparência dos dados gerais
	transparencia_area_atuacao NUMERIC, -- Pontuação da transparência da área de atuação
	peso_area_atuacao DOUBLE PRECISION, -- Peso da transparência da área de atuação
	transparencia_descricao NUMERIC, -- Pontuação da transparência da descrição
	peso_descricao DOUBLE PRECISION, -- Peso da transparência da descrição
	transparencia_titulos_certificacoes NUMERIC, -- Pontuação da transparência das certificações
	peso_titulos_certificacoes DOUBLE PRECISION, -- Peso da transparência das certificações
	transparencia_relacoes_trabalho_governanca NUMERIC, -- Pontuação da transparência das relações de trabalho e governança
	peso_relacoes_trabalho_governanca DOUBLE PRECISION, -- Peso da transparência das relações de trabalho e governança
	transparencia_espacos_participacao_social NUMERIC, -- Pontuação da transparência da participação social
	peso_espacos_participacao_social DOUBLE PRECISION, -- Peso da transparência da participação social
	transparencia_projetos_atividades_programas NUMERIC, -- Pontuação da transparência das atividades e programas
	peso_projetos_atividades_programas DOUBLE PRECISION, -- Peso da transparência das atividades e programas
	transparencia_fontes_recursos NUMERIC, -- Pontuação da transparência das fontes de recursos
	peso_fontes_recursos DOUBLE PRECISION, -- Peso da transparência das fontes de recursos
    transparencia_osc NUMERIC, -- Pontuação da transparência da OSC
    CONSTRAINT fk_barra_transparencia FOREIGN KEY (id_osc) REFERENCES osc.tb_osc (id_osc)
);

CREATE UNIQUE INDEX ix_tb_barra_transparencia
    ON portal.tb_barra_transparencia USING btree
    (id_osc ASC NULLS LAST)
TABLESPACE pg_default;
