DROP FUNCTION IF EXISTS portal.atualizar_barra_transparencia(INTEGER);

CREATE OR REPLACE FUNCTION portal.atualizar_barra_transparencia(id_osc_req INTEGER) RETURNS VOID AS $$ 

DECLARE 
	transpararencia RECORD;
    osc RECORD;
	
BEGIN 
    DELETE FROM portal.tb_barra_transparencia WHERE id_osc = id_osc_req;

    FOR transpararencia IN SELECT * FROM portal.obter_pontuacao_barra_transparencia_osc(id_osc_req) LOOP 
        INSERT INTO 
            portal.tb_barra_transparencia(
                id_osc, 
                transparencia_dados_gerais, 
                peso_dados_gerais, 
                transparencia_area_atuacao, 
                peso_area_atuacao, 
                transparencia_descricao, 
                peso_descricao, 
                transparencia_titulos_certificacoes, 
                peso_titulos_certificacoes, 
                transparencia_relacoes_trabalho_governanca, 
                peso_relacoes_trabalho_governanca, 
                transparencia_espacos_participacao_social, 
                peso_espacos_participacao_social, 
                transparencia_projetos_atividades_programas, 
                peso_projetos_atividades_programas, 
                transparencia_fontes_recursos, 
                peso_fontes_recursos, 
                transparencia_osc
            ) 
            VALUES (
                id_osc_req, 
                transpararencia.transparencia_dados_gerais, 
                transpararencia.peso_dados_gerais, 
                transpararencia.transparencia_area_atuacao, 
                transpararencia.peso_area_atuacao, 
                transpararencia.transparencia_descricao, 
                transpararencia.peso_descricao, 
                transpararencia.transparencia_titulos_certificacoes, 
                transpararencia.peso_titulos_certificacoes, 
                transpararencia.transparencia_relacoes_trabalho_governanca, 
                transpararencia.peso_relacoes_trabalho_governanca, 
                transpararencia.transparencia_espacos_participacao_social, 
                transpararencia.peso_espacos_participacao_social, 
                transpararencia.transparencia_projetos_atividades_programas, 
                transpararencia.peso_projetos_atividades_programas, 
                transpararencia.transparencia_fontes_recursos, 
                transpararencia.peso_fontes_recursos, 
                transpararencia.transparencia_osc
            );
	END LOOP;
	
END;
$$ LANGUAGE 'plpgsql';
