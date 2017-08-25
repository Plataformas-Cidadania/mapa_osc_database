DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_relacoes_trabalho_governanca(idosc INTEGER);

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_relacoes_trabalho_governanca(idosc INTEGER) RETURNS TABLE (
	transparencia NUMERIC
) AS $$ 

DECLARE 
	linha RECORD;
	contador_linha INTEGER;
	contador_transparencia DOUBLE PRECISION;

BEGIN 
	transparencia := 0;
	contador_linha := 0;
	contador_transparencia := 0;
	
	FOR linha IN
        SELECT 
			(
				(CASE WHEN NOT(relacoes_trabalho.nr_trabalhadores_voluntarios IS NULL) THEN 3 ELSE 0 END) + 
				(CASE WHEN NOT(governanca.tx_cargo_dirigente IS NULL) AND NOT(governanca.tx_nome_dirigente is null) THEN 9 ELSE 0 END) + 
				(CASE WHEN NOT(conselho_fiscal.tx_nome_conselheiro IS NULL) THEN 3 ELSE 0 END)
			) AS transparencia_linha 
		FROM 
			portal.vw_osc_relacoes_trabalho AS relacoes_trabalho FULL JOIN 
			portal.vw_osc_governanca AS governanca ON relacoes_trabalho.id_osc = governanca.id_osc FULL JOIN 
			portal.vw_osc_conselho_fiscal AS conselho_fiscal ON relacoes_trabalho.id_osc = conselho_fiscal.id_osc 
		WHERE relacoes_trabalho.id_osc = idosc 
    LOOP 
		contador_linha := contador_linha + 1;
        contador_transparencia := contador_transparencia + COALESCE(linha.transparencia_linha, 0);
    END LOOP;
	
	IF contador_linha > 0 THEN
		transparencia := contador_transparencia / contador_linha;
	END IF;
	
	transparencia := CAST(transparencia AS NUMERIC(7,2));
	
	RETURN NEXT;
END;

$$ LANGUAGE 'plpgsql';




DROP FUNCTION IF EXISTS portal.obter_barra_transparencia_relacoes_trabalho_governanca();

CREATE OR REPLACE FUNCTION portal.obter_barra_transparencia_relacoes_trabalho_governanca() RETURNS TABLE (
	id_osc INTEGER, 
	transparencia NUMERIC
) AS $$ 

BEGIN 
	RETURN QUERY 
        SELECT 
			relacoes_trabalho.id_osc, 
			(CAST(SUM(
				(CASE WHEN NOT(relacoes_trabalho.nr_trabalhadores_voluntarios IS NULL) THEN 3 ELSE 0 END) + 
				(CASE WHEN NOT(governanca.tx_cargo_dirigente IS NULL) AND NOT(governanca.tx_nome_dirigente is null) THEN 9 ELSE 0 END) + 
				(CASE WHEN NOT(conselho_fiscal.tx_nome_conselheiro IS NULL) THEN 3 ELSE 0 END)
			) / COUNT(*) AS NUMERIC(7, 2))) 
		FROM 
			portal.vw_osc_relacoes_trabalho AS relacoes_trabalho FULL JOIN 
			portal.vw_osc_governanca AS governanca ON relacoes_trabalho.id_osc = governanca.id_osc FULL JOIN 
			portal.vw_osc_conselho_fiscal AS conselho_fiscal ON relacoes_trabalho.id_osc = conselho_fiscal.id_osc 
		GROUP BY 
			relacoes_trabalho.id_osc;
END;

$$ LANGUAGE 'plpgsql';
