SELECT * FROM portal.inserir_parceria_estado_municipio(
	'?'::INTEGER, 
	'?'::INTEGER, 
	'?'::TEXT, 
	'?'::DATE, 
	'?'::DATE, 
	'?'::DOUBLE PRECISION, 
	'?'::DOUBLE PRECISION, 
	'?'::TEXT, 
	'?'::INTEGER, 
	'?'::TEXT, 
	'?'::TEXT, 
	'?'::INTEGER, 
	'?'::INTEGER, 
	'?'::TEXT, 
	'?'::TEXT
);



Field name to be used as argument
id_osc
numero_parceria
nome_parceria
data_inicio
data_conclusao
valor_pago
valor_total
objeto_parceria
situacao_parceria_ajustado
situacao_parceria_outro
orgao_concedente
fonte_recursos
tipo_parceria_ajustado
tipo_parceria_outro
usuario



SELECT edmu_cd_municipio, COUNT(*) AS count 
FROM spat.vw_spat_municipio 
WHERE document @@ to_tsquery('portuguese_unaccent', '?'::TEXT) 
AND 
(
	SIMILARITY(vw_spat_municipio.edmu_nm_municipio::TEXT, '?'::TEXT) > 0.75 
	OR 
	SIMILARITY(vw_spat_municipio.edmu_nm_municipio::TEXT, '?'::TEXT) > 0.75 
);