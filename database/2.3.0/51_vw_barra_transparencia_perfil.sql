DROP MATERIALIZED VIEW IF EXISTS portal.vw_barra_transparencia CASCADE;

CREATE MATERIALIZED VIEW portal.vw_barra_transparencia AS 
SELECT d.id_osc, x.dados_gerais, x.areas_subareas_atuacao_osc, x.descricao_osc,
x.titulos_certificacoes, x.relacoes_trabalho_governanca, x.espacos_participacao_social, 
cast(x.projetos_atividades_programas as numeric(7,2)),
x.fontes_recursos_osc, 
(SELECT CAST((x.dados_gerais + x.areas_subareas_atuacao_osc + x.descricao_osc +
x.titulos_certificacoes + x.relacoes_trabalho_governanca +
x.espacos_participacao_social + x.projetos_atividades_programas + x.fontes_recursos_osc) AS NUMERIC(7,2))) as "Total" 
from (SELECT
 (  (CASE WHEN NOT(d.tx_nome_fantasia_osc is null) THEN 1 ELSE 0 END) +
  (CASE WHEN NOT(d.tx_sigla_osc is null) THEN 1 ELSE 0 END) +
  (CASE WHEN NOT(d.tx_nome_situacao_imovel_osc is null) THEN 1 ELSE 0 END) +
  (CASE WHEN NOT(d.tx_nome_responsavel_legal is null) THEN 3 ELSE 0 END) +
  (CASE WHEN NOT(d.dt_ano_cadastro_cnpj is null) THEN 1 ELSE 0 END) +
  (CASE WHEN NOT(d.dt_fundacao_osc is null) THEN 2 ELSE 0 END) +
  (CASE WHEN NOT(d.tx_email is null) THEN 1 ELSE 0 END) +
  (CASE WHEN NOT(d.tx_resumo_osc is null) THEN 4 ELSE 0 END) +
  (CASE WHEN NOT(d.tx_site is null) THEN 2 ELSE 0 END) +
  (CASE WHEN NOT(d.tx_telefone is null) THEN 4 ELSE 0 END)
 ) dados_gerais, 
 (SELECT
 ((CASE WHEN NOT(a.tx_nome_area_atuacao is null) OR NOT(tx_nome_area_atuacao_outra is null) THEN 15 ELSE 0 END)
 )) areas_subareas_atuacao_osc,
 (SELECT
 ((CASE WHEN NOT(des.tx_historico is null) THEN 3 ELSE 0 END) + 
 (CASE WHEN NOT(des.tx_missao_osc is null) THEN 1 ELSE 0 END) + 
 (CASE WHEN NOT(des.tx_visao_osc is null) THEN 1 ELSE 0 END) + 
 (CASE WHEN NOT(des.tx_finalidades_estatutarias is null) THEN 4.5 ELSE 0 END) + 
 (CASE WHEN NOT(des.tx_link_estatuto_osc is null) THEN 0.5 ELSE 0 END)
 )) descricao_osc,
 (SELECT
 ((CASE WHEN NOT(c.tx_nome_certificado is null) THEN 5 ELSE 0 END)
 )) titulos_certificacoes,
 (SELECT
 ((CASE WHEN NOT(dir.tx_cargo_dirigente is null) AND NOT(dir.tx_nome_dirigente is null) THEN 9 ELSE 0 END) +
  (CASE WHEN NOT(cf.tx_nome_conselheiro is null) THEN 3 ELSE 0 END) +
  (CASE WHEN NOT(t.nr_trabalhadores_voluntarios is null) THEN 3 ELSE 0 END)
 )) relacoes_trabalho_governanca,
 (SELECT
 (  (CASE WHEN NOT(cons.tx_nome_conselho is null) THEN 1 ELSE 0 END) +
    (CASE WHEN NOT(cons.tx_nome_tipo_participacao is null) THEN 1 ELSE 0 END) +
    (CASE WHEN NOT(r.tx_nome_representante_conselho is null) THEN 1 ELSE 0 END) +
    (CASE WHEN NOT(cons.tx_nome_periodicidade_reuniao_conselho is null) THEN 1 ELSE 0 END) +
    (CASE WHEN NOT(cons.dt_data_inicio_conselho is null) THEN 1 ELSE 0 END) +
    (CASE WHEN NOT(cons.dt_data_fim_conselho is null) THEN 1 ELSE 0 END) +
    (CASE WHEN NOT(conf.tx_nome_conferencia is null) THEN 1 ELSE 0 END) +
    (CASE WHEN NOT(conf.dt_ano_realizacao is null) THEN 1 ELSE 0 END) +
    (CASE WHEN NOT(conf.tx_nome_forma_participacao_conferencia is null) THEN 1 ELSE 0 END) +
    (CASE WHEN NOT(outra.tx_nome_participacao_social_outra is null) THEN 1 ELSE 0 END)
 )) espacos_participacao_social,
 (SELECT
 ((CASE WHEN NOT(p.tx_descricao_projeto is null) THEN 1.111111111111111 ELSE 0 END) +
  (CASE WHEN NOT(p.tx_nome_status_projeto is null) THEN 1.111111111111111 ELSE 0 END) +
  (CASE WHEN NOT(p.dt_data_inicio_projeto is null) THEN 1.111111111111111 ELSE 0 END) +
  (CASE WHEN NOT(p.dt_data_fim_projeto is null) THEN 1.111111111111111 ELSE 0 END) +
  (CASE WHEN NOT(p.tx_link_projeto is null) THEN 1.111111111111111 ELSE 0 END) +
  (CASE WHEN NOT(p.nr_total_beneficiarios is null) THEN 1.111111111111111 ELSE 0 END) +
  (CASE WHEN NOT(p.nr_valor_total_projeto is null) THEN 1.111111111111111 ELSE 0 END) +
  (CASE WHEN NOT(p.nr_valor_captado_projeto is null) THEN 1.111111111111111 ELSE 0 END) +
  (CASE WHEN NOT(f.tx_nome_origem_fonte_recursos_projeto is null) THEN 1.111111111111111 ELSE 0 END) +
  (CASE WHEN NOT(p.tx_nome_abrangencia_projeto is null) THEN 1.111111111111111 ELSE 0 END) +
  (CASE WHEN NOT(p.tx_nome_zona_atuacao is null) THEN 1.111111111111111 ELSE 0 END) +
  (CASE WHEN NOT(pub.tx_nome_publico_beneficiado is null) THEN 1.111111111111111 ELSE 0 END) +
  (CASE WHEN NOT(par.tx_nome_osc_parceira_projeto is null) THEN 1.111111111111111 ELSE 0 END) +
  (CASE WHEN NOT(ap.tx_nome_area_atuacao_projeto is null) THEN 1.111111111111111 ELSE 0 END) +
  (CASE WHEN NOT(fin.tx_nome_financiador is null) THEN 1.111111111111111 ELSE 0 END) +
  (CASE WHEN NOT(p.tx_metodologia_monitoramento is null) THEN 1.111111111111111 ELSE 0 END) +
  (CASE WHEN NOT(o.tx_nome_objetivo_projeto is null) THEN 1.111111111111111 ELSE 0 END) +
  (CASE WHEN NOT(o.tx_nome_meta_projeto is null) THEN 1.111111111111111 ELSE 0 END)
 )) projetos_atividades_programas,
 (SELECT
 ((CASE WHEN NOT(rec.tx_nome_origem_fonte_recursos_osc is null) AND (rec.tx_nome_origem_fonte_recursos_osc = 'Recursos públicos') THEN 1.25 ELSE 0 END) +
  (CASE WHEN NOT(rec.tx_nome_origem_fonte_recursos_osc is null) AND (rec.tx_nome_origem_fonte_recursos_osc = 'Recursos privados') THEN 1.25 ELSE 0 END) +
  (CASE WHEN NOT(rec.tx_nome_origem_fonte_recursos_osc is null) AND (rec.tx_nome_origem_fonte_recursos_osc = 'Recursos não financeiros') THEN 1.25 ELSE 0 END) +
  (CASE WHEN NOT(rec.tx_nome_origem_fonte_recursos_osc is null) AND (rec.tx_nome_origem_fonte_recursos_osc = 'Recursos próprios') THEN 1.25 ELSE 0 END)
 )) fontes_recursos_osc
FROM
 portal.vw_osc_dados_gerais as d left join 
 portal.vw_osc_area_atuacao as a on a.id_osc = d.id_osc left join
 portal.vw_osc_descricao as des on des.id_osc = d.id_osc left join
 portal.vw_osc_certificado as c on c.id_osc = d.id_osc left join
 portal.vw_osc_governanca as dir on dir.id_osc = d.id_osc left join
 portal.vw_osc_conselho_fiscal as cf on cf.id_osc = d.id_osc left join
 portal.vw_osc_relacoes_trabalho as t on t.id_osc = d.id_osc left join
 portal.vw_osc_participacao_social_conselho as cons on cons.id_osc = d.id_osc left join 
 portal.vw_osc_representante_conselho as r on r.id_osc = d.id_osc left join
 portal.vw_osc_participacao_social_conferencia as conf on conf.id_osc = d.id_osc left join
 portal.vw_osc_participacao_social_outra as outra on outra.id_osc = d.id_osc left join
 portal.vw_osc_projeto as p on p.id_osc = d.id_osc left join 
 portal.vw_osc_fonte_recursos_projeto as f on f.id_projeto = p.id_projeto left join
 portal.vw_osc_publico_beneficiado_projeto as pub on pub.id_projeto = f.id_projeto left join
 portal.vw_osc_parceira_projeto as par on par.id_projeto = pub.id_projeto left join
 portal.vw_osc_area_atuacao_projeto as ap on ap.id_projeto = par.id_projeto left join
 portal.vw_osc_financiador_projeto as fin on fin.id_projeto = ap.id_projeto left join
 portal.vw_osc_objetivo_projeto as o on o.id_projeto = fin.id_projeto left join
 portal.vw_osc_recursos_osc as rec on rec.id_osc = d.id_osc
 limit 1) x;
 
ALTER MATERIALIZED VIEW portal.vw_barra_transparencia OWNER TO postgres;
