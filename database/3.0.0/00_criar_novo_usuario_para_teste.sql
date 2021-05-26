  insert into
      portal.tb_usuario (
        cd_tipo_usuario,
        tx_email_usuario,
        tx_senha_usuario,
        tx_nome_usuario,
        nr_cpf_usuario,
        bo_lista_email,
        bo_ativo,
        dt_cadastro,
        dt_atualizacao,
        bo_email_confirmado,
        bo_lista_atualizacao_anual,
        bo_lista_atualizacao_trimestral
        )
  values (
      2,
      'teste3@gmail.com',
      'dd5fef9c1c1da1394d6d34b248c51be2ad740840',
      'Usuário Teste 3',
      46857256322,
      true,
      true,
      '2017-01-09 15:16:46.846736',
      '2019-11-18 15:54:11.971385',
      true,
      false,
      false
    );