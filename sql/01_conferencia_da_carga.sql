-- Conferência da carga das tabelas Gold no PostgreSQL (schema gold).
-- Executar depois de importar os CSVs e antes de qualquer análise.

-- 1) Contagem de linhas

SELECT 'fato_voos' AS tabela, 
    COUNT(*) AS registros 
FROM gold.fato_voos
UNION ALL

SELECT 'dim_aeroporto', 
    COUNT(*) 
FROM gold.dim_aeroporto;
-- Esperado: fato_voos = 1.014.705 | dim_aeroporto = 496 (igual à origem no Databricks)


-- 2) Estrutura: colunas e tipos das duas tabelas
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'gold'
  AND table_name IN ('fato_voos', 'dim_aeroporto')
ORDER BY table_name, ordinal_position;

-- 3) Integridade referencial: todo aeroporto usado em um voo existe na dimensão?
SELECT
    COUNT(*)                           AS aeroportos_na_fato,
    COUNT(d.icao_aeroporto)            AS encontrados_na_dim,
    COUNT(*) - COUNT(d.icao_aeroporto) AS nao_encontrados
FROM (
    SELECT icao_origem AS icao 
    FROM gold.fato_voos 
    WHERE icao_origem IS NOT NULL
    UNION

    SELECT icao_destino        
    FROM gold.fato_voos 
    WHERE icao_destino IS NOT NULL
) f
LEFT JOIN gold.dim_aeroporto d 
ON d.icao_aeroporto = f.icao;
-- Esperado: nao_encontrados = 0


-- 4) Se o item 3 encontrar ausentes: quais são e quantos voos afetam

SELECT x.icao, COUNT(*) AS voos
FROM (
    SELECT icao_origem AS icao FROM gold.fato_voos
    UNION ALL
    SELECT icao_destino        FROM gold.fato_voos
) x
LEFT JOIN gold.dim_aeroporto a ON a.icao_aeroporto = x.icao
WHERE a.icao_aeroporto IS NULL
GROUP BY x.icao
ORDER BY voos DESC
LIMIT 20;
-- Esperado: nenhuma linha