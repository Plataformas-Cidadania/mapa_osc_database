ALTER SEQUENCE syst.dc_fonte_recursos_projeto_cd_fonte_recursos_projeto_seq RESTART WITH 1;

DELETE FROM syst.dc_fonte_recursos_projeto;

INSERT INTO syst.dc_fonte_recursos_projeto (cd_origem_fonte_recursos_projeto, tx_nome_fonte_recursos_projeto)
VALUES (1,'Parceria com o governo federal'),
(1,'Parceria com o governo estadual'),
(1,'Parceria com o governo municipal'),
(1,'Acordo com organismos multilaterais'),
(1,'Acordo com governos estrangeiros'),
(1,'Empresas públicas ou sociedades de economia mista'),
(2,'Parceria com OSCs brasileiras'),
(2,'Parcerias com OSCs estrangeiras'),
(2,'Parcerias com organizações religiosas brasileiras'),
(2,'Parcerias com organizações religiosas estrangeiras'),
(2,'Empresas privadas brasileiras'),
(2,'Empresas estrangeiras'),
(2,'Doações de pessoa jurídica'),
(2,'Doações de pessoa física'),
(2,'Doações recebidas na forma de produtos e serviços (com Nota Fiscal)'),
(3,'Rendimentos de fundos patrimoniais'),
(3,'Rendimentos financeiros de reservas ou contas correntes  próprias'),
(3,'Mensalidades ou contribuições de associados'),
(3,'Prêmios recebidos'),
(3,'Venda de produtos'),
(3,'Prestação de serviços'),
(3,'Venda de bens e direitos'),
(4,'Voluntariado'),
(4,'Isenções'),
(4,'Imunidades'),
(4,'Bens recebidos em direito de uso'),
(4,'Doações recebidas na forma de produtos e serviços (sem Nota Fiscal)');
