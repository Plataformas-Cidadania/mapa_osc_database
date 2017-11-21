DROP TABLE IF EXISTS portal.tb_peso_barra_transparencia;

CREATE TABLE portal.tb_peso_barra_transparencia
(
  id_peso_barra_transparencia SERIAL NOT NULL, -- Identificador do peso da barra de transparência
  nome_secao TEXT NOT NULL, -- Nome da seção do peso da barra de transparência
  peso_secao DOUBLE PRECISION NOT NULL -- Peso da barra de transparência
);
