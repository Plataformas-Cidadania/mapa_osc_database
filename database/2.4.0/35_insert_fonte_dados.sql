UPDATE syst.dc_fonte_dados 
SET nr_prioridade = 1 
WHERE cd_sigla_fonte_dados = 'Administrador';

UPDATE syst.dc_fonte_dados 
SET nr_prioridade = 2 
WHERE cd_sigla_fonte_dados = 'MJ/CNES/OSCIP';

UPDATE syst.dc_fonte_dados 
SET nr_prioridade = 3 
WHERE cd_sigla_fonte_dados = 'MTE/RAIS';

UPDATE syst.dc_fonte_dados 
SET nr_prioridade = 4 
WHERE cd_sigla_fonte_dados = 'MPOG/SICONV';

UPDATE syst.dc_fonte_dados 
SET nr_prioridade = 5 
WHERE cd_sigla_fonte_dados = 'FNDCT/FINEP' 
OR cd_sigla_fonte_dados = 'MCID/MCMV-E' 
OR cd_sigla_fonte_dados = 'MDS/Base' 
OR cd_sigla_fonte_dados = 'MDS/CEBAS' 
OR cd_sigla_fonte_dados = 'MDS/Censo SUAS' 
OR cd_sigla_fonte_dados = 'MEC/CEBAS' 
OR cd_sigla_fonte_dados = 'MESP/LIE' 
OR cd_sigla_fonte_dados = 'MINC/SALICWEB' 
OR cd_sigla_fonte_dados = 'MJ/CNES/UPF' 
OR cd_sigla_fonte_dados = 'MMA/CNEA' 
OR cd_sigla_fonte_dados = 'MS/CEBAS' 
OR cd_sigla_fonte_dados = 'MS/SUS' 
OR cd_sigla_fonte_dados = 'SGPR/Conselhos';

UPDATE syst.dc_fonte_dados 
SET nr_prioridade = 6 
WHERE cd_sigla_fonte_dados = 'Representante de Governo Estadual' 
OR cd_sigla_fonte_dados = 'Representante de Governo Municipal';

UPDATE syst.dc_fonte_dados 
SET nr_prioridade = 7 
WHERE cd_sigla_fonte_dados = 'Representante de OSC';

UPDATE syst.dc_fonte_dados 
SET nr_prioridade = 8 
WHERE cd_sigla_fonte_dados = 'Galileo';
