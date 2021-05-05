SELECT tb_osc.id_osc as id,
       tb_osc.tx_apelido_osc as Apelido,
       tb_dados_gerais.tx_razao_social_osc,
       tb_osc.cd_identificador_osc as CNPJ_CEI,
       tb_osc.bo_osc_ativa as Ativa,
       tb_usuario.tx_nome_usuario as Representante,
       tb_usuario.nr_cpf_usuario as Usuario,
       tb_usuario.tx_email_usuario as email,
       tb_usuario.bo_ativo as UsuarioAtivo,
       tb_usuario.cd_tipo_usuario as TipoUsuario
FROM osc.tb_osc
JOIN osc.tb_dados_gerais ON osc.tb_osc.id_osc = osc.tb_dados_gerais.id_osc
JOIN portal.tb_representacao ON tb_osc.id_osc = tb_representacao.id_osc
JOIN portal.tb_usuario ON tb_representacao.id_usuario = tb_usuario.id_usuario
WHERE tb_osc.bo_osc_ativa and tb_usuario.bo_ativo
order by Apelido;