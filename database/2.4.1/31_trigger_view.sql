CREATE UNIQUE INDEX ix_vw_busca_resultado
    ON osc.vw_busca_resultado USING btree
    (id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION vw_busca_resultado()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY osc.vw_busca_resultado;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER vw_busca_resultado
    AFTER INSERT OR DELETE OR UPDATE OF tx_nome_fantasia_osc
    ON osc.tb_dados_gerais
    EXECUTE PROCEDURE vw_busca_resultado();


-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_area_atuacao
    ON portal.vw_osc_area_atuacao USING btree
    (id_osc, cd_area_atuacao, cd_subarea_atuacao ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION area_atuacao()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_area_atuacao;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER area_atuacao
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_area_atuacao
    FOR EACH ROW
    EXECUTE PROCEDURE area_atuacao();

-- ----------------------

CREATE UNIQUE INDEX ix_vw_osc_dados_gerais
    ON portal.vw_osc_dados_gerais USING btree
    (id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_vw_osc_descricao
    ON portal.vw_osc_descricao USING btree
    (id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX ix_vw_osc_recursos_projeto
    ON portal.vw_osc_recursos_projeto USING btree
    (id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION dados_gerais()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_dados_gerais;
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_descricao;
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_recursos_projeto;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER dados_gerais
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_dados_gerais
    FOR EACH ROW
    EXECUTE PROCEDURE dados_gerais();

CREATE TRIGGER dados_gerais
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_contato
    FOR EACH ROW
    EXECUTE PROCEDURE dados_gerais();

-- ----------------------

CREATE UNIQUE INDEX ix_vw_osc_area_atuacao_outra
    ON portal.vw_osc_area_atuacao_outra USING btree
    (id_osc,id_area_atuacao_outra ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION area_atuacao_outra()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_area_atuacao_outra;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER area_atuacao_outra
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_area_atuacao_outra
    FOR EACH ROW
    EXECUTE PROCEDURE area_atuacao_outra();

-- ----------------------

CREATE UNIQUE INDEX ix_vw_osc_area_atuacao_outra_projeto
    ON portal.vw_osc_area_atuacao_outra_projeto USING btree
    (id_projeto,id_area_atuacao_outra_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION area_atuacao_outra_projeto()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_area_atuacao_outra_projeto;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER area_atuacao_outra_projeto
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_area_atuacao_outra_projeto
    FOR EACH ROW
    EXECUTE PROCEDURE area_atuacao_outra_projeto();

-- ----------------------

CREATE UNIQUE INDEX ix_vw_osc_area_atuacao_projeto
    ON portal.vw_osc_area_atuacao_projeto USING btree
    (id_projeto,cd_area_atuacao_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION area_atuacao_projeto()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_area_atuacao_projeto;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER area_atuacao_projeto
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_area_atuacao_projeto
    FOR EACH ROW
    EXECUTE PROCEDURE area_atuacao_projeto();

-- ----------------------

CREATE UNIQUE INDEX ix_vw_osc_certificado
    ON portal.vw_osc_certificado USING btree
    (id_osc,id_certificado ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION certificado()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_certificado;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER certificado
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_certificado
    FOR EACH ROW
    EXECUTE PROCEDURE certificado();

-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_conselho_fiscal
    ON portal.vw_osc_conselho_fiscal USING btree
    (id_osc,id_conselheiro ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION conselho_fiscal()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_conselho_fiscal;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER conselho_fiscal
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_conselho_fiscal
    FOR EACH ROW
    EXECUTE PROCEDURE conselho_fiscal();
-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_financiador_projeto
    ON portal.vw_osc_financiador_projeto USING btree
    (id_projeto,id_financiador_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION financiador_projeto()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_financiador_projeto;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER financiador_projeto
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_financiador_projeto
    FOR EACH ROW
    EXECUTE PROCEDURE financiador_projeto();
-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_fonte_recursos_projeto
    ON portal.vw_osc_fonte_recursos_projeto USING btree
    (id_projeto,id_fonte_recursos_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION fonte_recursos_projeto()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_fonte_recursos_projeto;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER fonte_recursos_projeto
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_fonte_recursos_projeto
    FOR EACH ROW
    EXECUTE PROCEDURE fonte_recursos_projeto();
-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_governanca
    ON portal.vw_osc_governanca USING btree
    (id_osc,id_dirigente ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION governanca()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_governanca;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER governanca
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_governanca
    FOR EACH ROW
    EXECUTE PROCEDURE governanca();
-- ----------------------
DROP MATERIALIZED VIEW portal.vw_osc_localizacao_projeto;

CREATE MATERIALIZED VIEW portal.vw_osc_localizacao_projeto
TABLESPACE pg_default
AS
 SELECT tb_localizacao_projeto.id_projeto,
    tb_localizacao_projeto.id_localizacao_projeto,
    tb_localizacao_projeto.id_regiao_localizacao_projeto,
    tb_localizacao_projeto.tx_nome_regiao_localizacao_projeto,
    tb_localizacao_projeto.ft_nome_regiao_localizacao_projeto,
    tb_localizacao_projeto.bo_localizacao_prioritaria,
    tb_localizacao_projeto.ft_localizacao_prioritaria
   FROM osc.tb_osc
     JOIN osc.tb_projeto ON tb_projeto.id_osc = tb_osc.id_osc
     JOIN osc.tb_localizacao_projeto ON tb_localizacao_projeto.id_projeto = tb_projeto.id_projeto
  WHERE tb_osc.bo_osc_ativa; -- Depois de refazer essa view , verificar as permissões e privilégios.

CREATE UNIQUE INDEX ix_vw_osc_localizacao_projeto
    ON portal.vw_osc_localizacao_projeto USING btree
    (id_projeto,id_localizacao_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION localizacao_projeto()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_localizacao_projeto;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER localizacao_projeto
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_localizacao_projeto
    FOR EACH ROW
    EXECUTE PROCEDURE localizacao_projeto();
-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_objetivo_osc
    ON portal.vw_osc_objetivo_osc USING btree
    (id_osc,id_objetivo_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION objetivo_osc()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_objetivo_osc;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER objetivo_osc
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_objetivo_osc
    FOR EACH ROW
    EXECUTE PROCEDURE objetivo_osc();
-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_objetivo_projeto
    ON portal.vw_osc_objetivo_projeto USING btree
    (id_projeto,id_objetivo_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION objetivo_projeto()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_objetivo_projeto;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER objetivo_projeto
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_objetivo_projeto
    FOR EACH ROW
    EXECUTE PROCEDURE objetivo_projeto();
-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_parceira_projeto
    ON portal.vw_osc_parceira_projeto USING btree
    (id_projeto,id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION parceira_projeto()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_parceira_projeto;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER parceira_projeto
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_osc_parceira_projeto
    FOR EACH ROW
    EXECUTE PROCEDURE parceira_projeto();
-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_participacao_social_conferencia
    ON portal.vw_osc_participacao_social_conferencia USING btree
    (id_osc,id_conferencia ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION participacao_social_conferencia()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_participacao_social_conferencia;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER participacao_social_conferencia
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_participacao_social_conferencia
    FOR EACH ROW
    EXECUTE PROCEDURE participacao_social_conferencia();
-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_participacao_social_conferencia_outra
    ON portal.vw_osc_participacao_social_conferencia_outra USING btree
    (id_osc,id_conferencia_outra ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION participacao_social_conferencia_outra()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_participacao_social_conferencia_outra;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER participacao_social_conferencia_outra
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_participacao_social_conferencia_outra
    FOR EACH ROW
    EXECUTE PROCEDURE participacao_social_conferencia_outra();
-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_participacao_social_conselho
    ON portal.vw_osc_participacao_social_conselho USING btree
    (id_osc,id_conselho ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION participacao_social_conselho()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_participacao_social_conselho;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER participacao_social_conselho
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_participacao_social_conselho
    FOR EACH ROW
    EXECUTE PROCEDURE participacao_social_conselho();
-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_participacao_social_conselho_outro
    ON portal.vw_osc_participacao_social_conselho_outro USING btree
    (id_osc,id_conselho_outro ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION participacao_social_conselho_outro()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_participacao_social_conselho_outro;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER participacao_social_conselho_outro
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_participacao_social_conselho_outro
    FOR EACH ROW
    EXECUTE PROCEDURE participacao_social_conselho_outro();
-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_participacao_social_outra
    ON portal.vw_osc_participacao_social_outra USING btree
    (id_osc,id_participacao_social_outra ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION participacao_social_outra()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_participacao_social_outra;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER participacao_social_outra
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_participacao_social_outra
    FOR EACH ROW
    EXECUTE PROCEDURE participacao_social_outra();
-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_projeto
    ON portal.vw_osc_projeto USING btree
    (id_osc,id_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION projeto()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW portal.vw_osc_projeto;
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_recursos_projeto;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER projeto
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_projeto
    FOR EACH ROW
    EXECUTE PROCEDURE projeto();
-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_publico_beneficiado_projeto
    ON portal.vw_osc_publico_beneficiado_projeto USING btree
    (id_publico_beneficiado,id_projeto ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION publico_beneficiado_projeto()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_publico_beneficiado_projeto;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER publico_beneficiado_projeto
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_publico_beneficiado_projeto
    FOR EACH ROW
    EXECUTE PROCEDURE publico_beneficiado_projeto();
-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_recursos_osc
    ON portal.vw_osc_recursos_osc USING btree
    (id_osc,id_recursos_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION recursos_osc()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_recursos_osc;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER recursos_osc
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_recursos_osc
    FOR EACH ROW
    EXECUTE PROCEDURE recursos_osc();
-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_recursos_outro_osc
    ON portal.vw_osc_recursos_outro_osc USING btree
    (id_osc,id_recursos_outro_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION recursos_outro_osc()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_recursos_outro_osc;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER recursos_outro_osc
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_recursos_outro_osc
    FOR EACH ROW
    EXECUTE PROCEDURE recursos_outro_osc();
-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_relacoes_trabalho
    ON portal.vw_osc_relacoes_trabalho USING btree
    (id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION relacoes_trabalho()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_relacoes_trabalho;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER relacoes_trabalho
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_relacoes_trabalho
    FOR EACH ROW
    EXECUTE PROCEDURE relacoes_trabalho();
-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_relacoes_trabalho_outra
    ON portal.vw_osc_relacoes_trabalho_outra USING btree
    (id_osc ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION relacoes_trabalho_outra()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_relacoes_trabalho_outra;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER relacoes_trabalho_outra
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_relacoes_trabalho_outra
    FOR EACH ROW
    EXECUTE PROCEDURE relacoes_trabalho_outra();
-- ----------------------
CREATE UNIQUE INDEX ix_vw_osc_representante_conselho
    ON portal.vw_osc_representante_conselho USING btree
    (id_osc,id_representante_conselho ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE OR REPLACE FUNCTION representante_conselho()
RETURNS TRIGGER AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY portal.vw_osc_representante_conselho;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER representante_conselho
    AFTER INSERT OR UPDATE OR DELETE ON osc.tb_representante_conselho
    FOR EACH ROW
    EXECUTE PROCEDURE representante_conselho();
