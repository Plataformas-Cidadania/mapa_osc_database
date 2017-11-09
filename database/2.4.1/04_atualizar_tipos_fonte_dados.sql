DO $$ 
BEGIN 
	DELETE FROM syst.dc_fonte_dados 
	WHERE cd_sigla_fonte_dados = 'Representate' OR cd_sigla_fonte_dados = 'Representante';
		
	INSERT INTO syst.dc_fonte_dados (cd_sigla_fonte_dados, tx_nome_fonte_dados, tx_descricao_fonte_dados, tx_referencia_fonte_dados, nr_prioridade) 
	VALUES (
		'Administrador',
		'Administrador do Sistema',
		'Dado inserido por um administrador do sistema',
		null, 
		1
	);
	
	INSERT INTO syst.dc_fonte_dados (cd_sigla_fonte_dados, tx_nome_fonte_dados, tx_descricao_fonte_dados, tx_referencia_fonte_dados, nr_prioridade) 
	VALUES (
		'Representante de Governo Estadual',
		'Representante de Governo Estadual',
		'Dados inserido por representante de governo estadual',
		null, 
		7
	);
	
	INSERT INTO syst.dc_fonte_dados (cd_sigla_fonte_dados, tx_nome_fonte_dados, tx_descricao_fonte_dados, tx_referencia_fonte_dados, nr_prioridade) 
	VALUES (
		'Representante de Governo Municipal',
		'Representante de Governo Municipal',
		'Dados inserido por representante de governo municipal',
		null, 
		7
	);
	
	INSERT INTO syst.dc_fonte_dados (cd_sigla_fonte_dados, tx_nome_fonte_dados, tx_descricao_fonte_dados, tx_referencia_fonte_dados, nr_prioridade) 
	VALUES (
		'Galileo',
		'Galileo',
		'Dado originado pelo sistema de georreferenciamento Galileo',
		null, 
		6
	);
	
	INSERT INTO syst.dc_fonte_dados (cd_sigla_fonte_dados, tx_nome_fonte_dados, tx_descricao_fonte_dados, tx_referencia_fonte_dados, nr_prioridade) 
	VALUES (
		'CNPJ/SRF/MF', 
		'Cadastro Nacional de Pessoas Jurídicas da Secretaria da Receita Federal', 
		null, 
		null, 
		2
	);
	
	INSERT INTO syst.dc_fonte_dados (cd_sigla_fonte_dados, tx_nome_fonte_dados, tx_descricao_fonte_dados, tx_referencia_fonte_dados) 
	VALUES (
		'CADSOL/MTE', 
		'Cadastro Nacional de Economia Solidária',  
		null, 
		null, 
		6
	);
	
	UPDATE syst.dc_fonte_dados 
	SET	cd_sigla_fonte_dados = 'Representante de OSC', 
		tx_nome_fonte_dados = 'Representante de Organização da Sociedade Cívil', 
		tx_descricao_fonte_dados = 'Dado inserido por um representante de Organização da Sociedade Cívil no Mapa da Organização da Sociedade Cívil', 
		nr_prioridade = 8 
	WHERE cd_sigla_fonte_dados = 'Representate' OR cd_sigla_fonte_dados = 'Representante';
	
	UPDATE syst.dc_fonte_dados 
	SET	cd_sigla_fonte_dados = 'FINEP/FNDCT/MCTI' 
	WHERE cd_sigla_fonte_dados = 'FNDCT/FINEP';
	
	UPDATE syst.dc_fonte_dados 
	SET	cd_sigla_fonte_dados = 'MCMV-E/MCID' 
	WHERE cd_sigla_fonte_dados = 'MCID/MCMV-E';
	
	UPDATE syst.dc_fonte_dados 
	SET	cd_sigla_fonte_dados = 'Base/MDS' 
	WHERE cd_sigla_fonte_dados = 'MDS/Base';
	
	UPDATE syst.dc_fonte_dados 
	SET	cd_sigla_fonte_dados = 'CEBAS/MDS' 
	WHERE cd_sigla_fonte_dados = 'MDS/CEBAS';
	
	UPDATE syst.dc_fonte_dados 
	SET	cd_sigla_fonte_dados = 'Censo SUAS/MDS' 
	WHERE cd_sigla_fonte_dados = 'MDS/Censo SUAS';
	
	UPDATE syst.dc_fonte_dados 
	SET	cd_sigla_fonte_dados = 'CEBAS/MEC' 
	WHERE cd_sigla_fonte_dados = 'MEC/CEBAS';
	
	UPDATE syst.dc_fonte_dados 
	SET	cd_sigla_fonte_dados = 'LIE/MESP' 
	WHERE cd_sigla_fonte_dados = 'MESP/LIE';
	
	UPDATE syst.dc_fonte_dados 
	SET	cd_sigla_fonte_dados = 'SALICWEB/MINC' 
	WHERE cd_sigla_fonte_dados = 'MINC/SALICWEB';
	
	UPDATE syst.dc_fonte_dados 
	SET	cd_sigla_fonte_dados = 'OSCIP/MJ' 
	WHERE cd_sigla_fonte_dados = 'MJ/CNES/OSCIP';
	
	UPDATE syst.dc_fonte_dados 
	SET	cd_sigla_fonte_dados = 'UPF/MJ' 
	WHERE cd_sigla_fonte_dados = 'MJ/CNES/UPF';
	
	UPDATE syst.dc_fonte_dados 
	SET	cd_sigla_fonte_dados = 'CNEA/MMA' 
	WHERE cd_sigla_fonte_dados = 'MMA/CNEA';
	
	UPDATE syst.dc_fonte_dados 
	SET	cd_sigla_fonte_dados = 'SICONV/MPOG' 
	WHERE cd_sigla_fonte_dados = 'MPOG/SICONV';
	
	UPDATE syst.dc_fonte_dados 
	SET	cd_sigla_fonte_dados = 'CEBAS/MS' 
	WHERE cd_sigla_fonte_dados = 'MS/CEBAS';
	
	UPDATE syst.dc_fonte_dados 
	SET	cd_sigla_fonte_dados = 'SUS/MS' 
	WHERE cd_sigla_fonte_dados = 'MS/SUS';
	
	UPDATE syst.dc_fonte_dados 
	SET	cd_sigla_fonte_dados = 'RAIS/MTE' 
	WHERE cd_sigla_fonte_dados = 'MTE/RAIS';
	
	UPDATE syst.dc_fonte_dados 
	SET	cd_sigla_fonte_dados = 'Representante de OSC' 
	WHERE cd_sigla_fonte_dados = 'Representate';
	
	UPDATE syst.dc_fonte_dados 
	SET	cd_sigla_fonte_dados = 'Conselhos/SGPR' 
	WHERE cd_sigla_fonte_dados = 'SGPR/Conselhos';

EXCEPTION
	WHEN others THEN
		RAISE NOTICE '(%) %', SQLSTATE, SQLERRM;

END;
$$ LANGUAGE 'plpgsql';
