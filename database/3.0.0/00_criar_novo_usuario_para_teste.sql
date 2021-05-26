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
      'camila.escudero@ipea.gov.br',
      'dd5fef9c1c1da1394d6d34b248c51be2ad740840',
      'Camila',
      11111111111,
      true,
      true,
      '2017-01-09 15:16:46.846736',
      '2019-11-18 15:54:11.971385',
      true,
      false,
      false
    ),
     (
      2,
      'felix.lopez@ipea.gov.br',
      'dd5fef9c1c1da1394d6d34b248c51be2ad740840',
      'Felix',
      22222222222,
      true,
      true,
      '2017-01-09 15:16:46.846736',
      '2019-11-18 15:54:11.971385',
      true,
      false,
      false
    ),
         (
      2,
      'erivelton.guedes@ipea.gov.br',
      'dd5fef9c1c1da1394d6d34b248c51be2ad740840',
      'Erivelton',
      33333333333,
      true,
      true,
      '2017-01-09 15:16:46.846736',
      '2019-11-18 15:54:11.971385',
      true,
      false,
      false
    ),
    (
      2,
      'pedro.andrade@ipea.gov.br',
      'dd5fef9c1c1da1394d6d34b248c51be2ad740840',
      'Pedro',
      44444444444,
      true,
      true,
      '2017-01-09 15:16:46.846736',
      '2019-11-18 15:54:11.971385',
      true,
      false,
      false
    ),
    (
      2,
      'janine.mello@ipea.gov.br',
      'dd5fef9c1c1da1394d6d34b248c51be2ad740840',
      'Janine',
      55555555555,
      true,
      true,
      '2017-01-09 15:16:46.846736',
      '2019-11-18 15:54:11.971385',
      true,
      false,
      false
    ),
          (
      2,
      'ana.ribeiro@ipea.gov.br',
      'dd5fef9c1c1da1394d6d34b248c51be2ad740840',
      'Ana Camila',
      66666666666,
      true,
      true,
      '2017-01-09 15:16:46.846736',
      '2019-11-18 15:54:11.971385',
      true,
      false,
      false
    ),
     (
      2,
      'thiago.ramos@ipea.gov.br',
      'dd5fef9c1c1da1394d6d34b248c51be2ad740840',
      'Thiago',
      77777777777,
      true,
      true,
      '2017-01-09 15:16:46.846736',
      '2019-11-18 15:54:11.971385',
      true,
      false,
      false
    );

SELECT 789809, u.id_usuario FROM portal.tb_usuario u WHERE tx_email_usuario LIKE '%@ipea.gov.br';


insert into portal.tb_representacao (id_osc, id_usuario)
    SELECT 789809, u.id_usuario
    FROM portal.tb_usuario u
WHERE tx_email_usuario LIKE '%@ipea.gov.br';;