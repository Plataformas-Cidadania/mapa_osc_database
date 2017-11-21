DROP FUNCTION IF EXISTS portal.inserir_recursos_osc(idosc INTEGER, cdfonterecursos INTEGER, ftfonterecursos TEXT, dtanorecursos DATE, ftanorecursos TEXT, nrvalorrecursos DOUBLE PRECISION, ftvalorrecursos TEXT, bonaopossui BOOLEAN, ftnaopossui TEXT);

CREATE OR REPLACE FUNCTION portal.inserir_recursos_osc(idosc INTEGER, cdfonterecursos INTEGER, ftfonterecursos TEXT, dtanorecursos DATE, ftanorecursos TEXT, nrvalorrecursos DOUBLE PRECISION, ftvalorrecursos TEXT, bonaopossui BOOLEAN, ftnaopossui TEXT) RETURNS TABLE(
	flag BOOLEAN,
	mensagem TEXT
)AS $$

BEGIN
	INSERT INTO 
		osc.tb_recursos_osc(id_osc, cd_fonte_recursos_osc, ft_fonte_recursos_osc, dt_ano_recursos_osc, ft_ano_recursos_osc, nr_valor_recursos_osc, ft_valor_recursos_osc, bo_nao_possui, ft_nao_possui) 
	VALUES 
		(idosc, cdfonterecursos, ftfonterecursos, dtanorecursos, ftanorecursos, nrvalorrecursos, ftvalorrecursos, bonaopossui, ftnaopossui);
	
	flag := true;
	mensagem := 'Recursos de OSC inserido.';
	RETURN NEXT;

EXCEPTION 
	WHEN not_null_violation THEN
		flag := false;
		mensagem := 'Campo(s) obrigatório(s) não preenchido(s) na gravação de recursos de OSC no banco de dados.';
		RETURN NEXT;
		
	WHEN unique_violation THEN
		flag := false;
		mensagem := 'Dado(s) único(s) violado(s) na gravação de recursos de OSC no banco de dados.';
		RETURN NEXT;
		
	WHEN others THEN 
		flag := false;
		mensagem := 'Ocorreu um erro na gravação de recursos de OSC no banco de dados.';
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
