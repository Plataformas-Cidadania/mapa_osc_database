-- Materialized View: portal.vw_osc_participacao_social_outra

DROP MATERIALIZED VIEW portal.vw_osc_participacao_social_outra;

CREATE MATERIALIZED VIEW portal.vw_osc_participacao_social_outra AS 
 SELECT tb_osc.id_osc,
    tb_osc.tx_apelido_osc,
    tb_participacao_social_outra.id_participacao_social_outra,
    tb_participacao_social_outra.tx_nome_participacao_social_outra,
    tb_participacao_social_outra.ft_participacao_social_outra,
    tb_participacao_social_outra.bo_nao_possui
   FROM osc.tb_osc
     JOIN osc.tb_participacao_social_outra ON tb_osc.id_osc = tb_participacao_social_outra.id_osc
  WHERE tb_osc.bo_osc_ativa
WITH DATA;

ALTER TABLE portal.vw_osc_participacao_social_outra
  OWNER TO postgres;
