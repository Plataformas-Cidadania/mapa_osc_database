DELETE FROM portal.tb_perfil_localidade;

INSERT INTO portal.tb_perfil_localidade (id_osc)
VALUES (
    SELECT id_osc
    FROM osc.tb_osc
    WHERE tb_osc.bo_osc_ativa
    AND id_osc <> 789809;
); 