ALTER TABLE osc.tb_participacao_social_conselho_outro DISABLE TRIGGER ALL;

UPDATE osc.tb_participacao_social_conselho_outro
 set ft_nome_conselho = 'Representante de OSC'
	where ft_nome_conselho = 'Representante';
	
ALTER TABLE osc.tb_participacao_social_conselho_outro ENABLE TRIGGER ALL;