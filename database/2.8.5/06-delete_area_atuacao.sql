ALTER TABLE osc.tb_area_atuacao DISABLE TRIGGER ALL ;
delete FROM osc.tb_area_atuacao where id_osc in
(SELECT id_osc
FROM ( SELECT id_osc, cd_area_atuacao, cd_subarea_atuacao,
row_number() OVER(PARTITION BY id_osc,cd_area_atuacao, cd_subarea_atuacao) N
FROM portal.vw_osc_area_atuacao
where cd_subarea_atuacao is null ) as A
WHERE N > 1
order by id_osc);
ALTER TABLE osc.tb_area_atuacao ENABLE TRIGGER ALL ;
REFRESH MATERIALIZED VIEW portal.vw_osc_area_atuacao ;