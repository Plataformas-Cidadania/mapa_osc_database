DROP TABLE IF EXISTS portal.tb_perfil;

CREATE TABLE portal.tb_perfil
(
    id INTEGER NOT NULL,
    nome TEXT,
    tipo_localidade TEXT,
    series JSONB,
    fontes TEXT[],
    CONSTRAINT pk_tb_perfil PRIMARY KEY (id)
);
