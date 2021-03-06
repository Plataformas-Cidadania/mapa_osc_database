DROP FUNCTION IF EXISTS portal.obter_grafico(TEXT);

CREATE OR REPLACE FUNCTION portal.obter_grafico(param TEXT) RETURNS TABLE (
	resultado JSONB, 
	mensagem TEXT, 
	codigo INTEGER
) AS $$ 

DECLARE 
	linha RECORD;

BEGIN 
	SELECT INTO linha 
		tb_analise.configuracao, 
		tb_tipo_grafico.nome_tipo_grafico AS tipo_grafico, 
		tb_analise.titulo, 
		tb_analise.legenda, 
		tb_analise.titulo_colunas, 
		tb_analise.legenda_x, 
		tb_analise.legenda_y, 
		tb_analise.series_1, 
		tb_analise.series_2, 
		tb_analise.fontes, 
		tb_analise.inverter_label, 
		tb_analise.slug
	FROM 
		portal.tb_analise 
	INNER JOIN 
		syst.tb_tipo_grafico 
	ON 
		tb_analise.tipo_grafico = tb_tipo_grafico.id_grafico  
	WHERE 
		tb_analise.id_analise = param::INTEGER 
	AND tb_analise.ativo;

	IF linha != (null::TEXT[], null::INTEGER, null::TEXT, null::TEXT, null::TEXT[], null::TEXT, null::TEXT, null::JSONB, null::JSONB, null::TEXT[], null::BOOLEAN, null::TEXT)::RECORD THEN 
		resultado := to_jsonb(linha);
		codigo := 200;
		mensagem := 'Dados de gráfico retornado.';
	ELSE 
		codigo := 404;
		mensagem := 'Gráfico não encontrada.';
	END IF;

	RETURN NEXT;
	
EXCEPTION
	WHEN others THEN 
		codigo := 400;
		SELECT INTO mensagem a.mensagem FROM portal.verificar_erro(SQLSTATE, SQLERRM, null, null, null, false, null) AS a;
		RETURN NEXT;
END;
$$ LANGUAGE 'plpgsql';
