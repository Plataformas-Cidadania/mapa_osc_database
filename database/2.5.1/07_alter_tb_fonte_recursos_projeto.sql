INSERT INTO osc.tb_tipo_parceria_projeto(id_projeto, cd_origem_fonte_recursos_projeto, cd_tipo_parceria_projeto, ft_tipo_parceria_projeto) 
SELECT id_projeto, 1, cd_tipo_parceria, ft_tipo_parceria FROM osc.tb_fonte_recursos_projeto WHERE cd_tipo_parceria IS NOT NULL;

ALTER TABLE osc.tb_fonte_recursos_projeto DROP COLUMN cd_tipo_parceria;
ALTER TABLE osc.tb_fonte_recursos_projeto DROP COLUMN ft_tipo_parceria;