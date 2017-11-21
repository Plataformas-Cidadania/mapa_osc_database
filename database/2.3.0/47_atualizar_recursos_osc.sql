DROP FUNCTION IF EXISTS portal.atualizar_recursos_osc(idrecursos INTEGER, idosc INTEGER, cdfonterecursos INTEGER, ftfonterecursos TEXT, dtanorecursos DATE, ftanorecursos TEXT, nrvalorrecursos DOUBLE PRECISION, ftvalorrecursos TEXT, bonaopossui BOOLEAN, ftnaopossui TEXT);

CREATE OR REPLACE FUNCTION portal.atualizar_recursos_osc(idrecursos INTEGER, idosc INTEGER, cdfonterecursos INTEGER, ftfonterecursos TEXT, dtanorecursos DATE, ftanorecursos TEXT, nrvalorrecursos DOUBLE PRECISION, ftvalorrecursos TEXT, bonaopossui BOOLEAN, ftnaopossui TEXT) RETURNS TABLE(
	flag BOOLEAN, 
	mensagem TEXT
)AS $$

BEGIN 
	UPDATE 
		osc.tb_recursos_osc 
	SET 
		id_osc = idosc, 
		cd_fonte_recursos_osc = cdfonterecursos, 
		ft_fonte_recursos_osc = ftfonterecursos, 
		dt_ano_recursos_osc = dtanorecursos, 
		ft_ano_recursos_osc = ftanorecursos, 
		nr_valor_recursos_osc = nrvalorrecursos, 
		ft_valor_recursos_osc = ftvalorrecursos, 
		bo_nao_possui = bonaopossui, 
		ft_nao_possui = ftnaopossui 
	WHERE 
		id_recursos_osc = idrecursos; 
	
	flag := true;
	mensagem := 'Recursos de OSC atualizado.';
	RETURN NEXT;

EXCEPTION 
	WHEN not_null_violation THEN
		flag := false;
		mensagem := 'Campo(s) obrigatório(s) não preenchido(s) na atualização de recursos de OSC no banco de dados.';
		RETURN NEXT;
		
	WHEN unique_violation THEN
		flag := false;
		mensagem := 'Dado(s) único(s) violado(s) na atualização de recursos de OSC no banco de dados.';
		RETURN NEXT;
		
	WHEN others THEN 
		flag := false;
		mensagem := 'Ocorreu um erro na atualização de recursos de OSC no banco de dados.';
		RETURN NEXT;

END;
$$ LANGUAGE 'plpgsql';
