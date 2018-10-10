Select a.id_osc, c.tx_nome_fonte_recursos_osc, 
       dt_ano_recursos_osc, nr_valor_recursos_osc, tx_nome_origem_fonte_recursos_osc
  FROM osc.tb_osc a
  join osc.tb_recursos_osc b on a.id_osc = b.id_osc
  join syst.dc_fonte_recursos_osc c on b.cd_fonte_recursos_osc = c.cd_fonte_recursos_osc
  left join syst.dc_origem_fonte_recursos_osc d on b.cd_origem_fonte_recursos_osc = d.cd_origem_fonte_recursos_osc 
where a.bo_osc_ativa
and a.id_osc not in (789809,987654)