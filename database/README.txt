Comando para restaurar o banco de dados no formato text:

	psql -U [USER] [DATABASE_NAME] < [FILE_DUMP]

Comando para conectar ao banco com psql:
	
	psql -h [HOST] -p [PORT] -d [DATABASE_NAME] -U [USER]

Execute o script decria��o do banco:

	mapaosc.sql

Execute o script de configura��o do banco:

	config.sql

Execute o script de cria��o das view:

	views.sql

Execute o script de cria��o dos �ndices:

	index.sql

Execute o script de cria��o das functions:

	functions.sql