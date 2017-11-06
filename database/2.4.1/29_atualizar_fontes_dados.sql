DO $$ 
BEGIN 
	SELECT * FROM syst.atualizar_fontes_dados_geral('1', 'Representante de OSC');
	SELECT * FROM syst.atualizar_fontes_dados_geral('3', 'Galileo');
	SELECT * FROM syst.atualizar_fontes_dados_geral('Representante', 'Representante de OSC');
	SELECT * FROM syst.atualizar_fontes_dados_geral('Siconv', 'MPOG/SICONV');
	
	SELECT * FROM syst.atualizar_fontes_dados_geral('Siconv', 'SICONV');
	SELECT * FROM syst.atualizar_fontes_dados_geral('Siconv', 'SICONV');

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
