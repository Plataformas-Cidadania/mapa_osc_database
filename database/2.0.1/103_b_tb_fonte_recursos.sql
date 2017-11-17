
DELETE FROM osc.tb_recursos_osc;

DELETE FROM syst.dc_fonte_recursos_osc;

DELETE FROM syst.dc_origem_fonte_recursos_osc;

SELECT setval('syst.dc_origem_fonte_recursos_osc', max(cd_origem_fonte_recursos_osc))
FROM syst.dc_origem_fonte_recursos_osc;

INSERT INTO syst.dc_origem_fonte_recursos_osc (cd_origem_fonte_recursos_osc, tx_nome_origem_fonte_recursos_osc)
VALUES (1,'Recursos públicos'),
(2,'Recursos privados'),
(3,'Recursos não financeiros'),
(4,'Recursos próprios');

SELECT setval('syst.dc_fonte_recursos_osc', max(cd_origem_fonte_recursos_osc))
FROM syst.dc_fonte_recursos_osc;

INSERT INTO syst.dc_fonte_recursos_osc (cd_origem_fonte_recursos_osc, tx_nome_fonte_recursos_osc)
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
(4,'Rendimentos de fundos patrimoniais'),
(4,'Rendimentos financeiros de reservas ou contas correntes  próprias'),
(4,'Mensalidades ou contribuições de associados'),
(4,'Prêmios recebidos'),
(4,'Venda de produtos'),
(4,'Prestação de serviços'),
(4,'Venda de bens e direitos'),
(3,'Voluntariado'),
(3,'Isenções'),
(3,'Imunidades'),
(3,'Bens recebidos em direito de uso'),
(3,'Doações recebidas na forma de produtos e serviços (sem Nota Fiscal)');
